classdef Bridge
    properties
        iteration
        id
        id_bridge
        solver
        solver_bridge
        
        time_step
        matrix_size
        matrix_coefficients
        right_hand_side_vector
        number_of_equations
        
    end
    
    methods
        function obj = Bridge(id, id_bridge, solver, solver_bridge)
            if nargin > 0
                obj.id = id;
                obj.id_bridge = id_bridge;
                obj.solver = solver;
                obj.solver_bridge = solver_bridge;
                obj.time_step = solver.time_step;
                obj.matrix_size = solver.matrix_size;

                obj.iteration = 0;
                obj.number_of_equations = 1;
                obj.matrix_coefficients = zeros(obj.number_of_equations,solver.matrix_size);
                obj.right_hand_side_vector = zeros(obj.number_of_equations,1);
                
            end
        end
        
        % create matrix of coefficients and right-hand side vector
        function obj = create(obj, solver)
            obj.iteration = obj.iteration + 1;
            obj.matrix_coefficients = zeros(obj.number_of_equations,obj.matrix_size);
            obj.right_hand_side_vector = zeros(obj.number_of_equations,1);
            obj.right_hand_side_vector = obj.solver_bridge.temperatures(obj.id_bridge);
            obj.matrix_coefficients(obj.id) = 1;
        end

    end
end