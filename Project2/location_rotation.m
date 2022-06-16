function [conveyer_loc, pusher_rot] = location_rotation(bardecoded_quadrant)
%location_rotatation determines the required block location on the conveyer
%belt as well as the required rotation direction of the pusher. 

% Determines the Conveyer Location 
    if bardecoded_quadrant == 1
        conveyer_loc = 1; % 4cm from the sonic sensor 
        pusher_rot = 1; % top right bin
    elseif bardecoded_quadrant == 2
        conveyer_loc = 2; % 4cm from the sonic sensor 
        pusher_rot = 1; % top left bin 
    elseif bardecoded_quadrant == 3 
        conveyer_loc = 2; % 10cm from the sonic sensor
        pusher_rot = 2; % bottom left bin
    elseif bardecoded_quadrant == 4
        conveyer_loc = 1; % 10cm from the sonic sensor
        pusher_rot = 2; % bottom right bin
    end 
end

