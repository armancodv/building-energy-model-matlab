classdef Zone
    properties
        iteration
        id_radiator_inlets
        id_radiator_outlets
        time_step
        matrix_size
        matrix_coefficients
        right_hand_side_vector
        
        specific_heat_capacity_inlets
        temperature_radiator_inlets
        temperature_radiator_outlets
        mass_flow_rate_inlets
        fracrion_outlets

        specific_heat_capacity_outlets
        mass_flow_rate_outlets
    end
    
    methods
        function obj = Zone(id_radiator_inlets, id_radiator_outlets, solver, specific_heat_capacity_inlets, mass_flow_rate_inlets, fracrion_outlets)
            if nargin > 0
                obj.id_radiator_inlets = id_radiator_inlets;
                obj.id_radiator_outlets = id_radiator_outlets;
                obj.time_step = solver.time_step;
                obj.matrix_size = solver.matrix_size;

                obj.specific_heat_capacity_inlets = specific_heat_capacity_inlets;
                obj.mass_flow_rate_inlets = mass_flow_rate_inlets;
                obj.fracrion_outlets = fracrion_outlets;

                obj.iteration = 0;
                obj.matrix_coefficients = zeros(1,solver.matrix_size);
                obj.right_hand_side_vector = 0;
                
                for i=1:length(obj.id_radiator_inlets)
                    obj.temperature_radiator_inlets(i) = solver.temperatures(obj.id_radiator_inlets(i));                    
                end
                for i=1:length(obj.id_radiator_outlets)
                    obj.temperature_radiator_outlets(i) = solver.temperatures(obj.id_radiator_outlets(i));                    
                    obj.mass_flow_rate_outlets(i) = fracrion_outlets(i)*sum(obj.mass_flow_rate_inlets);
                    obj.specific_heat_capacity_outlets(i) = sum(obj.specific_heat_capacity_inlets.*obj.mass_flow_rate_inlets)/sum(obj.mass_flow_rate_inlets);
                end
            end
        end
        
        % equivalent heat transfer coefficient of wall
        function U = wall_heat_transfer(obj, d_w)
            U = 1/(obj.r_w_o+d_w/obj.k_w+obj.r_w_i);
        end
        
        % equivalent heat transfer coefficient of window
        function U = window_heat_transfer(obj, d_win)
            U = 1/(obj.r_win_o+d_win/obj.k_win+obj.r_win_gap+obj.r_win_i);
        end
        
        % coefficient of radiator inlet temperature
        function c = c_tri(obj, a_r)
            c = -obj.u_r*a_r/2;
        end
        
        % coefficient of radiator outlet temperature
        function c = c_tro(obj, a_r)
            c = -obj.u_r*a_r/2;
        end
        
        % coefficient of zone temperature
        function c = c_tz(obj, dt, v_a, a_r_total, d_w, a_w, v_w, d_win, a_win)
            c = (obj.rho_a*v_a*obj.c_a+obj.rho_w*v_w*obj.c_w)/dt + obj.u_r*a_r_total + obj.wall_heat_transfer(d_w)*a_w + obj.window_heat_transfer(d_win)*a_win;
        end
        
        % right-hand coefficient
        function c = c_r(obj, dt, v_a, d_w, a_w, v_w, d_win, a_win, T_e, T_o) 
            c = ((obj.rho_a*v_a*obj.c_a+obj.rho_w*v_w*obj.c_w)/dt)*T_e + (obj.wall_heat_transfer(d_w)*a_w+obj.window_heat_transfer(d_win)*a_win)*T_o;
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