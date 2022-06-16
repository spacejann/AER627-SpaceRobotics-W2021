function [barcode_result] = decypher(light_intensity)
%decipher Summary of this function goes here
%   Detailed explanation goes here


n = size(light_intensity,2);

time = linspace(1, n,n);
max_val = max(light_intensity);
min_val = min(light_intensity);

light_intensity_diff = [diff(light_intensity), min_val];

switcharu_index = zeros(1,10);
BoW_index = zeros(1,9);
BoW_width = zeros(1,9);
BoW_NoW = zeros(1,4); 
switcharu_counter = 1;

for i =1:n
    max_cond = abs(light_intensity(i) - max_val);
    min_cond = abs(light_intensity(i) - min_val);
    
    if abs(light_intensity_diff(i)) > 0.8*max_val
        switcharu_index(switcharu_counter) = i;
        switcharu_counter = switcharu_counter + 1;
    end
   
end

width_ratio  = diff(switcharu_index);
mean_width = mean(width_ratio);
for i = 1:9
    BoW_index(i) = light_intensity(switcharu_index(i+1))-light_intensity(switcharu_index(i));
    if BoW_index(i) < 0
        BoW_color(i) = 1; % black 
    else 
        BoW_color(i) = 0; %White 
    end 

    if width_ratio(i) > mean_width
        BoW_width(i) = 1; %Wide 
    else
        BoW_width(i) = 0; % Narrow 
    end 
    
    if BoW_color(i) == 1 && BoW_width(i) == 0 
        BoW_NoW(i) = 1; %Narrow Black 
    elseif BoW_color(i) == 1 && BoW_width(i) == 1
        BoW_NoW(i) = 2; %Wide Black
    elseif BoW_color(i) == 0 && BoW_width(i) == 0
        BoW_NoW(i) = 3; %Narrow White
    elseif BoW_color(i) == 0 && BoW_width(i) == 1
        BoW_NoW(i) = 4; %Wide White
    end 
end 


% Display the result 

% barcode_result = barcode_lists(BoW_NoW);

barcode_result = BoW_NoW;

% outputArg1 = inputArg1;
% outputArg2 = inputArg2;
end

