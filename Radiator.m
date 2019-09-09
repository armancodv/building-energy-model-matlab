classdef Radiator
    properties
        iteration
        id_inlet
        id_outlet
        id_zone
        time_step
        matrix_size
        matrix_coefficients
        right_hand_side_vector
        
        specific_heat_capacity
        mass
        specific_heat_capacity_fluid
        mass_fluid
        temperature_zone
        temperature_inlet
        temperature_outlet
        mass_flow_rate
        heat_transfer_coefficient
        surface
    end
    
    methods
        function obj = Radiator(id_inlet, id_outlet, id_zone, solver, specific_heat_capacity, mass, specific_heat_capacity_fluid, mass_fluid, mass_flow_rate,heat_transfer_coefficient,surface)
            if nargin > 0
                obj.id_inlet = id_inlet;
                obj.id_outlet = id_outlet;
                obj.id_zone = id_zone;
                obj.time_step = solver.time_step;
                obj.matrix_size = solver.matrix_size;
                
                obj.specific_heat_capacity = specific_heat_capacity;
                obj.mass = mass;
                obj.specific_heat_capacity_fluid = specific_heat_capacity_fluid;
                obj.mass_fluid = mass_fluid;
                obj.mass_flow_rate = mass_flow_rate;
                obj.heat_transfer_coefficient = heat_transfer_coefficient;
                obj.surface = surface;

                obj.iteration = 0;
                obj.matrix_coefficients = zeros(1,solver.matrix_size);
                obj.right_hand_side_vector = 0;
                obj.temperature_inlet = solver.temperatures(obj.id_inlet);
                obj.temperature_outlet = solver.temperatures(obj.id_outlet);
                obj.temperature_zone = solver.temperatures(obj.id_zone);            
            end
        end

        % coefficient of inlet temperature of radiator
        function c = c_ti(obj) 
            c = (obj.mass*obj.specific_heat_capacity+obj.mass_fluid*obj.specific_heat_capacity_fluid)/(2*obj.time_step)-obj.mass_flow_rate*obj.specific_heat_capacity_fluid+obj.heat_transfer_coefficient*obj.surface/2;
        end
        
        % coefficient of outlet temperature of radiator
        function c = c_to(obj) 
            c = (obj.mass*obj.specific_heat_capacity+obj.mass_fluid*obj.specific_heat_capacity_fluid)/(2*obj.time_step)+obj.mass_flow_rate*obj.specific_heat_capacity_fluid+obj.heat_transfer_coefficient*obj.surface/2;
        end
        
        % coefficient of zone temperature of radiator
        function c = c_tz(obj) 
            c = -obj.heat_transfer_coefficient*obj.surface;
        end
        
        % right-hand coefficient of radiator
        function c = c_r(obj) 
            c = (obj.mass*obj.specific_heat_capacity+obj.mass_fluid*obj.specific_heat_capacity_fluid)*(obj.temperature_inlet+obj.temperature_outlet)/(2*obj.time_step);
        end
        
        % create matrix of coefficients and right-hand side vector
        function obj = create(obj, solver)
            obj.iteration = obj.iteration + 1;
            obj.temperature_inlet = solver.temperatures(obj.id_inlet);
            obj.temperature_outlet = solver.temperatures(obj.id_outlet);            
            obj.temperature_zone = solver.temperatures(obj.id_zone);            
            obj.matrix_coefficients = zeros(1,obj.matrix_size);
            obj.right_hand_side_vector = obj.c_r();
            obj.matrix_coefficients(obj.id_inlet) = obj.c_ti();
            obj.matrix_coefficients(obj.id_outlet) = obj.c_to();
            obj.matrix_coefficients(obj.id_zone) = obj.c_tz();
        end



    end
end