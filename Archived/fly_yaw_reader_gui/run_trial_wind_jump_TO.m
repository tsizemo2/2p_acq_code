function [ trial_data, trial_time ] = run_trial_wind_jump_TO( trial_idx, task, run_obj, scanimage_client, trial_core_name )
%%% for testing wind jump in EB
%%% Tatsuo Okubo
%%% 2018/01/19

global s

disp(['About to start trial task: ' task]);

% Setup data structures for read / write on the daq board
s = daq.createSession('ni');

% This channel is for external triggering of scanimage 5.1
s.addDigitalChannel('Dev1', 'port0/line0', 'OutputOnly');

% These are for inputs: sensor 1 x,y; sensor 2 x,y; frame clock;
ai_channels_used = [0:5];
aI = s.addAnalogInputChannel('Dev1', ai_channels_used, 'Voltage');
for i=1:length(ai_channels_used)
    aI(i).InputType = 'SingleEnded';
end

% digital channels for olfactometer control
s.addDigitalChannel('Dev1', ['port0/line1:4'], 'OutputOnly'); % additional channel for the valves (air, L/C/R)

settings = sensor_settings;

SAMPLING_RATE = settings.sampRate;
s.Rate = SAMPLING_RATE;


%% wind jump parameters
T_1 = 4; %[s]
T_2 = 4; %[s]
Pre = T_1; % [s] between trial onset and first wind onset
FirstWind = T_2; % [s] duration of first wind
SecondWind = T_2; % [s] duration of second wind
Post = T_1; % [s] between offset of the second wind and trial offset
total_duration = Pre + FirstWind + SecondWind + Post;

% initialize the output vectors to zero
Both = zeros(SAMPLING_RATE*total_duration,1); % on for both the first and second halves
First = zeros(SAMPLING_RATE*total_duration,1); % only on for the first half 
Second = zeros(SAMPLING_RATE*total_duration,1); % only on for the second half
Zero = zeros(SAMPLING_RATE*total_duration,1); % off for the entire trial

% set the stimulation pulse
FirstWindOnset = round(Pre * SAMPLING_RATE);
SecondWindOnset = round((Pre + FirstWind) * SAMPLING_RATE);
SecondWindOffset = round((Pre + FirstWind + SecondWind) * SAMPLING_RATE);

Both(FirstWindOnset:SecondWindOffset) = 1; % 
First(FirstWindOnset:SecondWindOnset-1) = 1;
Second(SecondWindOnset:SecondWindOffset) = 1;

%%
imaging_trigger = Zero;
imaging_trigger(2:end-1) = 1.0;

output_data = [];

if( strcmp(task, 'WindCenterRight') == 1 )
    output_data = [imaging_trigger Both Zero First Second];
elseif( strcmp(task, 'WindCenterCenter') == 1 )
    output_data = [imaging_trigger Both Zero Both Zero];
elseif( strcmp(task, 'WindCenterLeft') == 1 )
    output_data = [imaging_trigger Both Second First Zero];
elseif( strcmp(task, 'WindRightLeft') == 1 )
    output_data = [imaging_trigger Both Second Zero First];
elseif( strcmp(task, 'WindLeftRight') == 1 )
    output_data = [imaging_trigger Both First Zero Second];
elseif( strcmp(task, 'WindRightCenter') == 1 )
    output_data = [imaging_trigger Both Zero Second First];
elseif( strcmp(task, 'WindLeftCenter') == 1 )
    output_data = [imaging_trigger Both First Second Zero];
else
    disp(['ERROR: Task: ' task ' is not recognized.']);
end

queueOutputData(s, output_data);

% Trigger scanimage run if using 2p.
if(run_obj.using_2p == 1)
    scanimage_file_str = ['cdata_' trial_core_name '_tt_' num2str(total_duration) '_'];
    fprintf(scanimage_client, [scanimage_file_str]);
    disp(['Wrote: ' scanimage_file_str ' to scanimage server' ]);
    acq = fscanf(scanimage_client, '%s');
    disp(['Read acq: ' acq ' from scanimage server' ]);
end

%% check
figure(1); clf;
set(gcf,'position',[200 200 1200 900])
t = [0:(length(output_data)-1)]./SAMPLING_RATE;
for k=1:5
    subplot(5,1,k)
    plot(t,output_data(:,k))
    switch k
        case 1
            ylabel('Image trigger')
        case 2 
            ylabel('Master valve')
        case 3
            ylabel('Left pinch')
        case 4
            ylabel('Center pinch')
        case 5
            ylabel('Right pinch')
    end
end
xlabel('Time (s)','fontsize',12)
%%

% Delay starting the aquisition for a second to ensure that scanimage is
% ready
pause(1.0);

[trial_data, trial_time] = s.startForeground();

release(s);
end