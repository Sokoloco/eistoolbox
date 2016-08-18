function varargout = showcorrelations(varargin)
% SHOWCORRELATIONS MATLAB code for showcorrelations.fig
%      SHOWCORRELATIONS, by itself, creates a new SHOWCORRELATIONS or raises the existing
%      singleton*.
%
%      H = SHOWCORRELATIONS returns the handle to a new SHOWCORRELATIONS or the handle to
%      the existing singleton*.
%
%      SHOWCORRELATIONS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SHOWCORRELATIONS.M with the given input arguments.
%
%      SHOWCORRELATIONS('Property','Value',...) creates a new SHOWCORRELATIONS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before showcorrelations_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to showcorrelations_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help showcorrelations

% Last Modified by GUIDE v2.5 18-Aug-2016 15:24:20

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @showcorrelations_OpeningFcn, ...
                   'gui_OutputFcn',  @showcorrelations_OutputFcn, ...
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


% --- Executes just before showcorrelations is made visible.
function showcorrelations_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to showcorrelations (see VARARGIN)

% Choose default command line output for showcorrelations
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes showcorrelations wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = showcorrelations_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
