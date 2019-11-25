classdef SetpointController
    properties
        minimum
        maximum
        mode % 1=heating, 2=cooling
        status
    end
    
    methods
        function obj = SetpointController(minimum, maximum, mode, status)
            obj.minimum = minimum;
            obj.maximum = maximum;
            obj.mode = mode;
            obj.status = status;
        end
        
        function status = check(obj, temperature)
            if(((obj.mode==1)&&(temperature<=obj.minimum))||((obj.mode==2)&&(temperature>=obj.maximum)))
                obj.status = 1;
            elseif(((obj.mode==1)&&(temperature>=obj.maximum))||((obj.mode==2)&&(temperature<=obj.minimum)))
                obj.status = 0;
            end
            status = obj.status;
        end
    end
end

