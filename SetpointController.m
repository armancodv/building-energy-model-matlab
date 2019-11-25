classdef SetpointController
    properties
        minimum
        maximum
        mode % 1=heating, 2=cooling
    end
    
    methods
        function obj = SetpointController(minimum, maximum, mode)
            obj.minimum = minimum;
            obj.maximum = maximum;
            obj.mode = mode;            
        end
        
        function status = check(obj, temperature)
            if(((obj.mode==1)&&(temperature<=obj.minimum))||((obj.mode==2)&&(temperature>=obj.maximum)))
                status = 1;
            elseif(((obj.mode==1)&&(temperature>=obj.maximum))||((obj.mode==2)&&(temperature<=obj.minimum)))
                status = 0;
            end
        end
    end
end

