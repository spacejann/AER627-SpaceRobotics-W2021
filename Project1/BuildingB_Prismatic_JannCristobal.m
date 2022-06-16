%{
AER 627 Intro to Space Robotics 
Project 1: Building B - Prismatic Joint
Jann Cristobal
500815181
 
Nomenclature 
ultrasonic      -> is the sensor that triggers when mechanism is homed and 
                   maxed 
motor1          -> is the large motor providing the rotational motion

distance_in     -> is the required distance 

r_1             -> is the arm link 1 length (varries)
r_2             -> is the arm link 2 length (fixed)
r_3             -> is the arm link 3 length (fixed)

t_1             -> is the angle about Joint A from the diagrams (sym)
t_2             -> is the angle about Joint C from the diagrams (sym)

theta_out       -> is the theta_1 angle about Joint A from the diagrams
theta_in        -> is the angle required for the motor1. Calculated using 
                   the gear ratio

delay           -> is the time delay used to compensate for the motion bias

homed           -> is an indicator that the mechanism has be homed. 
                   1 = yes, 0 = no
motor1RotAngle  -> is the current angular position of the motor

angle_diff      -> is the difference between the required theta_in and 
                   current motor1 angle motor1RotAngle

sonicmeasured   -> is the distance measured by the sonic sensor with
                   respect to the zero position 
%}
clear all
clc
%% Initialize connection
EV3 = legoev3('usb');

% Connect sonic sensors
ultrasonic = sonicSensor(EV3, 2); % Connect ultrasonic sensor
% Connect Motor 
motor1 = motor(EV3, 'A');
motor1.Speed = 25;

% Ask the user for the distance 
prompt = 'Please enter a distance between 0cm to 4.8cm \n';
distance_in = 0.01*single(input (prompt)); % convert cm to m

% Checks if the user input is within the distance range
while true
if distance_in < 0 || distance_in > 0.0481
    r_1 = 0.04;
    fprintf ('Invalid,\n')
    prompt = 'Please enter a distance between 0cm to 4.8cm \n';
    distance_in = 0.01*single(input (prompt)); % convert cm to m
else  
     r_1 = distance_in + 0.04; % [m] calculates length of link 1
    break;
end 
end 

 r_3 = 0.064; %[m] arm link 3 fixed
 r_2 = 0.024; %[m] arm link 2 fixed

% Solves for the angle t1 about joint A
syms t1 t2
 eqns = [r_2*sin(t1)==r_3*sin(t2), r_1 == r_2*cos(t1)+r_3*cos(t2)];
S = solve(eqns, [t1, t2]); 

theta_out = abs(double(rad2deg(S.t1(1)))); % angle 

theta_in = int32(25*(180-theta_out)); 
% ^gear ratio of 1:25 requires motor1 25 times the angle input

% Time delay to compensate for distance error
n = int32(100*distance_in);
switch n
    case 1
        delay = 0.8 % [seconds]
    case 2
        delay = 2.5
    case 3
        delay = 4.25
    case 4
        delay = 6.25
    case 5
        delay = 7.5
    otherwise 
        delay = 0
end 

zero_val = single(0.076); % sonic sensor measurement for zero location 
max_val = single(0.031); % maximum distance allowable
homed = 0;
%% 
while true 
    start(motor1)
    distance = readDistance(ultrasonic);
    motor1RotAngle = readRotation(motor1);
    angle_diff = abs(motor1RotAngle) - abs(theta_in);
        % Home the system to zero position 
    if distance == single(0.0760)
        fprintf ('Homed')
        pause (2) 
        homed = 1;
        resetRotation(motor1);
        motor1RotAngle = readRotation(motor1);
        fprintf('motor angle %f', motor1RotAngle)
        start(motor1);
        motor1.Speed = -25;
    end 
    % If max value is hit, reverse the rotation until homed
    if distance == max_val
        fprintf ('Max Distance Reached')
        pause(1)
        motor1.Speed = 25;
        homed = 0;
        start(motor1)
    end
    % Find the linear distance given by the user input
    if abs(angle_diff) < 10 && homed == 1
        % measure the distance from homed position using sonic sensor
        sonicmeasured = 100*(0.076-distance); 
        % ^sonic measurements with respect to the 0 position
        fprintf('The distance outputed is %f cm\n', 100*distance_in)
        fprintf('Sonic Measures %f cm\n', sonicmeasured)
        pause(delay)
        stop(motor1);
        break;
    end
end 





