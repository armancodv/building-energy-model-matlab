classdef Constant
    properties
        iteration
        id
        temperature

        time_step
        matrix_size
        matrix_coefficients
        right_hand_side_vector
        number_of_equations
        
    end
    
    methods
        function obj = Constant(id, solver, temperature)
            if nargin > 0
                obj.id = id;
                obj.temperature = temperature;

                obj.iteration = 0;
                obj.number_of_equations = 1;
                obj.matrix_coefficients = zeros(obj.number_of_equations,solver.matrix_size);
                obj.right_hand_side_vector = zeros(obj.number_of_equations,1);
                
            end
        end
        
        % right-hand coefficient
        function c = c_r(obj)
            c = obj.temperature;
        end
        
        % create matrix of coefficients and right-hand side vector
        function obj = create(obj, solver)
            obj.iteration = obj.iteration + 1;
            obj.matrix_coefficients = zeros(obj.number_of_equations,obj.matrix_size);
            obj.right_hand_side_vector = zeros(obj.number_of_equations,1);
            obj.right_hand_side_vector = obj.c_r();
            obj.matrix_coefficients(obj.id) = 1;
        end

    end
end