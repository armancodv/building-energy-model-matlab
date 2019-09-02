classdef Boiler
    properties
        specific_heat_capacity
        mass
        specific_heat_capacity_fluid
        mass_fluid
        power
        temperature_inlet
        temperature_outlet
        mass_flow_rate
        status
    end
    
    methods
        function obj = Boiler(specific_heat_capacity, mass, specific_heat_capacity_fluid, mass_fluid, power, temperature_inlet, temperature_outlet, mass_flow_rate, status)
            if nargin > 0
                obj.specific_heat_capacity = specific_heat_capacity;
                obj.mass = mass;
                obj.specific_heat_capacity_fluid = specific_heat_capacity_fluid;
                obj.mass_fluid = mass_fluid;
                obj.power = power;
                obj.temperature_inlet = temperature_inlet;
                obj.temperature_outlet = temperature_outlet;
                obj.mass_flow_rate = mass_flow_rate;
                obj.status = status;
            end
        end
        
        % coefficient of inlet temperature of boiler (return fluid)
        function c = c_ti(obj, dt)
            c = (obj.mass*obj.specific_heat_capacity+obj.mass_fluid*obj.specific_heat_capacity_fluid)/(2*dt)-obj.mass_flow_rate*obj.specific_heat_capacity_fluid;
        end
        
        % coefficient of outlet temperature of boiler (supply fluid)
        function c = c_to(obj, dt) 
            c = (obj.mass*obj.specific_heat_capacity+obj.mass_fluid*obj.specific_heat_capacity_fluid)/(2*dt)+obj.mass_flow_rate*obj.specific_heat_capacity_fluid;
        end
        
        % right-hand coefficient of boiler
        function c = c_r(obj, dt)
            c = obj.power + (obj.mass*obj.specific_heat_capacity+obj.mass_fluid*obj.specific_heat_capacity_fluid)/(2*dt)*(obj.temperature_inlet + obj.temperature_outlet);
        end
        

    end
end

