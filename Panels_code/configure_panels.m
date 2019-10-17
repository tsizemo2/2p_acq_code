function panelsReady = configure_panels(patternNum, varargin)
%===================================================================================================
% This function sets up the panels for use in an open- or closed-loop experiment. After running this
% function the panels will be primed and ready to be started by a TTL trigger.
%
% INPUTS:
%       patternNum = the number of the pattern to be used (as indexed on the controller).
%
% OPTIONAL NAME-VALUE PAIR INPUTS:                   
%
%       'DisplayRate'   = (default: 200) display update rate for the panels in Hz
%
%       'InitialPos'    = (default: [1 1]) a two-element vector specifying the initial [x, y] 
%                         position that the panels should start in (this position will be considered 
%                         the reference position for all future pattern index commands). NOTE: this
%                         value is 1-indexed, so the default [1 1] will start at the first 
%                         pattern position.
%
%       'PanelMode'     = (default: 'OpenLoop') string specifying whether the panels will be 
%                         operating under open loop or closed loop control.
%
%       'ClosedLoopDim' = (default: 'x') if in closed loop mode, the dimension of the pattern that 
%                         will be controlled by the analog input signal.
%                       
%       'PosFunNumX'    = (default: 1) if in open loop mode, the number of the position function to 
%                         use for controlling the pattern in the X dimension.
% 
%       'PosFunNumY'    = (default: 1) if in open loop mode, the number of the position function to 
%                         use for controlling the pattern in the Y dimension.
%
%===================================================================================================

panelsReady = 0;

% Parse optional arguments
p = inputParser;
addParameter(p, 'DisplayRate', 200);
addParameter(p, 'InitialPos', [1 1]); 
addParameter(p, 'PanelMode', 'OpenLoop');
addParameter(p, 'ClosedLoopDim', 'x');
addParameter(p, 'PosFunNumX', 1);
addParameter(p, 'PosFunNumY', 1);
parse(p, varargin{:});
displayRate = p.Results.DisplayRate;
initialPos = p.Results.InitialPos;
panelMode = p.Results.PanelMode;
closedLoopDim = p.Results.ClosedLoopDim;
posFunNumX = p.Results.PosFunNumX;
posFunNumY = p.Results.PosFunNumY;

% Set pattern number
Panel_com('set_pattern_id', patternNum);
pause(0.03)

% Set initial position
Panel_com('set_position',  initialPos) % Panel_com will convert this from 1-indexed to 0-indexed
pause(0.03)

% Set X and Y position functions. Function #1 should always be a static vector telling the panels to 
% just remain at the first index for that dimension.
Panel_com('set_posfunc_id', [1, posFunNumX]);
pause(0.03)
Panel_com('set_posfunc_id', [2, posFunNumY]);
pause(0.03)

% Set panel mode - technically each dimension can be set to any of the modes outlined below, but we
% only use one of two settings in our setups.
%   0 - open loop (but not the one we use - rather than accepting a vector of external pattern
%       indices, this one uses gain and bias settings to cycle through the pattern frames in order)
%   1 - closed loop (but not the one we use - I believe this is for flying closed loop)
%   2 - both (flying closed loop plus a position function as a bias)
%   3 - external input sets position                       <-- CLOSED LOOP FOR OUR EXPERIMENTS
%   4 - internal function generator sets velocity/position <-- OPEN LOOP FOR OUR EXPERIMENTS
%   5 - interal function generator debug mode
if strcmp(panelMode, 'OpenLoop')
    % Argument is [Xmode, Ymode]. Both dimensions will use the position functions provided.
    Panel_com('set_mode', [4, 4]) 
    pause(0.03)
elseif strcmp(panelMode, 'ClosedLoop')
    % Set one dimension to be under external closed loop control, and lock the other in its starting 
    % position.
    if strcmp(closedLoopDim, 'x')
        Panel_com('set_mode', [3, 0]); 
    elseif strcmp(closedLoopDim, 'y')
        Panel_com('set_mode', [0, 3]);
    else
        error('Invalid closed loop dim. Valid values are "x" or "y".'); 
    end
    pause(0.03);
    % Make sure the dimension that's not under closed-loop control just stays in its intial 
    % position (setting the rate of cycling through pattern frames to zero in mode #0)
    Panel_com('send_gain_bias', [0 0 0 0]);
    pause(0.03);
else
    error('Invalid panel mode. Valid values are "OpenLoop" or "ClosedLoop".');
end

% Set display update frequency
Panel_com('set_funcy_freq', displayRate);
pause(0.03);
Panel_com('set_funcx_freq', displayRate);
pause(0.03);

% Enable external trigger
%  Panel_com('enable_extern_trig');
Panel_com('start');
% pause(0.03);

panelsReady = 1;

end