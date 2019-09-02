classdef Pipe
    properties
        %input
        specific_heat_capacity
        density
        specific_heat_capacity_fluid
        density_fluid
        temperature_inlet
        temperature_outlet
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
        function obj = Pipe(specific_heat_capacity, density, specific_heat_capacity_fluid, density_fluid, temperature_inlet, temperature_outlet, mass_flow_rate,heat_transfer_coefficient_inner,heat_transfer_coefficient_outer,thermal_conductivity,radius_inner,radius_outer,length)
            if nargin > 0
                obj.specific_heat_capacity = specific_heat_capacity;
                obj.density = density;
                obj.specific_heat_capacity_fluid = specific_heat_capacity_fluid;
                obj.density_fluid = density_fluid;
                obj.temperature_inlet = temperature_inlet;
                obj.temperature_outlet = temperature_outlet;
                obj.mass_flow_rate = mass_flow_rate;
                obj.heat_transfer_coefficient_inner = heat_transfer_coefficient_inner;
                obj.heat_transfer_coefficient_outer = heat_transfer_coefficient_outer;
                obj.thermal_conductivity = thermal_conductivity;
                obj.radius_inner = radius_inner;
                obj.radius_outer = radius_outer;
                obj.length = length;
                
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
        
        % coefficient of inlet temperature of pipe
        function c = c_ti(obj, dt)
            c = (obj.mass*obj.specific_heat_capacity+obj.mass_fluid*obj.specific_heat_capacity_fluid)/(2*dt)-obj.mass_flow_rate*obj.specific_heat_capacity_fluid+obj.heat_transfer_coefficient*obj.surface_inner/2;
        end
        
        % coefficient of outlet temperature of pipe
        function c = c_to(obj, dt)
            c = (obj.mass*obj.specific_heat_capacity+obj.mass_fluid*obj.specific_heat_capacity_fluid)/(2*dt)+obj.mass_flow_rate*obj.specific_heat_capacity_fluid+obj.heat_transfer_coefficient*obj.surface_inner/2;
        end
        
        % right-hand coefficient of pipe
        function c = c_r(obj, dt, temperature_environment)
            c = obj.heat_transfer_coefficient*obj.surface_inner*temperature_environment + (obj.mass*obj.specific_heat_capacity+obj.mass_fluid*obj.specific_heat_capacity_fluid)*(obj.temperature_inlet+obj.temperature_outlet)/(2*dt);
        end

    end
end