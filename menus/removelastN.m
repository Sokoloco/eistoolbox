function varargout = removelastN(varargin)
% Bug: error when trying to close without clicking any button

% REMOVELASTN MATLAB code for removelastN.fig
%      REMOVELASTN, by itself, creates a new REMOVELASTN or raises the existing
%      singleton*.
%
%      H = REMOVELASTN returns the handle to a new REMOVELASTN or the handle to
%      the existing singleton*.
%
%      REMOVELASTN('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in REMOVELASTN.M with the given input arguments.
%
%      REMOVELASTN('Property','Value',...) creates a new REMOVELASTN or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before removelastN_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to removelastN_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help removelastN

% Last Modified by GUIDE v2.5 09-Oct-2017 11:52:01

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @removelastN_OpeningFcn, ...
                   'gui_OutputFcn',  @removelastN_OutputFcn, ...
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


% --- Executes just before removelastN is made visible.
function removelastN_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to removelastN (see VARARGIN)

% Choose default command line output for removelastN
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes removelastN wait for user response (see UIRESUME)
uiwait(handles.guiremoveN);

% --- Outputs from this function are returned to the command line.
function varargout = removelastN_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.result;
delete(hObject);

function btn_lastN_remove_Callback(hObject, eventdata, handles)
    Npoints = str2double(get(handles.edit_N,'String'));
    if (Npoints==0)
        disp('Info: No points to remove. Aborting.')
        handles.result = -1;
        guidata(hObject, handles);
    elseif Npoints<0
        disp('Error: Wrong number of points. Aborting.');
        handles.result = -1;
        guidata(hObject, handles);
    else
        disp(strcat('Info: We will remove the last ',string(Npoints),' points'));
        handles.result = Npoints;
        guidata(hObject, handles);
    end
    close(handles.guiremoveN);

function btn_lastN_cancel_Callback(hObject, eventdata, handles)
    handles.result = -1;
    guidata(hObject, handles);
    disp('Info: The user cancelled the operation');
    close(handles.guiremoveN);

function edit_N_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function edit_N_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_N (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes when user attempts to close guiremoveN.
function guiremoveN_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to guiremoveN (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
if isequal(get(hObject, 'waitstatus'), 'waiting')
    % The GUI is still in UIWAIT, call UIRESUME
    uiresume(hObject);
    %delete(hObject);
else
    % The GUI is no longer waiting, just close it
    delete(hObject);
end

