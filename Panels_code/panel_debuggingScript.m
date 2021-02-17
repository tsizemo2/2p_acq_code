% panel debugging - YEF

% set pattern id number
Panel_com('set_pattern_id', 2);
pause(.03)

% Set initial position
Panel_com('set_position', [1,2]) % Panel_com will convert this from 1-indexed to 0-indexed
pause(0.03)


% Panel_com('set_mode', [0, 3]);
% pause(0.03);
Panel_com('set_mode', [3, 0]);
pause(0.03);

Panel_com('start')

% Panel_com('set_mode', [3, 4]);
% pause(0.03)
% Panel_com('set_mode', [4, 3]);
% pause(0.03);
% Panel_com('set_mode', [4, 4]);
% pause(0.03);


Panel_com('set_funcy_freq', 50);
pause(0.03);

Panel_com( 'set_posfunc_id', [ 1, 1 ] );
pause(.03)

Panel_com( 'set_funcx_freq', 50 );
pause(.03)


Panel_com( 'set_posfunc_id',[ 2, 2 ] );
pause(.03)

Panel_com('start')