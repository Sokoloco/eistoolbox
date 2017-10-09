function varargout = removehigherthan(varargin)
% REMOVEHIGHERTHAN MATLAB code for removehigherthan.fig
%      REMOVEHIGHERTHAN, by itself, creates a new REMOVEHIGHERTHAN or raises the existing
%      singleton*.
%
%      H = REMOVEHIGHERTHAN returns the handle to a new REMOVEHIGHERTHAN or the handle to
%      the existing singleton*.
%
%      REMOVEHIGHERTHAN('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in REMOVEHIGHERTHAN.M with the given input arguments.
%
%      REMOVEHIGHERTHAN('Property','Value',...) creates a new REMOVEHIGHERTHAN or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before removehigherthan_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to removehigherthan_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help removehigherthan

% Last Modified by GUIDE v2.5 09-Oct-2017 12:21:48

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @removehigherthan_OpeningFcn, ...
                   'gui_OutputFcn',  @removehigherthan_OutputFcn, ...
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

% --- Executes just before removehigherthan is made visible.
function removehigherthan_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to removehigherthan (see VARARGIN)

% Choose default command line output for removehigherthan
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes removehigherthan wait for user response (see UIRESUME)
uiwait(handles.guiremoveHT);

function varargout = removehigherthan_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.maxreal;
varargout{2} = handles.maximag;
delete(hObject);

% --- Executes when user attempts to close guiremoveHT.
function guiremoveHT_CloseRequestFcn(hObject, eventdata, handles)
    if isequal(get(hObject, 'waitstatus'), 'waiting')
        % The GUI is still in UIWAIT, call UIRESUME
        uiresume(hObject);
        %delete(hObject);
    else
        % The GUI is no longer waiting, just close it
        delete(hObject);
    end

function realval_Callback(hObject, eventdata, handles)

function realval_CreateFcn(hObject, eventdata, handles)

function imagval_Callback(hObject, eventdata, handles)

function imagval_CreateFcn(hObject, eventdata, handles)


function btn_cancelHT_Callback(hObject, eventdata, handles)
    handles.maxreal = -1;
    handles.maximag = -1;
    guidata(hObject, handles);
    disp('Info: The user cancelled the operation');
    close(handles.guiremoveHT);

function btn_removeHT_Callback(hObject, eventdata, handles)
    maxreal = str2double(get(handles.realval,'String'));
    maximag = str2double(get(handles.imagval,'String'));
    %ToDo: check for consistency (i.e. user wrote garbage)
    handles.maxreal = maxreal;
    handles.maximag = maximag;
    guidata(hObject, handles);
    disp(strcat('Info: We will remove values larger than Real: ',string(maxreal),'and Imag: ',string(maximag)));
    close(handles.guiremoveHT);

