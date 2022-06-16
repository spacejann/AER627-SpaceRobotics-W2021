%{
AER 627 Intro to Space Robotics 
Project 1: Building A - Rotary Joint
Jann Cristobal
500815181
 
Nomenclature 
touch_sensor_1  -> is the sensor that triggers when mechanism is homed
touch_sensor_2  -> is the sensor that triggers when mechanism is maxed
motor1          -> is the large motor providing the rotational motion

theta_out       -> is the theta_1 angle about Joint A from the diagrams
theta_in        -> is the angle required for the motor1. Calculated using 
                   the gear ratio

homed           -> is an indicator that the mechanism has be homed. 
                   1 = yes, 0 = no

motor1RotAngle  -> is the current angular position of the motor

angle_diff      -> is the difference between the required theta_in and 
                   current motor1 angle motor1RotAngle
%}
clear all
clc
%% Initialize connection
EV3 = legoev3('usb');

%% Connect sensors and motors 
%touch sensors
touch_sensor_1 = touchSensor(EV3, 1); % Zero Position (0deg)
touch_sensor_2 = touchSensor(EV3, 4); % Max Value position (180deg)
% Motor 
motor1 = motor(EV3, 'A');

% Ask the user for an angle value between 0 and 180 Degrees 
prompt = 'Please enter an integer angle between 0 and 180 degrees\n';
theta_out = int32(input (prompt)); 

compensator = 5; % experimental results show that system is laggin by about 5 degrees
% Checks wether the user input is within the limit
while true
    if theta_out < 0 || theta_out > 180
        fprintf ('Invalid,\n')
        prompt = 'Please enter an integer angle between 0 and 180 degrees\n';
        theta_out = int32(input (prompt));
    else  
        theta_in = int32((theta_out+5)*5); 
        %^the gear ratio between the input and output is 5
    break;
    end 
end 


motor1.Speed = -10; % Rotates toward the homed position
start(motor1);
homed = 0;

while true 
touchread1 = readTouch(touch_sensor_1);
touchread2 = readTouch(touch_sensor_2);
motor1RotAngle = readRotation(motor1);
angle_diff = abs(motor1RotAngle) - abs(theta_in);

    if touchread1 == 1 %condition for when the arm is homed. 
        homed = 1;
        if theta_out == int32(0)
            stop(motor1)
            fprintf('The robot arm is at %f\n', theta_out)
            fprintf('The motor rotation is %f\n', motor1RotAngle)
            break;
        else
        resetRotation(motor1);
        motor1.Speed = 10;
        start(motor1) 
        fprintf('The robot is homed at 0 degrees\n')
        end
    end 
    if touchread2 == 1 %condition for when the max angle is reached
        homed = 0;
        if theta_out == int32(180)
            stop(motor1)
            fprintf('The robot arm is at %f\n', theta_out)
            fprintf('The motor rotation is %f\n', motor1RotAngle)
            break;
        else 
        motor1.Speed = -10;
        start(motor1);   
        end
    end 
    % Condition for angle of rotation with respect to the home of rotary
    % joint
    if abs(angle_diff) < 1 && homed == 1           
            stop(motor1)
            fprintf('The robot arm is at %f\n', theta_out)
            fprintf('The motor rotation is %f\n', motor1RotAngle)
            break;
    end 
end 








