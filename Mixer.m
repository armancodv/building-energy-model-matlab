classdef Mixer
    properties
        %input
        specific_heat_capacity_inlets
        temperature_inlets
        mass_flow_rate_inlets
        
        %output
        specific_heat_capacity_outlet
        temperature_outlet
        mass_flow_rate_outlet
    end
    
    methods
        function obj = Mixer(specific_heat_capacity_inlets, temperature_inlets, mass_flow_rate_inlets)
            if nargin > 0
                obj.specific_heat_capacity_inlets = specific_heat_capacity_inlets;
                obj.temperature_inlets = temperature_inlets;
                obj.mass_flow_rate_inlets = mass_flow_rate_inlets;
            end
        end


    end
end