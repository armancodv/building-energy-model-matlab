classdef Chiller
    properties
        iteration
        id_condenser_inlet
        id_condenser_outlet
        id_evaporator_inlet
        id_evaporator_outlet
        time_step
        matrix_size
        matrix_coefficients
        right_hand_side_vector
        number_of_equations
        
        specific_heat_capacity_fluid
        power
        coefficient_of_performance
        mass_flow_rate_condenser
        mass_flow_rate_evaporator
        temperature_condenser_inlet
        temperature_condenser_outlet
        temperature_evaporator_inlet
        temperature_evaporator_outlet
        status
    end
    
    methods
        function obj = Chiller(id_condenser_inlet, id_condenser_outlet, id_evaporator_inlet, id_evaporator_outlet, solver, specific_heat_capacity_fluid, power, coefficient_of_performance, mass_flow_rate_condenser, mass_flow_rate_evaporator, status)
            if nargin > 0
                obj.id_condenser_inlet = id_condenser_inlet;
                obj.id_condenser_outlet = id_condenser_outlet;
                obj.id_evaporator_inlet = id_evaporator_inlet;
                obj.id_evaporator_outlet = id_evaporator_outlet;
                obj.time_step = solver.time_step;
                obj.matrix_size = solver.matrix_size;
                
                obj.specific_heat_capacity_fluid = specific_heat_capacity_fluid;
                obj.power = power;
                obj.mass_flow_rate_condenser = mass_flow_rate_condenser;
                obj.mass_flow_rate_evaporator = mass_flow_rate_evaporator;
                obj.coefficient_of_performance = coefficient_of_performance;
                obj.status = status;
                
                obj.iteration = 0;
                obj.number_of_equations = 2;
                obj.matrix_coefficients = zeros(obj.number_of_equations,solver.matrix_size);
                obj.right_hand_side_vector = zeros(obj.number_of_equations,1);
                obj.temperature_condenser_inlet = solver.temperatures(obj.id_condenser_inlet);
                obj.temperature_condenser_outlet = solver.temperatures(obj.id_condenser_outlet);
                obj.temperature_evaporator_inlet = solver.temperatures(obj.id_evaporator_inlet);
                obj.temperature_evaporator_outlet = solver.temperatures(obj.id_evaporator_outlet);
            end
        end
        
        % evaporator inlet temperature coefficient (Eq 1)
        function c = c_tei1(obj)
            c = obj.mass_flow_rate_evaporator*obj.specific_heat_capacity_fluid;
        end
        
        % evaporator outlet temperature coefficient (Eq 1)
        function c = c_teo1(obj)
            c = - obj.mass_flow_rate_evaporator*obj.specific_heat_capacity_fluid;
        end
        
        % right-hand coefficient (Eq 1)
        function c = c_r1(obj)
            c = obj.power*obj.coefficient_of_performance;
        end
        
        % condenser inlet temperature coefficient (Eq 2)
        function c = c_tci2(obj)
            c = - obj.mass_flow_rate_condenser*obj.specific_heat_capacity_fluid;
        end
        
        % condenser outlet temperature coefficient (Eq 2)
        function c = c_tco2(obj)
            c = obj.mass_flow_rate_condenser*obj.specific_heat_capacity_fluid;
        end
        
        % right-hand coefficient (Eq 2)
        function c = c_r2(obj)
            c = obj.power*(1+obj.coefficient_of_performance);
        end
        
        % create matrix of coefficients and right-hand side vector
        function obj = create(obj, solver)
            obj.iteration = obj.iteration + 1;
            obj.temperature_condenser_inlet = solver.temperatures(obj.id_condenser_inlet);
            obj.temperature_condenser_outlet = solver.temperatures(obj.id_condenser_outlet);
            obj.temperature_evaporator_inlet = solver.temperatures(obj.id_evaporator_inlet);
            obj.temperature_evaporator_outlet = solver.temperatures(obj.id_evaporator_outlet);
            obj.matrix_coefficients = zeros(obj.number_of_equations,obj.matrix_size);
            obj.right_hand_side_vector = zeros(obj.number_of_equations,1);
            obj.matrix_coefficients(1,obj.id_evaporator_inlet) = obj.c_tsi1();
            obj.matrix_coefficients(1,obj.id_evaporator_outlet) = obj.c_tso1();
            obj.matrix_coefficients(2,obj.id_condenser_inlet) = obj.c_tdi2();
            obj.matrix_coefficients(2,obj.id_condenser_outlet) = obj.c_tdo2();
            obj.right_hand_side_vector(1) = obj.c_r1();
            obj.right_hand_side_vector(2) = obj.c_r2();
        end

    end
end

