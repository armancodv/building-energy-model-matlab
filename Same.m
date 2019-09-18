classdef Same
    properties
        iteration
        id_1
        id_2
        temperature_1
        temperature_2
        time_step
        matrix_size
        matrix_coefficients
        right_hand_side_vector
        number_of_equations
    end
    
    methods
        function obj = Same(id_1, id_2, solver)
            if nargin > 0
                obj.id_1 = id_1;
                obj.id_2 = id_2;
                obj.time_step = solver.time_step;
                obj.matrix_size = solver.matrix_size;

                obj.iteration = 0;
                obj.number_of_equations = 1;
                obj.matrix_coefficients = zeros(obj.number_of_equations,solver.matrix_size);
                obj.right_hand_side_vector = zeros(obj.number_of_equations,1);
                obj.temperature_1 = solver.temperatures(id_1);
                obj.temperature_2 = solver.temperatures(id_2);
                
            end
        end
        
        % create matrix of coefficients and right-hand side vector
        function obj = create(obj, solver)
            obj.iteration = obj.iteration + 1;
            obj.matrix_coefficients = zeros(obj.number_of_equations,obj.matrix_size);
            obj.right_hand_side_vector = zeros(obj.number_of_equations,1);
            obj.temperature_1 = solver.temperatures(obj.id_1);                    
            obj.temperature_2 = solver.temperatures(obj.id_2);                    
            obj.matrix_coefficients(obj.id_1) = 1;
            obj.matrix_coefficients(obj.id_2) = -1;
        end

    end
end