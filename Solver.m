classdef Solver
    properties
        iteration
        time_step
        matrix_size
        temperatures
        matrix_coefficients
        right_hand_side_vector
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
        function [obj, boilers, pipes, radiators, mixers, zones, sames] = iterate(obj, boilers, pipes, radiators, mixers, zones, sames)
            obj.iteration = obj.iteration + 1;
            row = 0;
            for i=1:length(boilers)
                row = row + 1;
                boilers(i) = boilers(i).create(obj);
                obj.matrix_coefficients(row, :) = boilers(i).matrix_coefficients;
                obj.right_hand_side_vector(row, 1) = boilers(i).right_hand_side_vector;
            end
            for i=1:length(pipes)
                row = row + 1;
                pipes(i) = pipes(i).create(obj);
                obj.matrix_coefficients(row, :) = pipes(i).matrix_coefficients;
                obj.right_hand_side_vector(row, 1) = pipes(i).right_hand_side_vector;
            end
            for i=1:length(radiators)
                row = row + 1;
                radiators(i) = radiators(i).create(obj);
                obj.matrix_coefficients(row, :) = radiators(i).matrix_coefficients;
                obj.right_hand_side_vector(row, 1) = radiators(i).right_hand_side_vector;
            end
            for i=1:length(mixers)
                row = row + 1;
                mixers(i) = mixers(i).create(obj);
                obj.matrix_coefficients(row, :) = mixers(i).matrix_coefficients;
                obj.right_hand_side_vector(row, 1) = mixers(i).right_hand_side_vector;
            end
            for i=1:length(zones)
                row = row + 1;
                zones(i) = zones(i).create(obj);
                obj.matrix_coefficients(row, :) = zones(i).matrix_coefficients;
                obj.right_hand_side_vector(row, 1) = zones(i).right_hand_side_vector;
            end
            for i=1:length(sames)
                row = row + 1;
                sames(i) = sames(i).create(obj);
                obj.matrix_coefficients(row, :) = sames(i).matrix_coefficients;
                obj.right_hand_side_vector(row, 1) = sames(i).right_hand_side_vector;
            end
            if(row~=obj.matrix_size)
                disp('Error: The number of equations and variables should be same.');
                fprintf('Number of Variables: %d - Number of Equations: %d', obj.matrix_size, row);
            else
                fprintf('Iteration: %d | Time: %d s\n', obj.iteration, obj.iteration*obj.time_step);
            end
            obj.temperatures = obj.matrix_coefficients\obj.right_hand_side_vector;
        end
    end
end

