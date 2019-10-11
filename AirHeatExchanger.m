classdef AirHeatExchanger
    properties
        iteration
        id_supply_inlet
        id_supply_outlet
        id_exhaust_inlet
        id_exhaust_outlet
        time_step
        matrix_size
        matrix_coefficients
        right_hand_side_vector
        number_of_equations

        specific_heat_capacity_supply
        specific_heat_capacity_exhaust
        mass_flow_rate_supply_nominal
        mass_flow_rate_supply
        mass_flow_rate_exhaust
        sensible_effectiveness_75
        sensible_effectiveness_100
        latent_effectiveness_75
        latent_effectiveness_100
        
        ratio_air_flow_rate_to_nominal
        operating_sensible_effectiveness
        operating_latent_effectiveness
        heating_capacitance_flows_supply
        heating_capacitance_flows_exhaust
        heating_capacitance_flows_minimum
        
        temperature_supply_inlet
        temperature_supply_outlet
        temperature_exhaust_inlet
        temperature_exhaust_outlet

    end
    
    methods
        function obj = AirHeatExchanger(id_supply_inlet, id_supply_outlet, id_exhaust_inlet, id_exhaust_outlet, solver, mass_flow_rate_supply_nominal, specific_heat_capacity_supply, specific_heat_capacity_exhaust, mass_flow_rate_supply, mass_flow_rate_exhaust, sensible_effectiveness_75, sensible_effectiveness_100, latent_effectiveness_75, latent_effectiveness_100)
            if nargin > 0
                obj.id_supply_inlet = id_supply_inlet;
                obj.id_supply_outlet = id_supply_outlet;
                obj.id_exhaust_inlet = id_exhaust_inlet;
                obj.id_exhaust_outlet = id_exhaust_outlet;
                obj.time_step = solver.time_step;
                obj.matrix_size = solver.matrix_size;
                obj.specific_heat_capacity_supply = specific_heat_capacity_supply;
                obj.specific_heat_capacity_exhaust = specific_heat_capacity_exhaust;
                obj.mass_flow_rate_supply_nominal = mass_flow_rate_supply_nominal;
                obj.mass_flow_rate_supply = mass_flow_rate_supply;
                obj.mass_flow_rate_exhaust = mass_flow_rate_exhaust;
                obj.sensible_effectiveness_75 = sensible_effectiveness_75;
                obj.sensible_effectiveness_100 = sensible_effectiveness_100;
                obj.latent_effectiveness_75 = latent_effectiveness_75;
                obj.latent_effectiveness_100 = latent_effectiveness_100;

                obj.ratio_air_flow_rate_to_nominal = mean(obj.mass_flow_rate_supply, obj.mass_flow_rate_exhaust)/obj.mass_flow_rate_supply_nominal;
                obj.operating_sensible_effectiveness = obj.sensible_effectiveness_75 + (obj.sensible_effectiveness_100 - obj.sensible_effectiveness_75)*(obj.ratio_air_flow_rate_to_nominal - 0.75)/0.25;
                obj.operating_latent_effectiveness = obj.latent_effectiveness_75 + (obj.latent_effectiveness_100 - obj.latent_effectiveness_75)*(obj.ratio_air_flow_rate_to_nominal - 0.75)/0.25;
                obj.heating_capacitance_flows_supply = obj.specific_heat_capacity_supply*obj.mass_flow_rate_supply;
                obj.heating_capacitance_flows_exhaust = obj.specific_heat_capacity_exhaust*obj.mass_flow_rate_exhaust;
                obj.heating_capacitance_flows_minimum = min(obj.heating_capacitance_flows_supply, obj.heating_capacitance_flows_exhaust);
                
                obj.iteration = 0;
                obj.number_of_equations = 2;
                obj.matrix_coefficients = zeros(obj.number_of_equations,solver.matrix_size);
                obj.right_hand_side_vector = zeros(obj.number_of_equations,1);

                obj.temperature_supply_inlet = solver.temperatures(id_supply_inlet);
                obj.temperature_supply_outlet = solver.temperatures(id_supply_outlet);
                obj.temperature_exhaust_inlet = solver.temperatures(id_exhaust_inlet);
                obj.temperature_exhaust_outlet = solver.temperatures(id_exhaust_outlet);
            end
        end

        function c = c_tsi1(obj)
            c = 1 - obj.operating_sensible_effectiveness*obj.heating_capacitance_flows_minimum/obj.heating_capacitance_flows_supply;
        end

        function c = c_tso1(~)
            c = - 1;
        end

        function c = c_tei1(obj)
            c = obj.operating_sensible_effectiveness*obj.heating_capacitance_flows_minimum/obj.heating_capacitance_flows_supply;
        end

        function c = c_tsi2(obj)
            c = obj.heating_capacitance_flows_supply/obj.heating_capacitance_flows_exhaust;
        end

        function c = c_tso2(obj)
            c = obj.heating_capacitance_flows_supply/obj.heating_capacitance_flows_exhaust;
        end

        function c = c_tei2(~)
            c = 1;
        end

        function c = c_teo2(~)
            c = -1;
        end

        % create matrix of coefficients and right-hand side vector
        function obj = create(obj, solver)
            obj.iteration = obj.iteration + 1;
            obj.matrix_coefficients = zeros(obj.number_of_equations,obj.matrix_size);
            obj.right_hand_side_vector = zeros(obj.number_of_equations,1);
            obj.temperature_supply_inlet = solver.temperatures(obj.id_supply_inlet);
            obj.temperature_supply_outlet = solver.temperatures(obj.id_supply_outlet);
            obj.temperature_exhaust_inlet = solver.temperatures(obj.id_exhaust_inlet);
            obj.temperature_exhaust_outlet = solver.temperatures(obj.id_exhaust_outlet);
            obj.matrix_coefficients(1,obj.id_supply_inlet) = obj.c_tsi1();
            obj.matrix_coefficients(1,obj.id_supply_outlet) = obj.c_tso1();
            obj.matrix_coefficients(1,obj.id_exhaust_inlet) = obj.c_tei1();
            obj.matrix_coefficients(2,obj.id_supply_inlet) = obj.c_tsi2();
            obj.matrix_coefficients(2,obj.id_supply_outlet) = obj.c_tso2();
            obj.matrix_coefficients(2,obj.id_exhaust_inlet) = obj.c_tei2();
            obj.matrix_coefficients(2,obj.id_exhaust_outlet) = obj.c_teo2();
        end

    end
end