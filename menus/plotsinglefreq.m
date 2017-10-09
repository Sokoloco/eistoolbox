function varargout = plotsinglefreq(varargin)
% PLOTSINGLEFREQ MATLAB code for plotsinglefreq.fig
%      PLOTSINGLEFREQ, by itself, creates a new PLOTSINGLEFREQ or raises the existing
%      singleton*.
%
%      H = PLOTSINGLEFREQ returns the handle to a new PLOTSINGLEFREQ or the handle to
%      the existing singleton*.
%
%      PLOTSINGLEFREQ('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PLOTSINGLEFREQ.M with the given input arguments.
%
%      PLOTSINGLEFREQ('Property','Value',...) creates a new PLOTSINGLEFREQ or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before plotsinglefreq_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to plotsinglefreq_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help plotsinglefreq

% Last Modified by GUIDE v2.5 09-Oct-2017 14:22:37

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @plotsinglefreq_OpeningFcn, ...
                   'gui_OutputFcn',  @plotsinglefreq_OutputFcn, ...
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

function plotsinglefreq_OpeningFcn(hObject, eventdata, handles, varargin)
uiwait(handles.guiplotsingle);

function varargout = plotsinglefreq_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.desiredfreq;
delete(hObject);

function btn_do_plotsingle_Callback(hObject, eventdata, handles)
    desiredfreq = str2double(get(handles.edit_plotfreq,'String'));
    handles.desiredfreq = desiredfreq;
    guidata(hObject, handles);
    disp(strcat('Info: We will plot at the frequency: ',string(desiredfreq)));
    close(handles.guiplotsingle);

function btn_cancel_plotsinglefreq_Callback(hObject, eventdata, handles)
    handles.desiredfreq = -1;
    guidata(hObject, handles);
    disp('Info: The user cancelled the operation');
    close(handles.guiplotsingle);

function edit_plotfreq_Callback(hObject, eventdata, handles)

function edit_plotfreq_CreateFcn(hObject, eventdata, handles)

function guiplotsingle_CloseRequestFcn(hObject, eventdata, handles)
% Hint: delete(hObject) closes the figure
if isequal(get(hObject, 'waitstatus'), 'waiting')
    % The GUI is still in UIWAIT, call UIRESUME
    uiresume(hObject);
    %delete(hObject);
else
    % The GUI is no longer waiting, just close it
    delete(hObject);
end

