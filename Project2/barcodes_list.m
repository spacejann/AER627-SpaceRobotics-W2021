function [barcode_nummatch, barcode_charmatch] = barcodes_list(barcode_read)

list_of_barcodes = [...
    2 3 1 4 1 3 1 3 2;...%1
    1 3 2 4 1 3 1 3 2;...%2
    2 3 2 4 1 3 1 3 1;...%3
    1 3 1 4 2 1 1 1 2;...%4
    2 3 1 4 2 3 1 3 1;...%5
    1 3 2 4 2 3 1 3 1;...%6
    1 3 1 4 1 3 2 3 2;...%7
    2 3 1 4 1 3 2 3 1;...%8
    1 3 2 4 1 3 2 3 1;...%9
    1 3 1 4 2 3 2 3 1;...%0
    2 3 1 3 1 4 1 3 2;...%A
    1 3 2 3 1 4 1 3 2;...%B
    2 3 2 3 1 4 1 3 1;...%C
    1 3 1 3 2 4 1 3 2;...%D
    2 3 1 3 2 4 1 3 1;...%E
    1 3 2 3 2 4 1 3 1;...%F
    1 3 1 3 1 4 2 3 2;...%G
    2 3 1 3 1 4 2 3 1;...%H
    1 3 2 3 1 4 2 3 1;...%I
    1 3 1 3 2 4 2 3 1;...%J
    2 3 1 3 1 3 1 4 2;...%K
    1 3 2 3 1 3 1 4 2;...%L
    2 3 2 3 1 3 1 4 1;...%M
    1 3 1 3 2 3 1 4 2;...%N
    2 3 1 3 2 3 1 4 1;...%O
    1 3 2 3 2 3 1 4 1;...%P
    1 3 1 3 1 3 2 4 2;...%Q
    2 3 1 3 1 3 2 4 1;...%R
    1 3 2 3 1 3 2 4 1;...%S
    1 3 1 3 2 3 2 4 1;...%T
    2 4 1 3 1 3 1 3 2;...%U
    1 4 2 3 1 3 1 3 2;...%V
    2 4 2 3 1 3 1 3 1;...%W
    1 4 1 3 2 3 1 3 2;...%X
    2 4 1 3 2 3 1 3 1;...%Y
    1 4 2 3 2 3 1 3 1;...%Z
                        ];
corresponding_char = char([...
    '1','2','3','4','5','6','7','8','9','0','A','B','C','D','E','F','G',...
    'H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X',...
    'Y','Z']);
    
    n = length(list_of_barcodes);
    match_counter = 0; 
    for i = 1:n % row
        for j = 1:9 % col 
            if barcode_read(1,j) == list_of_barcodes(i,j)
                match_counter = match_counter+1;
            else 
                match_counter = 0;
            end 
        end 
        if match_counter < 9
            match_counter = 0;
        else
            barcode_charmatch = corresponding_char(1,i);
            if barcode_read(1,2) == 4
                barcode_nummatch = 1;
            elseif barcode_read(1,4) == 4
                barcode_nummatch = 2;
            elseif barcode_read(1,6) == 4
                barcode_nummatch = 3;
            elseif barcode_read(1,8) == 4
                barcode_nummatch = 4;
            end
        end 
    end
    
end