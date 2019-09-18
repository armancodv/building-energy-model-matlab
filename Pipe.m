classdef Pipe
    properties
        iteration
        id_inlet
        id_outlet
        id_zone
        time_step
        matrix_size
        matrix_coefficients
        right_hand_side_vector        
        number_of_equations
        
        %input
        specific_heat_capacity
        density
        specific_heat_capacity_fluid
        density_fluid
        temperature_inlet
        temperature_outlet
        temperature_zone
        mass_flow_rate
        heat_transfer_coefficient_inner
        heat_transfer_coefficient_outer
        thermal_conductivity
        radius_inner
        radius_outer
        length
        
        %calculated
        surface_inner
        heat_transfer_coefficient
        mass
        mass_fluid
    end
    
    methods
        function obj = Pipe(id_inlet, id_outlet, id_zone, solver, specific_heat_capacity, density, specific_heat_capacity_fluid, density_fluid, mass_flow_rate,heat_transfer_coefficient_inner,heat_transfer_coefficient_outer,thermal_conductivity,radius_inner,radius_outer,length)
            if nargin > 0
                obj.id_inlet = id_inlet;
                obj.id_outlet = id_outlet;
                obj.id_zone = id_zone;
                obj.time_step = solver.time_step;
                obj.matrix_size = solver.matrix_size;

                obj.specific_heat_capacity = specific_heat_capacity;
                obj.density = density;
                obj.specific_heat_capacity_fluid = specific_heat_capacity_fluid;
                obj.density_fluid = density_fluid;
                obj.mass_flow_rate = mass_flow_rate;
                obj.heat_transfer_coefficient_inner = heat_transfer_coefficient_inner;
                obj.heat_transfer_coefficient_outer = heat_transfer_coefficient_outer;
                obj.thermal_conductivity = thermal_conductivity;
                obj.radius_inner = radius_inner;
                obj.radius_outer = radius_outer;
                obj.length = length;
                
                obj.iteration = 0;
                obj.number_of_equations = 1;
                obj.matrix_coefficients = zeros(obj.number_of_equations,solver.matrix_size);
                obj.right_hand_side_vector = zeros(obj.number_of_equations,1);
                obj.temperature_inlet = solver.temperatures(obj.id_inlet);
                obj.temperature_outlet = solver.temperatures(obj.id_outlet);
                obj.temperature_zone = solver.temperatures(obj.id_zone);            
                
                % calculation
                obj.surface_inner = obj.calculate_surface_inner();
                obj.heat_transfer_coefficient = obj.calculate_heat_transfer_coefficient();
                obj.mass = obj.calculate_mass();
                obj.mass_fluid = obj.calculate_mass_fluid();
            end
        end

        % inner area of pipe
        function A = calculate_surface_inner(obj)
            A = 2*pi*obj.radius_inner*obj.length;
        end
        
        % equivalent heat transfer coefficient of pipe
        function U = calculate_heat_transfer_coefficient(obj)
            U = 1/(1/obj.heat_transfer_coefficient_inner+(obj.radius_inner*log(obj.radius_outer/obj.radius_inner))/obj.thermal_conductivity+obj.radius_inner/(obj.radius_outer*obj.heat_transfer_coefficient_outer));
        end
        
        % weight of pipe
        function m = calculate_mass(obj)
            m = pi*obj.density*(obj.radius_outer^2-obj.radius_inner^2)*obj.length;
        end
        
        % weight of fluid inside pipe
        function m = calculate_mass_fluid(obj)
            m = pi*obj.density_fluid*obj.radius_inner^2*obj.length;
        end
        
        % coefficient of inlet temperature
        function c = c_ti(obj)
            c = (obj.mass*obj.specific_heat_capacity+obj.mass_fluid*obj.specific_heat_capacity_fluid)/(2*obj.time_step)-obj.mass_flow_rate*obj.specific_heat_capacity_fluid+obj.heat_transfer_coefficient*obj.surface_inner/2;
        end
        
        % coefficient of outlet temperature
        function c = c_to(obj)
            c = (obj.mass*obj.specific_heat_capacity+obj.mass_fluid*obj.specific_heat_capacity_fluid)/(2*obj.time_step)+obj.mass_flow_rate*obj.specific_heat_capacity_fluid+obj.heat_transfer_coefficient*obj.surface_inner/2;
        end
        
        % coefficient of zone temperature
        function c = c_tz(obj)
            c = obj.heat_transfer_coefficient*obj.surface_inner;
        end
        
        % right-hand coefficient
        function c = c_r(obj)
            c = (obj.mass*obj.specific_heat_capacity+obj.mass_fluid*obj.specific_heat_capacity_fluid)*(obj.temperature_inlet+obj.temperature_outlet)/(2*obj.time_step);
        end
        
        % create matrix of coefficients and right-hand side vector
        function obj = create(obj, solver)
            obj.iteration = obj.iteration + 1;
            obj.temperature_inlet = solver.temperatures(obj.id_inlet);
            obj.temperature_outlet = solver.temperatures(obj.id_outlet);            
            obj.temperature_zone = solver.temperatures(obj.id_zone);            
            obj.matrix_coefficients = zeros(obj.number_of_equations,obj.matrix_size);
            obj.right_hand_side_vector = zeros(obj.number_of_equations,1);
            obj.right_hand_side_vector = obj.c_r();
            obj.matrix_coefficients(obj.id_inlet) = obj.c_ti();
            obj.matrix_coefficients(obj.id_outlet) = obj.c_to();
            obj.matrix_coefficients(obj.id_zone) = obj.c_tz();
        end

    end
end