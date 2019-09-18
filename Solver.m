classdef Solver
    properties
        iteration
        time_step
        matrix_size
        temperatures
        matrix_coefficients
        right_hand_side_vector
        number_of_equations
    end
    
    methods
        function obj = Solver(time_step, matrix_size, initial_temperature)
            if nargin > 0
                obj.time_step = time_step;
                obj.matrix_size = matrix_size;
                obj.temperatures = initial_temperature*ones(matrix_size,1);
                obj.matrix_coefficients = zeros(matrix_size,matrix_size);
                obj.right_hand_side_vector = zeros(matrix_size,1);

                obj.iteration = 0;
            end
        end
        function [obj, elements] = get_matrices(obj, elements)
            for i=1:length(elements)
                elements(i) = elements(i).create(obj);
                for j=1:elements(i).number_of_equations
                    obj.number_of_equations = obj.number_of_equations + 1;
                    obj.matrix_coefficients(obj.number_of_equations, :) = elements(i).matrix_coefficients(j,:);
                    obj.right_hand_side_vector(obj.number_of_equations, 1) = elements(i).right_hand_side_vector(j,1);
                end
            end
        end
        function [obj, boilers, pipes, radiators, mixers, zones, sames, heatexchangers] = iterate(obj, boilers, pipes, radiators, mixers, zones, sames, heatexchangers)
            obj.iteration = obj.iteration + 1;
            obj.number_of_equations = 0;
            [obj, boilers] = get_matrices(obj, boilers);
            [obj, pipes] = get_matrices(obj, pipes);
            [obj, radiators] = get_matrices(obj, radiators);
            [obj, mixers] = get_matrices(obj, mixers);
            [obj, zones] = get_matrices(obj, zones);
            [obj, sames] = get_matrices(obj, sames);
            [obj, heatexchangers] = get_matrices(obj, heatexchangers);
            if(obj.number_of_equations~=obj.matrix_size)
                disp('Error: The number of equations and variables should be same.');
                fprintf('Number of Variables: %d - Number of Equations: %d', obj.matrix_size, obj.number_of_equations);
            else
                fprintf('Iteration: %d | Time: %d s\n', obj.iteration, obj.iteration*obj.time_step);
            end
            obj.temperatures = obj.matrix_coefficients\obj.right_hand_side_vector;
        end
    end
end

