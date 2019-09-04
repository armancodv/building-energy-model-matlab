classdef Mixer
    properties
        iteration
        id_inlets
        id_outlets
        time_step
        matrix_size
        matrix_coefficients
        right_hand_side_vector
        
        specific_heat_capacity_inlets
        temperature_inlets
        temperature_outlets
        mass_flow_rate_inlets
        fracrion_outlets

        specific_heat_capacity_outlets
        mass_flow_rate_outlets
    end
    
    methods
        function obj = Mixer(id_inlets, id_outlets, solver, specific_heat_capacity_inlets, mass_flow_rate_inlets, fracrion_outlets)
            if nargin > 0
                obj.id_inlets = id_inlets;
                obj.id_outlets = id_outlets;
                obj.time_step = solver.time_step;
                obj.matrix_size = solver.matrix_size;

                obj.specific_heat_capacity_inlets = specific_heat_capacity_inlets;
                obj.mass_flow_rate_inlets = mass_flow_rate_inlets;
                obj.fracrion_outlets = fracrion_outlets;

                obj.iteration = 0;
                obj.matrix_coefficients = zeros(1,solver.matrix_size);
                obj.right_hand_side_vector = 0;
                
                for i=1:length(obj.id_inlets)
                    obj.temperature_inlets(i) = solver.temperatures(obj.id_inlets(i));                    
                end
                for i=1:length(obj.id_outlets)
                    obj.temperature_outlets(i) = solver.temperatures(obj.id_outlets(i));                    
                    obj.mass_flow_rate_outlets(i) = fracrion_outlets(i)*sum(obj.mass_flow_rate_inlets);
                    obj.specific_heat_capacity_outlets(i) = sum(obj.specific_heat_capacity_inlets.*obj.mass_flow_rate_inlets)/sum(obj.mass_flow_rate_inlets);
                end
            end
        end
        
        % coefficient of inlets temperature
        function c = c_ti(obj,i)
            c = obj.mass_flow_rate_inlets(i)*obj.specific_heat_capacity_inlets(i);
        end
        
        % coefficient of outlets temperature
        function c = c_to(obj,i) 
            c = - obj.mass_flow_rate_outlets(i)*obj.specific_heat_capacity_outlets(i);
        end
        
        % create matrix of coefficients and right-hand side vector
        function obj = create(obj, temperatures)
            obj.iteration = obj.iteration + 1;
            obj.matrix_coefficients = zeros(1,obj.matrix_size);
            obj.right_hand_side_vector = 0;
            for i=1:length(obj.id_inlets)
                obj.temperature_inlets(i) = temperatures(obj.id_inlets(i));                    
                obj.matrix_coefficients(obj.id_inlets(i)) = obj.c_ti(i);
            end
            for i=1:length(obj.id_outlets)
                obj.temperature_outlets(i) = temperatures(obj.id_outlets(i));                    
                obj.matrix_coefficients(obj.id_outlets(i)) = obj.c_to(i);
            end
        end

    end
end