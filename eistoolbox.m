function varargout = eistoolbox(varargin)
% eistoolbox MATLAB code for eistoolbox.fig
%      eistoolbox, by itself, creates a new eistoolbox or raises the existing
%      singleton*.
%
%      H = eistoolbox returns the handle to a new eistoolbox or the handle to
%      the existing singleton*.
%
%      eistoolbox('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in eistoolbox.M with the given input arguments.
%
%      eistoolbox('Property','Value',...) creates a new eistoolbox or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before eistoolbox_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to eistoolbox_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help eistoolbox

% Last Modified by GUIDE v2.5 12-Aug-2016 14:46:50

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @eistoolbox_OpeningFcn, ...
                   'gui_OutputFcn',  @eistoolbox_OutputFcn, ...
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


% --- Executes just before eistoolbox is made visible.
function eistoolbox_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to eistoolbox (see VARARGIN)

% Choose default command line output for eistoolbox
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes eistoolbox wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = eistoolbox_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes during object creation, after setting all properties.
function figure1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% CODE FOR JAVA FILE PICKER (INSTEAD OF UIGETFILE)
% import javax.swing.JFileChooser;
% [jPanel,hPanel] = javacomponent(javax.swing.JPanel, [5 5 600 400], hObject);
% jchooser = javaObjectEDT('javax.swing.JFileChooser', pwd );
% set(handle(jchooser, 'callbackproperties'),'ActionPerformedCallback', 'disp(''Action'')')
% jPanel.add(jchooser) % Show the actual dialog


% CALLBACK: btn_addfiles_Callback =========================================
function btn_addfiles_Callback(hObject, eventdata, handles)
    % ToDo: process .CSV files correctly, currently only .DTA support
        % - Check extension and select the reading function accordingly
        % - GamryRead for .DTA; dlmread for .CSV; etc.

    % Ask for data: Open the file dialog 'uigetfile' with Multiselect 'on'
    [fileName, filePath] = uigetfile( ...
        {'*.dta','Gamry Files (*.dta)'; % File type definition: Gamry
         '*.csv','[ToDo] CSV Files (*.csv)';   % File type definition: CSV
         '*.*','All Files (*.*)'}, ...
       'Select the impedance files','Multiselect','on');

   % What happens if no file was selected? (i.e. cancel button)
   if isequal(fileName,0)
       disp('Info: No file was selected');
       return;  % terminate the callback here
   end
   
   disp('Info: Loading input data files -please wait-');
   
    % Clear the 'data' variable, to avoid using old data already loaded
    if exist('data','var') clear('data'); end

    % Check if the user had selected one file (char), or more than one (cell)
    if ~iscell(fileName) % only one file was selected by the user
        fullfname = char(fullfile(filePath,fileName));  % calculate full fname
        data{1} = GamryRead(fullfname); % open file and extract FREQ,REAL,IMAG
    else % more than one file was selected by the user
        for idx=1:length(fileName)
            fullfname = char(fullfile(filePath,fileName(idx)));  % calculate full fname
            data{idx} = GamryRead(fullfname); % open file and extract FREQ,REAL,IMAG
        end
    end

    disp('Info: Input data files succesfully loaded');
    disp('Info: Plotting Nyquist response of input data files');
    
    % Now we plot all the acquired data from the files
    axes(handles.axes1); % Select the axes 1 for plotting input data (Nyquist)
    cla reset;  % Clears any old information already present in the diagram
    hold on;
    for idx=1:length(data)
        plot(data{idx}(:,2),abs(data{idx}(:,3)));
    end
    
    disp('Info: Input data files succesfully plotted');
% END OF CALLBACK: btn_addfiles_Callback ==================================






% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1


% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


set(hObject,'String',{'Select Algorithm...','Zfit (fminsearch)','[ToDo] Levenberg-Marquardt','[ToDo] Nelder-Mead','[ToDo] BFGS','[ToDo] Powell'});


% CALLBACK: btn_fit_Callback ==============================================
function btn_fit_Callback(hObject, eventdata, handles)
% hObject    handle to btn_fit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% END OF CALLBACK: btn_fit_Callback =======================================


% --- Executes during object creation, after setting all properties.
function axes1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes1


% --- Executes during object creation, after setting all properties.
function axes2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes2



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in btn_saveas.
function btn_saveas_Callback(hObject, eventdata, handles)
% hObject    handle to btn_saveas (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[outFileName,outPathName] = uiputfile({'*.xls','Excel Spreadsheet (*.xls)'});



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double


% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double


% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
