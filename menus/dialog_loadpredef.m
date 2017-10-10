function varargout = dialog_loadpredef(varargin)
% Last Modified by GUIDE v2.5 10-Oct-2017 13:28:37

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


function dialog_loadpredef_OpeningFcn(hObject, eventdata, handles, varargin)

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
imshow('predef_ladder.png');
% Update handles structure
guidata(hObject, handles);

uiwait(handles.gui_circs);

function varargout = dialog_loadpredef_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;
delete(hObject);

function pushbutton1_Callback(hObject, eventdata, handles)
handles.output = 1;
guidata(hObject, handles);
close(handles.gui_circs);

function pushbutton2_Callback(hObject, eventdata, handles)
handles.output = 2;
guidata(hObject, handles);
close(handles.gui_circs);

function pushbutton3_Callback(hObject, eventdata, handles)
handles.output = 3;
guidata(hObject, handles);
close(handles.gui_circs);

function pushbutton4_Callback(hObject, eventdata, handles)
handles.output = 4;
guidata(hObject, handles);
close(handles.gui_circs);

function pushbutton5_Callback(hObject, eventdata, handles)
handles.output = 5;
guidata(hObject, handles);
close(handles.gui_circs);

function pushbutton6_Callback(hObject, eventdata, handles)
handles.output = 6;
guidata(hObject, handles);
close(handles.gui_circs);

% --- Executes during object creation, after setting all properties.
function gui_circs_CreateFcn(hObject, eventdata, handles)
% hObject    handle to gui_circs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes when user attempts to close gui_circs.
function gui_circs_CloseRequestFcn(hObject, eventdata, handles)
% Hint: delete(hObject) closes the figure
if isequal(get(hObject, 'waitstatus'), 'waiting')
    % The GUI is still in UIWAIT, call UIRESUME
    uiresume(hObject);
    %delete(hObject);
else
    % The GUI is no longer waiting, just close it
    delete(hObject);
end
