classdef Zone
    properties
        iteration
        id_zone
        id_zones
        id_radiator_inlets
        id_radiator_outlets
        thickness_walls
        surface_walls
        thickness_windows
        surface_windows
        surface_radiators
        heat_transfer_coefficient_radiators
        temperature_zone

        density_air
        volume_air
        specific_heat_capacity_air
        density_wall
        volume_wall
        specific_heat_capacity_wall
        mass_equipment
        specific_heat_capacity_equipment
        thermal_conductivity_wall
        thermal_conductivity_window
                
        time_step
        matrix_size
        matrix_coefficients
        right_hand_side_vector
        number_of_equations
        
        thermal_resistance_inner_wall
        thermal_resistance_outer_wall
        thermal_resistance_inner_window
        thermal_resistance_outer_window
        thermal_resistance_gap_window
        
        heat_transfer_walls
        heat_transfer_windows
        
    end
    
    methods
        function obj = Zone(id_zone, id_zones, id_radiator_inlets, id_radiator_outlets, solver, thickness_walls, surface_walls, thickness_windows, surface_windows, surface_radiators, heat_transfer_coefficient_radiators, density_air, volume_air, specific_heat_capacity_air, density_wall, volume_wall, specific_heat_capacity_wall, mass_equipment, specific_heat_capacity_equipment, thermal_conductivity_wall, thermal_conductivity_window)
            if nargin > 0
                obj.id_zone = id_zone;
                obj.id_zones = id_zones;
                obj.id_radiator_inlets = id_radiator_inlets;
                obj.id_radiator_outlets = id_radiator_outlets;
                obj.time_step = solver.time_step;
                obj.matrix_size = solver.matrix_size;
                obj.thickness_walls = thickness_walls;
                obj.surface_walls = surface_walls;
                obj.thickness_windows = thickness_windows;
                obj.surface_windows = surface_windows;
                obj.surface_radiators = surface_radiators;
                obj.heat_transfer_coefficient_radiators = heat_transfer_coefficient_radiators;

                obj.density_air = density_air;
                obj.volume_air = volume_air;
                obj.specific_heat_capacity_air = specific_heat_capacity_air;
                obj.density_wall = density_wall;
                obj.volume_wall = volume_wall;
                obj.specific_heat_capacity_wall = specific_heat_capacity_wall;
                obj.mass_equipment = mass_equipment;
                obj.specific_heat_capacity_equipment = specific_heat_capacity_equipment;
                obj.thermal_conductivity_wall = thermal_conductivity_wall;
                obj.thermal_conductivity_window = thermal_conductivity_window;

                obj.thermal_resistance_inner_wall = 0.13;
                obj.thermal_resistance_outer_wall = 0.04;
                obj.thermal_resistance_inner_window = 0.13;
                obj.thermal_resistance_outer_window = 0.04;
                obj.thermal_resistance_gap_window = 0.127;
                
                for i=1:length(obj.id_zones)
                    obj.heat_transfer_walls(i) = obj.calculate_wall_heat_transfer(thickness_walls(i));                    
                    obj.heat_transfer_windows(i) = obj.calculate_window_heat_transfer(thickness_windows(i));                    
                end

                obj.iteration = 0;
                obj.number_of_equations = 1;
                obj.matrix_coefficients = zeros(obj.number_of_equations,solver.matrix_size);
                obj.right_hand_side_vector = zeros(obj.number_of_equations,1);
                obj.temperature_zone = solver.temperatures(obj.id_zone);            
                
            end
        end
        
        % equivalent heat transfer coefficient of wall
        function U = calculate_wall_heat_transfer(obj, thickness_wall)
            U = 1/(obj.thermal_resistance_outer_wall+thickness_wall/obj.thermal_conductivity_wall+obj.thermal_resistance_inner_wall);
        end
        
        % equivalent heat transfer coefficient of window
        function U = calculate_window_heat_transfer(obj, thickness_window)
            U = 1/(obj.thermal_resistance_outer_window+thickness_window/obj.thermal_conductivity_window+obj.thermal_resistance_gap_window+obj.thermal_resistance_inner_window);
        end
        
        % coefficient of radiator inlet temperature
        function c = c_tri(obj, i)
            c = -obj.heat_transfer_coefficient_radiators(i)*obj.surface_radiators(i)/2;
        end
        
        % coefficient of radiator outlet temperature
        function c = c_tro(obj, i)
            c = -obj.heat_transfer_coefficient_radiators(i)*obj.surface_radiators(i)/2;
        end
        
        % coefficient of zone temperature
        function c = c_tz(obj)
            c = (obj.density_air*obj.volume_air*obj.specific_heat_capacity_air+obj.density_wall*obj.volume_wall*obj.specific_heat_capacity_wall)/obj.time_step + sum(obj.heat_transfer_coefficient_radiators.*obj.surface_radiators) + sum(obj.heat_transfer_walls.*obj.surface_walls + obj.heat_transfer_windows.*obj.surface_windows);
        end
        % coefficient of neigthbors' zones temperature
        function c = c_tzj(obj, i)
            c = - obj.heat_transfer_walls(i)*obj.surface_walls(i) - obj.heat_transfer_windows(i)*obj.surface_windows(i);
        end
        
        % right-hand coefficient
        function c = c_r(obj)
            c = ((obj.density_air*obj.volume_air*obj.specific_heat_capacity_air+obj.density_wall*obj.volume_wall*obj.specific_heat_capacity_wall)/obj.time_step)*obj.temperature_zone;
        end
        
        % create matrix of coefficients and right-hand side vector
        function obj = create(obj, solver)
            obj.iteration = obj.iteration + 1;
            obj.matrix_coefficients = zeros(obj.number_of_equations,obj.matrix_size);
            obj.right_hand_side_vector = zeros(obj.number_of_equations,1);
            obj.right_hand_side_vector = obj.c_r();
            obj.temperature_zone = solver.temperatures(obj.id_zone);            
            obj.matrix_coefficients(obj.id_zone) = obj.c_tz();
            for i=1:length(obj.id_zones)
                obj.matrix_coefficients(obj.id_zones(i)) = obj.c_tzj(i);
            end
            for i=1:length(obj.id_radiator_inlets)
                obj.matrix_coefficients(obj.id_radiator_inlets(i)) = obj.c_tri(i);
                obj.matrix_coefficients(obj.id_radiator_outlets(i)) = obj.c_tro(i);
            end
        end

    end
end