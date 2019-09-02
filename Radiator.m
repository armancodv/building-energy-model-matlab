classdef Radiator
    properties
        %input
        specific_heat_capacity
        mass
        specific_heat_capacity_fluid
        mass_fluid
        temperature_inlet
        temperature_outlet
        mass_flow_rate
        heat_transfer_coefficient
        surface
    end
    
    methods
        function obj = Radiator(specific_heat_capacity, mass, specific_heat_capacity_fluid, mass_fluid, temperature_inlet, temperature_outlet, mass_flow_rate,heat_transfer_coefficient,surface)
            if nargin > 0
                obj.specific_heat_capacity = specific_heat_capacity;
                obj.mass = mass;
                obj.specific_heat_capacity_fluid = specific_heat_capacity_fluid;
                obj.mass_fluid = mass_fluid;
                obj.temperature_inlet = temperature_inlet;
                obj.temperature_outlet = temperature_outlet;
                obj.mass_flow_rate = mass_flow_rate;
                obj.heat_transfer_coefficient = heat_transfer_coefficient;
                obj.surface = surface;
            end
        end

        % coefficient of inlet temperature of radiator
        function c = c_ti(obj, dt) 
            c = (obj.mass*obj.specific_heat_capacity+obj.mass_fluid*obj.specific_heat_capacity_fluid)/(2*dt)-obj.mass_flow_rate*obj.specific_heat_capacity_fluid+obj.heat_transfer_coefficient*obj.surface/2;
        end
        
        % coefficient of outlet temperature of radiator
        function c = c_to(obj, dt) 
            c = (obj.mass*obj.specific_heat_capacity+obj.mass_fluid*obj.specific_heat_capacity_fluid)/(2*dt)+obj.mass_flow_rate*obj.specific_heat_capacity_fluid+obj.heat_transfer_coefficient*obj.surface/2;
        end
        
        % coefficient of envioronment temperature of radiator
        function c = c_te(obj) 
            c = -obj.heat_transfer_coefficient*obj.surface;
        end
        
        % right-hand coefficient of radiator
        function c = c_r(obj,dt) 
            c = (obj.mass*obj.specific_heat_capacity+obj.mass_fluid*obj.specific_heat_capacity_fluid)*(obj.temperature_inlet+obj.temperature_outlet)/(2*dt);
        end


    end
end