%code39_decoder 
%AER 627 Intro to Space Robotics 
%Project 2: Sorting Robot - Package B  
%Jann Cristobal
%500815181

%% Simulation 
for k = 1:20
% Asks user to enter a character to decipher.

% prompt = 'Please enter a single digit or letter character\n'
% character = input(prompt, 's');
% 
% while true
%     if length(character) > 1
%     fprintf ('Invalid,\n')
%     prompt = ('Please enter a single digit or letter character\n');
%     character = input(prompt, 's');
%     else  
%        break;
%     end 
% end

characters = char([...
    '1','2','3','4','5','6','7','8','9','0','A','B','C','D','E','F','G',...
    'H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X',...
    'Y','Z']);
character(k) = characters(randi(numel(characters)));

light_intensity = sim_barcode(character(k));
n = size(light_intensity,2);

time = linspace(1, n,n);
max_val = max(light_intensity);
min_val = min(light_intensity);

figure 
hold on 
plot (time,light_intensity)

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
quadrant = 0;
[quadrant, barcode_result(k)] = barcodes_list(BoW_NoW);

fprintf('The character is %c\n', character(k));

fprintf('The barcode deciphered is %c\n', barcode_result(k));
BoW_NoW

end