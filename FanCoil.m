classdef FanCoil
    properties
        iteration
        id_heating_inlet
        id_heating_outlet
        id_cooling_inlet
        id_cooling_outlet
        id_air_inlet
        id_air_outlet
        id_zone
        time_step
        matrix_size
        matrix_coefficients
        right_hand_side_vector
        number_of_equations
        
        specific_heat_capacity_air
        specific_heat_capacity_cooling
        specific_heat_capacity_heating
        mass_flow_rate_air
        mass_flow_rate_cooling
        mass_flow_rate_heating
        status_heating
        status_cooling
        heat_transfer_coefficient_heating
        heat_transfer_coefficient_cooling
        surface_heating
        surface_cooling

        heating_capacitance_flows_air
        heating_capacitance_flows_water
        heating_capacitance_flows_min
        heating_capacitance_flows_max
        heating_capacitance_flows_ratio
        heating_number_of_transfer_unit
        heating_eta
        heating_effectiveness
        
        temperature_heating_inlet
        temperature_heating_outlet
        temperature_cooling_inlet
        temperature_cooling_outlet
        temperature_air_inlet
        temperature_air_outlet
        temperature_zone

    end
    
    methods
        function obj = FanCoil(id_heating_inlet, id_heating_outlet, id_cooling_inlet, id_cooling_outlet, id_air_inlet, id_air_outlet, id_zone, solver, specific_heat_capacity_air, specific_heat_capacity_cooling, specific_heat_capacity_heating, mass_flow_rate_air, mass_flow_rate_cooling, mass_flow_rate_heating, status_heating, status_cooling, heat_transfer_coefficient_heating, heat_transfer_coefficient_cooling, surface_heating, surface_cooling)

            if nargin > 0
                obj.id_heating_inlet = id_heating_inlet;
                obj.id_heating_outlet = id_heating_outlet;
                obj.id_cooling_inlet = id_cooling_inlet;
                obj.id_cooling_outlet = id_cooling_outlet;
                obj.id_air_inlet = id_air_inlet;
                obj.id_air_outlet = id_air_outlet;
                obj.id_zone = id_zone;
                obj.time_step = solver.time_step;
                obj.matrix_size = solver.matrix_size;
                
                obj.specific_heat_capacity_air = specific_heat_capacity_air;
                obj.specific_heat_capacity_cooling = specific_heat_capacity_cooling;
                obj.specific_heat_capacity_heating = specific_heat_capacity_heating;
                obj.mass_flow_rate_air = mass_flow_rate_air;
                obj.mass_flow_rate_cooling = mass_flow_rate_cooling;
                obj.mass_flow_rate_heating = mass_flow_rate_heating;
                obj.status_heating = status_heating;
                obj.status_cooling = status_cooling;
                obj.heat_transfer_coefficient_heating = heat_transfer_coefficient_heating;
                obj.heat_transfer_coefficient_cooling = heat_transfer_coefficient_cooling;
                obj.surface_heating = surface_heating;
                obj.surface_cooling = surface_cooling;

                % heating
                obj.heating_capacitance_flows_air = obj.specific_heat_capacity_air*obj.mass_flow_rate_air;
                obj.heating_capacitance_flows_water = obj.specific_heat_capacity_heating*obj.mass_flow_rate_heating;
                obj.heating_capacitance_flows_min = min(obj.heating_capacitance_flows_air, obj.heating_capacitance_flows_water);
                obj.heating_capacitance_flows_max = max(obj.heating_capacitance_flows_air, obj.heating_capacitance_flows_water);
                obj.heating_capacitance_flows_ratio = obj.heating_capacitance_flows_min / obj.heating_capacitance_flows_max;
                obj.heating_number_of_transfer_unit = obj.heat_transfer_coefficient_heating*obj.surface_heating/obj.heating_capacitance_flows_min;
                obj.heating_eta = obj.heating_number_of_transfer_unit^(-0.22);
                obj.heating_effectiveness = 1 - exp((exp(-obj.heating_number_of_transfer_unit*obj.heating_capacitance_flows_ratio*obj.heating_eta)-1)/obj.heating_capacitance_flows_ratio*obj.heating_eta);

                obj.iteration = 0;
                obj.number_of_equations = 3;
                obj.matrix_coefficients = zeros(obj.number_of_equations,solver.matrix_size);
                obj.right_hand_side_vector = zeros(obj.number_of_equations,1);

                obj.temperature_heating_inlet = solver.temperatures(obj.id_heating_inlet);
                obj.temperature_heating_outlet = solver.temperatures(obj.id_heating_outlet);
                obj.temperature_cooling_inlet = solver.temperatures(obj.id_cooling_inlet);
                obj.temperature_cooling_outlet = solver.temperatures(obj.id_cooling_outlet);
                obj.temperature_air_inlet = solver.temperatures(obj.id_air_inlet);
                obj.temperature_air_outlet = solver.temperatures(obj.id_air_outlet);
                obj.temperature_zone = solver.temperatures(obj.id_zone);
            end
        end
        
        function h = enthalpy(~, dry_bulb_temperature, humidity_ratio)
            humidity_ratio = max(humidity_ratio, 10^-5);
            h = 1004.84*dry_bulb_temperature + humidity_ratio*(2500940 + 1858.95*dry_bulb_temperature);
        end
        
        function c = c_tai1(obj)
            c = 1-obj.heating_effectiveness*obj.heating_capacitance_flows_min/obj.heating_capacitance_flows_air;
        end
        
        function c = c_tao1(~)
            c = - 1;
        end
        
        function c = c_thi1(~)
            c = obj.heating_effectiveness*obj.heating_capacitance_flows_min/obj.heating_capacitance_flows_air;
        end
        
        function c = c_r1(~)
            c = 0;
        end
        
        function c = c_thi2(~)
            c = 1;
        end
        
        function c = c_tho2(~)
            c = - 1;
        end
        
        function c = c_tai2(obj)
            c = obj.heating_capacitance_flows_air/obj.heating_capacitance_flows_water;
        end
        
        function c = c_tao2(obj)
            c = obj.heating_capacitance_flows_air/obj.heating_capacitance_flows_water;
        end
        
        function c = c_r2(~)
            c = 0;
        end
        
        % create matrix of coefficients and right-hand side vector
        function obj = create(obj, solver)
            obj.iteration = obj.iteration + 1;

            obj.temperature_heating_inlet = solver.temperatures(obj.id_heating_inlet);
            obj.temperature_heating_outlet = solver.temperatures(obj.id_heating_outlet);
            obj.temperature_cooling_inlet = solver.temperatures(obj.id_cooling_inlet);
            obj.temperature_cooling_outlet = solver.temperatures(obj.id_cooling_outlet);
            obj.temperature_air_inlet = solver.temperatures(obj.id_air_inlet);
            obj.temperature_air_outlet = solver.temperatures(obj.id_air_outlet);
            obj.temperature_zone = solver.temperatures(obj.id_zone);
            
            obj.matrix_coefficients = zeros(obj.number_of_equations,obj.matrix_size);
            obj.right_hand_side_vector = zeros(obj.number_of_equations,1);
            obj.matrix_coefficients(1,obj.id_air_inlet) = obj.c_tai1();
            obj.matrix_coefficients(1,obj.id_air_outlet) = obj.c_tao1();
            obj.matrix_coefficients(1,obj.id_heating_inlet) = obj.c_thi1();
            obj.matrix_coefficients(2,obj.id_air_inlet) = obj.c_tai2();
            obj.matrix_coefficients(2,obj.id_air_outlet) = obj.c_tao2();
            obj.matrix_coefficients(2,obj.id_heating_inlet) = obj.c_thi2();
            obj.matrix_coefficients(2,obj.id_heating_oulet) = obj.c_tho2();
        end



    end
end