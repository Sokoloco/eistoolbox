function varargout = eistoolbox(varargin)
% eistoolbox by Juan J. Montero-Rodriguez


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

% Clear all previously used variables (to avoid garbage data from a
% previous execution). ToDo: do this at the exit of the program
clearvars -global *;


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

% CODE FOR JAVA MENU_FILE PICKER (INSTEAD OF UIGETFILE)
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

    % Ask for data: Open the menu_file dialog 'uigetfile' with Multiselect 'on'
    [fileName, filePath] = uigetfile( ...
        {'*.dta','Gamry Files (*.dta)'; % File type definition: Gamry
         '*.csv','[ToDo] CSV Files (*.csv)';   % File type definition: CSV
         '*.*','All Files (*.*)'}, ...
       'Select the impedance files','Multiselect','on');

   % What happens if no menu_file was selected? (i.e. cancel button)
   if isequal(fileName,0)
       disp('Info: No file was selected');
       return;  % terminate the callback here
   end
   
   disp('Info: Loading input data files -please wait-');
   
    % Clear the 'data' variable, to avoid using old data already loaded
    if exist('data','var') clearvars -global data; end
   
    global data;    % Variable to store the impedance data in the program
    global fnames;  % Variable to store the filenames for excel readability
       
    % Check if the user had selected one menu_file (char), or more than one (cell)
    if ~iscell(fileName) % only one file was selected by the user
        fullfname = char(fullfile(filePath,fileName));  % calculate full fname
        data{1} = GamryRead(fullfname); % open file and extract FREQ,REAL,IMAG
        fnames{1} = fileName;
        set(handles.txt_datafilecount,'string','1 data file loaded');   % display info in main GUI
    else % more than one file was selected by the user
        for idx=1:length(fileName)
            fullfname = char(fullfile(filePath,fileName(idx)));  % calculate full fname
            data{idx} = GamryRead(fullfname); % open file and extract FREQ,REAL,IMAG
            fnames{idx} = cellstr(fileName(idx));
            set(handles.txt_datafilecount,'string',strcat(num2str(length(fnames)),' data files loaded')); % display info in main GUI
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


set(hObject,'String',{'Zfit (fminsearch)','[ToDo] Levenberg-Marquardt','[ToDo] Nelder-Mead','[ToDo] BFGS','[ToDo] Powell'});


% CALLBACK: btn_fit_Callback ==============================================
function btn_fit_Callback(hObject, eventdata, handles)
global data;        % input files loaded to the program
global fnames;      % index of the file names
global results;     % output results obtained after the fitting
global filenames;   % formatted output filenames to be saved

if isempty(data)
    disp('Error: there is NO input data selected yet. Add some files first!');
    return;
end

% Read configuration parameters from the edit boxes -----------------------
    %  comment: eval is required to parse the strings and get the arrays!
circuit = get(handles.edit_circuit,'String'); % equivalent circuit to be fitted
initparams = eval(get(handles.edit_initparams,'String')); % initial values for the circuit elemts
indexes = [];       % empty = all input data is used (OR use custom ranges)
fitstring = 'fitNP'; % 'fitNP' non-proportional, OR '' proportional
LB = eval(get(handles.edit_LB,'String'));  % lower boundary for all parameters
UB = eval(get(handles.edit_UB,'String'));  % upper boundary for all parameters
plotstr = '';   % '' for silent computation

% ToDo: Check formatting of text boxes, error handling
if isempty(circuit) disp('Error: Circuit string is empty'); end
if isempty(initparams) fprintf('Error: Init Params string is empty'); end
if isempty(LB) fprintf('Error: Lower Bounds string is empty'); end
if isempty(UB) fprintf('Error: Upper Bounds string is empty'); end

% initializing variables for speed optimization!
results = cell(length(data{1}),length(initparams)); % preallocating for speed
filenames = cell(length(data{1}),1);    % preallocating for speed

% perform the fitting
disp('Info: Starting fitting process... -please wait-');
h = waitbar(0,'Performing fitting...');

    for idx = 1:length(data)
        % ToDo: select the algorithm depending on the drop-down list!
        [params,zbest] = Zfit(data{idx},plotstr,circuit,initparams,indexes,fitstring,LB,UB);
        results(idx,:) = num2cell(params);
        filenames(idx,1) = fnames{idx};
        waitbar(idx / length(data));
    end
close(h);

filenames

disp('Info: Fitting completed successfully');

% ToDo: plot the results, display the statistics! 




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



function edit_circuit_Callback(hObject, eventdata, handles)
% hObject    handle to edit_circuit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_circuit as text
%        str2double(get(hObject,'String')) returns contents of edit_circuit as a double


% --- Executes during object creation, after setting all properties.
function edit_circuit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_circuit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in btn_saveas.
function btn_saveas_Callback(hObject, eventdata, handles)
global filenames;
global results;

if isempty(results) 
    disp('Error: there is NO output data to be saved yet. Fit some data first!');
    return;
end

[outFileName,outPathName] = uiputfile({'*.xls','Excel Spreadsheet (*.xls)'});
disp('Info: Saving the results -please wait-');
outfullfname = fullfile(outPathName,outFileName);
xlswrite(outfullfname, [filenames results]);
disp('Info: Results saved successfully!');

function edit_initparams_Callback(hObject, eventdata, handles)
% hObject    handle to edit_initparams (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_initparams as text
%        str2double(get(hObject,'String')) returns contents of edit_initparams as a double


% --- Executes during object creation, after setting all properties.
function edit_initparams_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_initparams (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_LB_Callback(hObject, eventdata, handles)
% hObject    handle to edit_LB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_LB as text
%        str2double(get(hObject,'String')) returns contents of edit_LB as a double


% --- Executes during object creation, after setting all properties.
function edit_LB_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_LB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_UB_Callback(hObject, eventdata, handles)
% hObject    handle to edit_UB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_UB as text
%        str2double(get(hObject,'String')) returns contents of edit_UB as a double


% --- Executes during object creation, after setting all properties.
function edit_UB_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_UB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
function menu_file_Callback(hObject, eventdata, handles)
% hObject    handle to menu_file (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function circuits_menu_Callback(hObject, eventdata, handles)
% hObject    handle to circuits_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function menu_fitting_Callback(hObject, eventdata, handles)
% hObject    handle to menu_fitting (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function menu_about_Callback(hObject, eventdata, handles)
% hObject    handle to menu_about (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function file_adddata_Callback(hObject, eventdata, handles)
% hObject    handle to file_adddata (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
