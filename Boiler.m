classdef Boiler
    properties
        iteration
        id_inlet
        id_outlet
        time_step
        matrix_size
        matrix_coefficients
        right_hand_side_vector
        
        specific_heat_capacity
        mass
        specific_heat_capacity_fluid
        mass_fluid
        power
        temperature_inlet
        temperature_outlet
        mass_flow_rate
        status
    end
    
    methods
        function obj = Boiler(id_inlet, id_outlet, solver, specific_heat_capacity, mass, specific_heat_capacity_fluid, mass_fluid, power, mass_flow_rate, status)
            if nargin > 0
                obj.id_inlet = id_inlet;
                obj.id_outlet = id_outlet;
                obj.time_step = solver.time_step;
                obj.matrix_size = solver.matrix_size;
                
                obj.specific_heat_capacity = specific_heat_capacity;
                obj.mass = mass;
                obj.specific_heat_capacity_fluid = specific_heat_capacity_fluid;
                obj.mass_fluid = mass_fluid;
                obj.power = power;
                obj.mass_flow_rate = mass_flow_rate;
                obj.status = status;
                
                obj.iteration = 0;
                obj.matrix_coefficients = zeros(1,solver.matrix_size);
                obj.right_hand_side_vector = 0;
                obj.temperature_inlet = solver.temperatures(obj.id_inlet);
                obj.temperature_outlet = solver.temperatures(obj.id_outlet);
            end
        end
        
        % coefficient of inlet temperature of boiler (return fluid)
        function c = c_ti(obj)
            c = (obj.mass*obj.specific_heat_capacity+obj.mass_fluid*obj.specific_heat_capacity_fluid)/(2*obj.time_step)-obj.mass_flow_rate*obj.specific_heat_capacity_fluid;
        end
        
        % coefficient of outlet temperature of boiler (supply fluid)
        function c = c_to(obj) 
            c = (obj.mass*obj.specific_heat_capacity+obj.mass_fluid*obj.specific_heat_capacity_fluid)/(2*obj.time_step)+obj.mass_flow_rate*obj.specific_heat_capacity_fluid;
        end
        
        % right-hand coefficient of boiler
        function c = c_r(obj)
            c = obj.power + (obj.mass*obj.specific_heat_capacity+obj.mass_fluid*obj.specific_heat_capacity_fluid)/(2*obj.time_step)*(obj.temperature_inlet + obj.temperature_outlet);
        end
        
        % create matrix of coefficients and right-hand side vector
        function obj = create(obj, solver)
            obj.iteration = obj.iteration + 1;
            obj.temperature_inlet = solver.temperatures(obj.id_inlet);
            obj.temperature_outlet = solver.temperatures(obj.id_outlet);            
            obj.matrix_coefficients = zeros(1,obj.matrix_size);
            obj.right_hand_side_vector = obj.c_r();
            obj.matrix_coefficients(obj.id_inlet) = obj.c_ti();
            obj.matrix_coefficients(obj.id_outlet) = obj.c_to();
        end

    end
end

