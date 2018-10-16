function varargout = fly_tracker_MM(varargin)
% FLY_TRACKER_MM MATLAB code for fly_tracker_MM.fig
%      FLY_TRACKER_MM, by itself, creates a new FLY_TRACKER_MM or raises the existing
%      singleton*.
%
%      H = FLY_TRACKER_MM returns the handle to a new FLY_TRACKER_MM or the handle to
%      the existing singleton*.
%
%      FLY_TRACKER_MM('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FLY_TRACKER_MM.M with the given input arguments.
%
%      FLY_TRACKER_MM('Property','Value',...) creates a new FLY_TRACKER_MM or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before fly_tracker_MM_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to fly_tracker_MM_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help fly_tracker_MM

% Last Modified by GUIDE v2.5 26-Nov-2017 13:57:25

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @fly_tracker_MM_OpeningFcn, ...
                   'gui_OutputFcn',  @fly_tracker_MM_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before fly_tracker_MM is made visible.
function fly_tracker_MM_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to fly_tracker_MM (see VARARGIN)

% Choose default command line output for fly_tracker_MM
handles.output = hObject;

% UIWAIT makes fly_tracker_MM wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% Prompt for an experiment directory
defaultDir = 'C:\Users\Wilson Lab\Desktop\Michael\';
if ~isdir(defaultDir)
    defaultDir = 'C:\Users\';
end
dname = uigetdir(defaultDir, 'Please chose an experiment directory.');
handles.expDir = dname;

ghandles = guihandles(hObject);
set(ghandles.expDirEdit, 'String', dname);

% Update handles structure
guidata(hObject, handles);

% --- Outputs from this function are returned to the command line.
function varargout = fly_tracker_MM_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% ==================================================================================================
% CREATE FUNCTIONS
% ==================================================================================================

function expDirEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to expDirEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function preStimEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to preStimEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function interTrialIntervalEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to interTrialIntervalEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function stimTypeMenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to stimTypeMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function taskFileEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to taskFileEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function sidEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sidEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% ==================================================================================================
% CALLBACK FUNCTIONS
% ==================================================================================================

function expDirButton_Callback(hObject, eventdata, handles)                                        % <-------- expDirButton CALLBACK
% hObject    handle to expDirButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

dname = uigetdir('C:\Users\Wilson Lab\Desktop\Michael\');
handles.expDir = dname;

ghandles = guihandles(hObject);
set(ghandles.expDirEdit, 'String', dname);

% Update handles structure
guidata(hObject, handles);


function taskFileButton_Callback(hObject, eventdata, handles)                                      % <-------- taskFileButton CALLBACK
% hObject    handle to taskFileButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[FileName,PathName] = uigetfile(['C:\Users\Wilson Lab\Desktop\Michael\2p_acq_code\Task files\', '*.txt'],'Select a task file');

handles.taskFilePath = [PathName '\' FileName];

ghandles = guihandles(hObject);
set(ghandles.taskFileEdit, 'String', handles.taskFilePath);

guidata(hObject, handles);  

function runButton_Callback(hObject, eventdata, handles) %                                         %<------------------ RUN BUTTON CALLBACK
% hObject    handle to runButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

ghandles = guihandles(hObject);

%------------- Pull data from GUI objects-----------------------------------------------------------
run_obj.expDir = get(ghandles.expDirEdit, 'String');
run_obj.taskFilePath = get(ghandles.taskFileEdit, 'String');
run_obj.ITI = str2double(get(ghandles.interTrialIntervalEdit, 'String'));
run_obj.sid = str2double(get(ghandles.sidEdit, 'String'));

run_obj.trialDuration = str2double(get(ghandles.preStimEdit, 'String'));

run_obj.using2P = get(ghandles.using2PRadio, 'Value');

%------------- Data validity checks ----------------------------------------------------------------

if isempty(run_obj.taskFilePath)
    errordlg('Please set the task file path.')
    return;
end
if run_obj.ITI == 0
   errordlg('ITI value must be >0') 
   return;
end
%-------- Start trials -----------------------------------------------------------------------------

start_trials_MM(run_obj);
guidata(hObject, handles);

function stopButton_Callback(hObject, eventdata, handles)                                          % <-------- stopButton CALLBACK
% hObject    handle to stopButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global s;
s.stop();
release( s );
disp(['Stopped acquisition.']);
