classdef HeatExchanger
    properties
        iteration
        id_supply_inlet
        id_supply_outlet
        id_demand_inlet
        id_demand_outlet
        temperature_supply_inlet
        temperature_supply_outlet
        temperature_demand_inlet
        temperature_demand_outlet
        time_step
        matrix_size
        matrix_coefficients
        right_hand_side_vector

        specific_heat_capacity_supply
        specific_heat_capacity_demand
        mass_flow_rate_supply
        mass_flow_rate_demand
        heat_transfer_coefficient
        surface
        
        heat_transfer_minimum
        heat_transfer_maximum
        capacity_ratio
        number_of_transfer_units
        effectiveness
    end
    
    methods
        function obj = HeatExchanger(id_supply_inlet, id_supply_outlet, id_demand_inlet, id_demand_outlet, solver, specific_heat_capacity_supply, specific_heat_capacity_demand, mass_flow_rate_supply, mass_flow_rate_demand, heat_transfer_coefficient, surface)
            if nargin > 0
                obj.id_supply_inlet = id_supply_inlet;
                obj.id_supply_outlet = id_supply_outlet;
                obj.id_demand_inlet = id_demand_inlet;
                obj.id_demand_outlet = id_demand_outlet;
                obj.time_step = solver.time_step;
                obj.matrix_size = solver.matrix_size;
                obj.specific_heat_capacity_supply = specific_heat_capacity_supply;
                obj.specific_heat_capacity_demand = specific_heat_capacity_demand;
                obj.mass_flow_rate_supply = mass_flow_rate_supply;
                obj.mass_flow_rate_demand = mass_flow_rate_demand;
                obj.heat_transfer_coefficient = heat_transfer_coefficient;
                obj.surface = surface;

                obj.iteration = 0;
                obj.matrix_coefficients = zeros(1,solver.matrix_size);
                obj.right_hand_side_vector = 0;
                obj.temperature_supply_inlet = solver.temperatures(id_supply_inlet);
                obj.temperature_supply_outlet = solver.temperatures(id_supply_outlet);
                obj.temperature_demand_inlet = solver.temperatures(id_demand_inlet);
                obj.temperature_demand_outlet = solver.temperatures(id_demand_outlet);

                obj.heat_transfer_minimum = min(mass_flow_rate_supply*specific_heat_capacity_supply, mass_flow_rate_demand*specific_heat_capacity_demand);
                obj.heat_transfer_maximum = max(mass_flow_rate_supply*specific_heat_capacity_supply, mass_flow_rate_demand*specific_heat_capacity_demand);
                obj.capacity_ratio = obj.heat_transfer_minimum / obj.heat_transfer_maximum;
                obj.number_of_transfer_units = heat_transfer_coefficient * surface / obj.heat_transfer_minimum;
                obj.effectiveness = (1 - exp(-obj.number_of_transfer_units*(1+obj.capacity_ratio)))/(1+obj.capacity_ratio);
            end
        end
        
        % create matrix of coefficients and right-hand side vector
        function obj = create(obj, solver)
            obj.iteration = obj.iteration + 1;
            obj.matrix_coefficients = zeros(1,obj.matrix_size);
            obj.right_hand_side_vector = 0;
            obj.temperature_1 = solver.temperatures(obj.id_1);                    
            obj.temperature_2 = solver.temperatures(obj.id_2);                    
            obj.matrix_coefficients(obj.id_1) = 1;
            obj.matrix_coefficients(obj.id_2) = -1;
        end

    end
end