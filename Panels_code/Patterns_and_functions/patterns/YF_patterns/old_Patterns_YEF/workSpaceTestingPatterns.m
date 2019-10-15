%% ON bar of different widths at any location on the screen
clear all;
numOfPanelsAcross = 7;% 7 panels across
numOfPanelsVertically = 2;%
LEDdotsPerPanel = 8; % this shouldn't change!  LEDs are always 8 dots in x and y. 

LEDdotsAcross = numOfPanelsAcross * LEDdotsPerPanel; % 56 for yvette's set up
LEDdotsVertically = numOfPanelsVertically * LEDdotsPerPanel;% 16 for yvette's current set up

STRIPE_WIDTHS = [0, 1, 3, 7, 13, 25, 120 ]  ; % number of LED dots wide, all ON is used for full screen

%Save general infomation about pattern layout
pattern.x_num = LEDdotsAcross; % this variable will store either ON of OFF for the full screen 
pattern.y_num = 3 + numel( STRIPE_WIDTHS ) - 1; % Y will store, 1 = OFF (x), 2= Pattern,  3-8 (rest of the other 5 widths), 9 = all ON  

pattern.num_panels = 14; 	% This is the number of unique Panel IDs required.
pattern.gs_val = 3; 	% indicates all pixel values in pattern.Pats fall in the range of 0 (dark) and 1-7


MATRIX_SPACER = 100; 
xDim = MATRIX_SPACER*2 + LEDdotsAcross;

Pats = zeros( LEDdotsVertically, xDim, pattern.x_num, pattern.y_num ); 	%initializes the array with zeros

for i = 1: length( STRIPE_WIDTHS )
    
    currStripeWidth = STRIPE_WIDTHS (i); % current stripe width
    
    stripe_pattern = zeros(LEDdotsVertically, xDim);
    
    % make initial stripe pattern centered at x= 101  one = light and background  zero = dark,
    if( currStripeWidth > 0)
    stripeMiddle = MATRIX_SPACER + 1;
    % add middle row of stripe 
    stripe_pattern(:, stripeMiddle) = 1;
    end
    
    oneStripeSideWidth = ( currStripeWidth - 1 )/ 2;
    % add extra sides to the bar
    if( oneStripeSideWidth > 0 )
        % add left side stripe 
        stripe_pattern( :,  stripeMiddle - oneStripeSideWidth: stripeMiddle) = 1;
        
        % add right side stripe
        stripe_pattern( :, stripeMiddle:  stripeMiddle + oneStripeSideWidth) = 1;
    end
    
    for j = 1 : LEDdotsAcross 			%rotate stripe image to each location around the panel set up
        
         shift = j - 1;
         Pats(:, :, j, i) = shiftMatrix( stripe_pattern, shift) ;
    end
    
    
end


pattern.Pats = Pats; 		% put data in structure 

pattern.Panel_map = [1, 3, 5, 7, 9, 11, 13 ; 2 , 4 ,6, 8, 10, 12, 14]; 	% define panel structure vector - YEF arena 2017

pattern.BitMapIndex = process_panel_map(pattern);
pattern.data = Make_pattern_vector(pattern);




