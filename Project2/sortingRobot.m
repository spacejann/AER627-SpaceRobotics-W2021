%{
AER 627 Intro to Space Robotics 
Project 2: Sorting Robot  
Jann Cristobal
500815181

Nomenclature 
Package A: Sorting Robot 
motor_conveyer  -> Port A -> large motor responsible for linear motion of
                the conveyer belt 
motor_pusher    -> Port D -> large motor responsible for rotational motion
                of the block pusher
ultrasonic      -> Port 2 -> sensor responsible for measuring distances of 
                the blocks and homing position  
touchsensor_top   -> Port 3 -> sensor that detects when the block is pushed
                in either A or C bins
touchsensor_bot   -> Port 4 -> sensor that detects when the block is pushed
                in either B or D bins
Package B: Barcode Decoder 
color_sensor     -> Port 1 -> sensor responsible for detecting the light
                intensity of the barcode
%}
clear all
clc 

%% Initialize connection
EV3 = legoev3('usb');

% Connect Large Motor
motor_conveyer = motor(EV3, 'A');
motor_pusher = motor(EV3, 'D');
% Connect Ultrasonic sensors
ultrasonic = sonicSensor(EV3, 2); % Connect ultrasonic sensor
% Connect Touch sensors
touchsensor_top = touchSensor(EV3, 3);
touchsensor_bot = touchSensor(EV3, 4);
% Connect Color sensor
color_sensor = colorSensor(EV3, 1);

% %% Ask the user for the distance
% prompt = 'Please enter a number between 1 to 4\n';
% bardecoded = input(prompt);

%% Start 
motor_conveyer.Speed = - 100; % Towards sonic sensor
stop(motor_pusher);
start(motor_conveyer);

%% Part1: Barcode Decoding

delayreading = 0.00001; % time delay between each reading
range = 600;
intensity = zeros(1, range);
time = delayreading*linspace(1, range, range);
stop_reading = 0;

while true
    intensity_reflected = readLightIntensity(color_sensor, 'reflected');
 
    if intensity_reflected > int32(20) % Block is detected
        for i = 1:range
            intensity(:, i) = readLightIntensity(color_sensor, 'reflected');
            pause(delayreading) % reads every 0.01ms
            if i == range
                stop_reading = 1;
            end
        end
    end
    if stop_reading == 1
        break;
    end
end

% Light Intensity Matrix is Cleaned up using Dr.Enright's prgram
clean_intensity = clean_barcode(intensity);
light_intensity = clean_intensity';

% Plots noisy and clean intensity readings overtime
figure
hold on
plot (time, light_intensity); % clean signal
plot (time, intensity) % noisy signal
title ('light intensity with respect to time')
xlabel('time [s]')
ylabel('light intensity')

%Decodes the barcode
bardecoded_1234 = decypher(light_intensity)

validation = sum(bardecoded_1234);

if validation == 20 % checks for if the barcode scanned is valid

[bardecoded_quadrant, bardecoded_char] = barcodes_list(bardecoded_1234)


% Part 2: Sorting
% Find block location in the conveyer and the rotation of the pusher
[conveyer_loc, pusher_rot] = location_rotation(bardecoded_quadrant);

located = 0;
location0_dis = 15.5 * 0.01;
location1_dis = 10 * 0.01;
location2_dis = 4 * 0.01;
zeroed = 0;
delay_90deg = 6; % time delay it takes for pusher motor to go back to 90 deg


while located == 0 % loop will run until block is placed in the right location
    % Conveyer is zeroed and conveyer location is 2
    distance = readDistance(ultrasonic);
    top_touched = readTouch(touchsensor_top);
    bottom_touched = readTouch(touchsensor_bot);
    if distance <= location2_dis
        zeroed = 1;
        if conveyer_loc == 2 && pusher_rot == 1
            stop(motor_conveyer);
            motor_pusher.Speed = - 10; % push for top
            start(motor_pusher);
        elseif conveyer_loc == 2 && pusher_rot == 2
            stop(motor_conveyer)
            motor_pusher.Speed = 10; % push for bot
            start(motor_pusher)
        else
            motor_conveyer.Speed = 100; %reverse motor rotation
        end
    end
 
    % Conveyer is zeroed and conveyer location is 1
    if distance >= location1_dis && zeroed == 1
        if conveyer_loc == 1 && pusher_rot == 1
            stop(motor_conveyer)
            motor_pusher.Speed = - 10; % push for top
            start(motor_pusher)
        elseif conveyer_loc == 1 && pusher_rot == 2
            stop(motor_conveyer)
            motor_pusher.Speed = 10; % push for bot
            start(motor_pusher)
        end
    end
 
    % Pusher rotates accordingly
    if top_touched == 1
        motor_pusher.Speed = 10; % reverse the direction
        start(motor_pusher);
        pause(delay_90deg);
        stop(motor_pusher);
        located = 1;
    elseif bottom_touched == 1
        motor_pusher.Speed = - 10; % reverse the direction
        pause(delay_90deg);
        stop(motor_pusher);
        located = 1;
    end
end

% Part 3: Reset the mechanism to the loading dock

docked = 0;
delay_docked = 11.5; % time delay it takes for the conveyer to reach loading dock

%Reset to loading dock
while docked == 0 % block travels 
    distance = readDistance(ultrasonic);
    motor_conveyer.Speed = - 100;
    start(motor_conveyer);
    if distance <= location2_dis
        zeroed = 1;
        %stop(motor_conveyer)
        motor_conveyer.Speed = 100;
        %start(motor_conveyer)
        pause(delay_docked);
        stop(motor_conveyer);
        docked = 1;
    end
end

% Unrecognized Glyph
elseif validation ~= 20 || located==1
docked = 0;
delay_docked = 12; % time delay it takes for the conveyer to reach loading dock
delay_docked_early = 7.5; 
location2_dis = 4 * 0.01;

%Reset to loading dock
while docked == 0 % block travels 
    distance = readDistance(ultrasonic);
    motor_conveyer.Speed = - 100;
    start(motor_conveyer);
    if distance <= location2_dis
        zeroed = 1;
        %stop(motor_conveyer)
        motor_conveyer.Speed = 100;
        %start(motor_conveyer)
        pause(delay_docked_early);
        disp('Unrecoginzed glyph')
        stop(motor_conveyer);
        docked = 1;
    end
end
end 
%Reset to loading dock
%zero the mechanism
%reverse the direction
%add a time delay until the conveyer belt is at the loading dock








