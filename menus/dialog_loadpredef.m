function varargout = dialog_loadpredef(varargin)
% DIALOG_LOADPREDEF MATLAB code for dialog_loadpredef.fig
%      DIALOG_LOADPREDEF, by itself, creates a new DIALOG_LOADPREDEF or raises the existing
%      singleton*.
%
%      H = DIALOG_LOADPREDEF returns the handle to a new DIALOG_LOADPREDEF or the handle to
%      the existing singleton*.
%
%      DIALOG_LOADPREDEF('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DIALOG_LOADPREDEF.M with the given input arguments.
%
%      DIALOG_LOADPREDEF('Property','Value',...) creates a new DIALOG_LOADPREDEF or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before dialog_loadpredef_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to dialog_loadpredef_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help dialog_loadpredef

% Last Modified by GUIDE v2.5 10-Oct-2017 11:41:06

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @dialog_loadpredef_OpeningFcn, ...
                   'gui_OutputFcn',  @dialog_loadpredef_OutputFcn, ...
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


% --- Executes just before dialog_loadpredef is made visible.
function dialog_loadpredef_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to dialog_loadpredef (see VARARGIN)

% Choose default command line output for dialog_loadpredef
handles.output = hObject;
axes(handles.axes1);
imshow('predef_randles.png');
axes(handles.axes2);
imshow('predef_randlescpe.png');
axes(handles.axes3);
imshow('predef_randlesw.png');
axes(handles.axes4);
imshow('predef_voigt2.png');
axes(handles.axes5);
imshow('predef_voigt3.png');
axes(handles.axes6);
imshow('predef_voigt3.png');
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes dialog_loadpredef wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = dialog_loadpredef_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function figure1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
