function varargout = eistoolbox(varargin)
% Toolbox to fit Electrochemical Impedance Spectroscopy data to circuit models
% eistoolbox -by Juan J. Montero-Rodriguez
% 
% Quick start guide:
% 1. Click the "Add files..." button to load some CSV or DTA files
% 2. Write a circuit model using the format from Zfit (or load a predefined one)
% 3. Select the desired algorithm and weighting type to perform the fitting
% 4. Click the "Fit" button to perform the computations
% 5. Save the results to a .xls file to store the fitted parameters!
%

%% GUI Functions (specific to GUIDE)
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
% Choose default command line output for eistoolbox
handles.output = hObject;

% Add all subfolders to path! eistoolbox needs access to all subfolders
p = mfilename('fullpath');  % get the path of the current script
fp = genpath(fileparts(p));    % get all the subdirectories in this folder
addpath(fp);    % add all subfolders to current path

% Update handles structure
guidata(hObject, handles);

function varargout = eistoolbox_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;  % output handles to command line

function eismain_CreateFcn(hObject, eventdata, handles)

function eismain_CloseRequestFcn(hObject, eventdata, handles)
% ToDo: close all open figures
delete(hObject);    % closes the toolbox

%% CALLBACKS
% POPUP MENUS -------------------------------------------------------------
function algorithmmenu_Callback(hObject, eventdata, handles)

function algorithmmenu_CreateFcn(hObject, eventdata, handles)
% Set here the labels for the algorithms
set(hObject,'String',{ ...
    'Nelder-Mead (default)', ...        % option 1 : fminsearchcon()    Nelder-Mead 
    'Genetic Algorithm', ...            % option 2 : ga()               Genetic Algorithm
    'Simulated Annealing', ...          % option 3 : simulannealbnd()   Simulated Annealing
    'Constrained minimization', ...     % option 4 : fmincon()          Constrained minimization
    'iFit - fminlm' ...
    });

function weightingmenu_Callback(hObject, eventdata, handles)

function weightingmenu_CreateFcn(hObject, eventdata, handles)
% Set here the labels for the weighting functions
set(hObject,'String',{ ...
    'Proportional', ...
    'Unit', ...
    'Modulus'
    });

% EDIT BOXES --------------------------------------------------------------
function edit_circuit_Callback(hObject, eventdata, handles)

function edit_circuit_CreateFcn(hObject, eventdata, handles)

function edit_initparams_Callback(hObject, eventdata, handles)

function edit_initparams_CreateFcn(hObject, eventdata, handles)

function edit_LB_Callback(hObject, eventdata, handles)

function edit_LB_CreateFcn(hObject, eventdata, handles)

function edit_UB_Callback(hObject, eventdata, handles)

function edit_UB_CreateFcn(hObject, eventdata, handles)

function edit_iterations_Callback(hObject, eventdata, handles)

function edit_iterations_CreateFcn(hObject, eventdata, handles)

function ncores_Callback(hObject, eventdata, handles)

function ncores_CreateFcn(hObject, eventdata, handles)


% BUTTONS -----------------------------------------------------------------
function btn_addfiles_Callback(hObject, eventdata, handles)
addfiles(hObject, eventdata, handles);

function btn_loadcirc_Callback(hObject, eventdata, handles)
loadckt(hObject, eventdata, handles);

function btn_fit_Callback(hObject, eventdata, handles)
run_fitting(hObject, eventdata, handles);

function btn_savecirc_Callback(hObject, eventdata, handles)
saveckt(hObject, eventdata, handles)

function btn_saveas_Callback(hObject, eventdata, handles)
save_results(hObject, eventdata, handles);

function btn_nyq_Callback(hObject, eventdata, handles)
plotnyq(hObject, eventdata, handles);

function btn_bod_Callback(hObject, eventdata, handles)
plotbod(hObject, eventdata, handles);

function btn_nyq2_Callback(hObject, eventdata, handles)
plotnyq2(hObject, eventdata, handles);

function btn_bod2_Callback(hObject, eventdata, handles)
plotbod2(hObject, eventdata, handles);

function btn_reim1_Callback(hObject, eventdata, handles)
plotreim1(hObject, eventdata, handles);

function btn_reim2_Callback(hObject, eventdata, handles)
plotreim2(hObject, eventdata, handles);

function btn_simulatecirc_Callback(hObject, eventdata, handles)
simcircuit(hObject, eventdata, handles);

function btn_exportfitted_Callback(hObject, eventdata, handles)
data = getappdata(handles.eismain,'data');
zbest = getappdata(handles.eismain,'zbest');

if isempty(data) 
    disp('Error: there is NO input data to be saved yet. Add some files first!');
    return;
end

if isempty(zbest) 
    disp('Error: there is NO output data to be saved yet. Fit some data first!');
    return;
end

% ask for a folder
filePath = uigetdir();
if isequal(filePath,0)
   disp('Info: No folder was selected');
   return;  % terminate the callback here
end

% export all fitted curves to the selected folder 
% (as CSV with FREQ,ZREAL,ZIMAG)
for idx=1:length(zbest)
    csvwrite([filePath '/Fitted_' num2str(idx) '.csv'],[data{1}(:,1) zbest{idx}]);
end

function save1_Callback(hObject, eventdata, handles)
[fileName,filePath] = uiputfile({'*.pdf','PDF file (*.pdf)'; 
    '*.png','Portable Networks Graphic (*.png)';
    '*.jpg','JPEG (*.jpg)'});
if isequal(fileName,0)
   disp('Info: No file was selected');
   return;  % terminate the callback here
end

fullfname = fullfile(filePath,fileName);
%ToDo: check if Figure 1 exists, if not, show a message
ch = figure(1);
export_fig(ch, fullfname);


function save2_Callback(hObject, eventdata, handles)
[fileName,filePath] = uiputfile({'*.pdf','PDF file (*.pdf)'});
if isequal(fileName,0)
   disp('Info: No file was selected');
   return;  % terminate the callback here
end

fullfname = fullfile(filePath,fileName);
%ToDo: check if Figure 2 exists, if not, show a message
ch = figure(2);
export_fig(ch, fullfname);

% MENUS -------------------------------------------------------------------
function menu_file_Callback(hObject, eventdata, handles)

function circuits_menu_Callback(hObject, eventdata, handles)

function menu_fitting_Callback(hObject, eventdata, handles)

function menu_about_Callback(hObject, eventdata, handles)

function menu_addfiles_Callback(hObject, eventdata, handles)
addfiles(hObject, eventdata, handles);

function menu_loadckt_Callback(hObject, eventdata, handles)
loadckt(hObject, eventdata, handles);

function menu_saveckt_Callback(hObject, eventdata, handles)
saveckt(hObject, eventdata, handles);

function menu_fit_Callback(hObject, eventdata, handles)
run_fitting(hObject, eventdata, handles);

function menu_saveresults_Callback(hObject, eventdata, handles)
save_results(hObject, eventdata, handles);

function menu_aboutdialog_Callback(hObject, eventdata, handles)
menu_about();

function menu_operations_Callback(hObject, eventdata, handles)

function menu_remove_higherthan_Callback(hObject, eventdata, handles)
[maxReal, maxImag] = removehigherthan;
remove_higherthan(hObject, eventdata, handles, maxReal, maxImag);

function menu_remove_lastN_Callback(hObject, eventdata, handles)
Npoints = removelastN();    % opens the GUI and asks for N
    % if N=-1 then user cancelled the operation
    % else perform the removal
    if Npoints>0
        remove_lastN(hObject, eventdata, handles, Npoints);
    end

function plot_singlefreq_Callback(hObject, eventdata, handles)
desiredfreq = plotsinglefreq();
% ToDo: interpolate to find the desired frequency
% Right now we plot the closest frequency to the one entered

data = getappdata(handles.eismain,'data');

diffs=(data{1}(:,1)-desiredfreq);       % Subtract the desired freq from the frequencies column
absdiffs= abs(diffs);                   % Get the absoulte value of differences
[closestval,closestindex] = min(diffs);     % The closest value is found with the command 'min'

disp(strcat('Info: User entered a desired frequency of: ',string(desiredfreq),'Hz'));
disp(strcat('Info: Plotting at the closest frequency: ',string(closestval),'Hz'));

% Here we assemble the data we are going to plot
for idx=1:1:length(data)
    indexnumber(idx)=idx;
    %frequency(idx)=data{idx}(closestindex,1);
    realvalue(idx)=data{idx}(closestindex,2);
    imagvalue(idx)=data{idx}(closestindex,3);
end

f5 = figure(5);
set(f5,'Name','Plot at specific frequency - Real');
clf;  % Clears any old information already present in the diagram
plot(indexnumber,realvalue);
grid on;
xlabel('File index number (N)');
ylabel('Real part of Impedance (Ohm)');

f6 = figure(6);
set(f6,'Name','Plot at specific frequency - Imag');
clf;  % Clears any old information already present in the diagram
plot(indexnumber,imagvalue);
grid on;
xlabel('File index number (N)');
ylabel('Imag part of Impedance (Ohm)');

f7 = figure(7);
set(f7,'Name','Plot at specific frequency - Magnitude');
clf;  % Clears any old information already present in the diagram
semilogy(indexnumber,sqrt(realvalue.^2 + imagvalue.^2));
grid on;
xlabel('File index number (N)');
ylabel('Magnitude of Impedance (Ohm)');

f8 = figure(8);
set(f8,'Name','Plot at specific frequency - Phase');
clf;  % Clears any old information already present in the diagram
plot(indexnumber,(180/pi)*atan(imagvalue./realvalue));
grid on;
xlabel('File index number (N)');
ylabel('Phase of Impedance (deg)');


%% INTERNAL FUNCTIONS
function addfiles(hObject, eventdata, handles)

    % Ask for data: Open the menu_file dialog 'uigetfile' with Multiselect 'on'
    [fileName, filePath] = uigetfile( ...
        {'*.csv;*.dta','Supported Files (*.csv, *.dta)';  % File type definition: supported
        '*.csv','CSV Data Files (*.csv)';   % File type definition: CSV
        '*.dta','Gamry Data Files (*.dta)'; % File type definition: Gamry
         '*.*','All Files (*.*)'}, ...      % File type definition: others
       'Select the impedance files','Multiselect','on');

   % What happens if no file was selected? (i.e. cancel button)
   if isequal(fileName,0)
       disp('Info: No file was selected');
       return;  % terminate the callback here
   end
   
   disp('Info: Loading input data files -please wait-');
    
    set(handles.txt_savestatus,'string','Input data loaded');
    set(handles.txt_datafilecount,'string','0 data files loaded');
   
    h = waitbar(0,'Loading input data files... please wait');
    
    % Check if the user had selected one menu_file (char), or more than one (cell)
    if ~iscell(fileName) % only one file was selected by the user
        fullfname = char(fullfile(filePath,fileName));  % calculate full fname
        %switch file type: if dta, gamryread; if csv, csvread
        [path,name,ext] = fileparts(fullfname);
        switch upper(ext)   % convert extension to uppercase
            case '.DTA'
                data{1} = GamryRead(fullfname);
            case '.CSV'
                data{1} = csvread(fullfname);
            otherwise
                disp('Warning: other file types not currently supported');
        end
        fnames{1} = fileName;
        set(handles.txt_datafilecount,'string','1 data file loaded');   % display info in main GUI
    else % more than one file was selected by the user
        for idx=1:length(fileName)
            fullfname = char(fullfile(filePath,fileName(idx)));  % calculate full fname
                    %switch file type: if dta, gamryread; if csv, csvread
        [path,name,ext] = fileparts(fullfname);
        switch upper(ext)   % convert extension to uppercase
            case '.DTA'
                data{idx} = GamryRead(fullfname); % open file and extract FREQ,REAL,IMAG
            case '.CSV'
                data{idx} = csvread(fullfname); % directly read FREQ,REAL,IMAG
            otherwise
                disp('Warning: other file types not currently supported');
        end
            fnames(idx,1) = cellstr(fileName(idx));
            set(handles.txt_datafilecount,'string',strcat(num2str(length(fnames)),' data files loaded')); % display info in main GUI
            waitbar(idx / length(fileName));
        end
    end

    close(h);
    
    disp('Info: Input data files succesfully loaded');
    setappdata(handles.eismain,'data',data);
    setappdata(handles.eismain,'fnames',fnames);
    
    plotnyq(hObject, eventdata, handles);

    
function remove_higherthan(hObject, eventdata, handles, value1, value2)
    
    data =  getappdata(handles.eismain,'data');
    
    for idx=1:1:length(data)
        c=1;
        for idx2=1:1:length(data{idx})
            if (data{idx}(idx2,2) < value1) && (data{idx}(idx2,3) < value2)
                tmpdata{idx}(c,:)=data{idx}(idx2,:);
                c = c+1;
            end
        end
    end
    
    data=tmpdata;
    setappdata(handles.eismain,'data',data);

function remove_lastN(hObject, eventdata, handles, N)
    
    data =  getappdata(handles.eismain,'data');
    
    for idx=1:1:length(data)
        for idx2=1:1:(length(data{idx})-N)
            tmpdata{idx}(idx2,:)=data{idx}(idx2,:);
        end
    end
    
    data=tmpdata;
    setappdata(handles.eismain,'data',data);

function plotnyq(hObject, eventdata, handles)
% plots input data as Nyquist
    data=getappdata(handles.eismain,'data');

    if isempty(data)
        disp('Error: there is NO input data selected yet. Add some files first!');
        set(handles.txt_savestatus,'string','Error: NO input data');
        return;
    end
    
    disp('Info: Plotting Nyquist response of input data files');

    % Now we plot all the acquired data from the files
    f1 = figure(1);
    set(f1,'Name','Measured Data');
    clf;  % Clears any old information already present in the diagram
    set(gca,'FontSize',7);
    set(gca,'xscale','linear');    % change x axis to linear
    hold on;
    grid on;

    cm=colormap(hsv(length(data))); % define a colormap
    for idx=1:length(data)
        plot(data{idx}(:,2),abs(data{idx}(:,3)),...
            'color',0.8*cm(idx,:),...
            'marker','.',...
            'markersize',5);
    end
    axis tight; % adjusts axis limits to the data already loaded
    title('Nyquist plot');
    xlabel('Impedance Real [\Omega]');
    ylabel('Impedance Imag [\Omega]');
    disp('Info: Input data files succesfully plotted');
    
function plotbod(hObject, eventdata, handles)
% plots input data as Bode
    data=getappdata(handles.eismain,'data');

    if isempty(data)
        disp('Error: there is NO input data selected yet. Add some files first!');
        set(handles.txt_savestatus,'string','Error: NO input data');
        return;
    end
    
    disp('Info: Plotting Bode response of input data files');

    % Now we plot all the acquired data from the files
    f1 = figure(1);
    set(f1,'Name','Measured Data');
    clf;  % Clears any old information already present in the diagram
    
    cm=colormap(hsv(length(data))); % define a colormap
    for idx=1:length(data)
        ax(1) = subplot(2,1,1);
        loglog(data{idx}(:,1),sqrt(data{idx}(:,2).^2 + abs(data{idx}(:,3)).^2 ),...
            'LineStyle','-','Marker','.','MarkerSize',5,'Color',0.8*cm(idx,:)); % magnitude
        hold on;
        grid on;
        title('Magnitude');
        xlabel('Frequency [Hz]');
        ylabel('Impedance [\Omega]');
        ax(2) = subplot(2,1,2);
        semilogx(data{idx}(:,1),atan(data{idx}(:,3) ./ data{idx}(:,2))*180/pi,...
            'LineStyle','-','Marker','x','MarkerSize',3,'Color',0.8*cm(idx,:)); %phase
        hold on;
        grid on;
        title('Phase');
        xlabel('Frequency [Hz]');
        ylabel('Phase [Degrees]');
        set(ax(1),'FontSize',7);
        set(ax(2),'FontSize',7);
    end
    
    axis(ax(1),'tight');    % rescale axis to fit data
    axis(ax(2),'tight');
    
    disp('Info: Input data files succesfully plotted');
    set(handles.txt_savestatus,'string','Input data plotted');

function plotnyq2(hObject, eventdata, handles)
% plots input data as Nyquist
    zbest=getappdata(handles.eismain,'zbest');

    if isempty(zbest)
        set(handles.txt_savestatus,'string','Error: NO fitted data');
        disp('Error: there is NO fitted data selected yet. Fit some data first!');
        return;
    end
    
    disp('Info: Plotting Nyquist response of fitted data');

    % Display results from zbest in second plot
    f2 = figure(2);
    set(f2,'Name','Fitted Data');
    clf;  % Clears any old information already present in the diagram
    set(gca,'FontSize',7);
    set(gca,'xscale','linear');    % change x axis to linear
    hold on;
    grid on;
    
    cm=colormap(hsv(length(zbest))); % define a colormap
    for idx=1:length(zbest)
        plot(zbest{idx}(:,1),abs(zbest{idx}(:,2)),...
            'color',0.8*cm(idx,:),...
            'marker','.',...
            'markersize',5);
    end
    axis tight; % adjusts axis limits to the data already loaded
    title('Nyquist plot');
    xlabel('Impedance Real [\Omega]');
    ylabel('Impedance Imag [\Omega]');
    disp('Info: Fitted data succesfully plotted');

function plotbod2(hObject, eventdata, handles)
% plots input data as Bode
    zbest=getappdata(handles.eismain,'zbest');  % fitting 
    data= getappdata(handles.eismain,'data');   % frequencies

    if isempty(zbest)
        set(handles.txt_savestatus,'string','Error: NO fitted data');
        disp('Error: there is NO fitted data selected yet. Fit some data first!');
        return;
    end
    
    disp('Info: Plotting Bode response of fitted data');

    % Display results from zbest in second plot
    f2 = figure(2);
    set(f2,'Name','Fitted Data');
    clf;  % Clears any old information already present in the diagram
    
    cm=colormap(hsv(length(data))); % define a colormap
    for idx=1:length(data)
        ax(1) = subplot(2,1,1);
        loglog(data{idx}(:,1),sqrt(zbest{idx}(:,1).^2 + abs(zbest{idx}(:,2)).^2 ),...
            'LineStyle','-','Marker','.','MarkerSize',5,'Color',0.8*cm(idx,:)); % magnitude
        hold on;
        grid on;
        title('Magnitude');
        xlabel('Frequency [Hz]');
        ylabel('Impedance [\Omega]');
        ax(2) = subplot(2,1,2);
        semilogx(data{idx}(:,1),atan(zbest{idx}(:,2) ./ zbest{idx}(:,1))*180/pi,...
            'LineStyle','-','Marker','x','MarkerSize',3,'Color',0.8*cm(idx,:)); %phase
        hold on;
        grid on;
        title('Phase');
        xlabel('Frequency [Hz]');
        ylabel('Phase [Degrees]');
        set(ax(1),'FontSize',7);
        set(ax(2),'FontSize',7);
    end
    
    axis(ax(1),'tight');    % rescale axis to fit data
    axis(ax(2),'tight');
    
    disp('Info: Fitted data succesfully plotted');
    

function plotreim1(hObject, eventdata, handles)
    data= getappdata(handles.eismain,'data');   % measured data
    
    if isempty(data)
        set(handles.txt_savestatus,'string','Error: NO fitted data');
        disp('Error: there is NO input data selected yet. Add some data first!');
        return;
    end
    
    disp('Info: Plotting Bode response of input data files');

    % Now we plot all the acquired data from the files
    f1 = figure(1);
    set(f1,'Name','Measured Data');
    clf;  % Clears any old information already present in the diagram
    
    cm=colormap(hsv(length(data))); % define a colormap
    for idx=1:length(data)
        ax(1) = subplot(2,1,1);
        loglog(data{idx}(:,1),data{idx}(:,2),...
            'LineStyle','-','Marker','.','MarkerSize',5,'Color',0.8*cm(idx,:)); %real
        hold on;
        grid on;
        title('Real');
        xlabel('Frequency [Hz]');
        ylabel('Impedance real [\Omega]');
        ax(2) = subplot(2,1,2);
        loglog(data{idx}(:,1),abs(data{idx}(:,3)),...
            'LineStyle','-','Marker','o','MarkerSize',3,'Color',0.8*cm(idx,:))% imag
        hold on;
        grid on;
        title('Imaginary');
        xlabel('Frequency [Hz]');
        ylabel('Impedance imag [\Omega]');
    end

    set(ax(1),'FontSize',7);
    set(ax(2),'FontSize',7);
    axis(ax(1),'tight');    % rescale axis to fit data
    axis(ax(2),'tight');    % rescale axis to fit data
    disp('Info: Input data files succesfully plotted');
    
function plotreim2(hObject, eventdata, handles)
    zbest=getappdata(handles.eismain,'zbest');  % fitting data
    data= getappdata(handles.eismain,'data');   % frequencies
    
    if isempty(zbest)
        set(handles.txt_savestatus,'string','Error: NO fitted data');
        disp('Error: there is NO fitted data selected yet. Fit some data first!');
        return;
    end
    
    disp('Info: Plotting Bode response of fitted data');

    % Display results from zbest in second plot
    f2 = figure(2);
    set(f2,'Name','Fitted Data');
    clf;  % Clears any old information already present in the diagram
    clf;  % Clears any old information already present in the diagram
    
    cm=colormap(hsv(length(data))); % define a colormap
    for idx=1:length(data)
        ax(1) = subplot(2,1,1);
        loglog(data{idx}(:,1),zbest{idx}(:,1),...
            'LineStyle','-','Marker','.','MarkerSize',5,'Color',0.8*cm(idx,:)); %real
        hold on;
        grid on;
        title('Real');
        xlabel('Frequency [Hz]');
        ylabel('Impedance real [\Omega]');
        ax(2) = subplot(2,1,2);
        loglog(data{idx}(:,1),abs(zbest{idx}(:,2)),...
            'LineStyle','-','Marker','o','MarkerSize',3,'Color',0.8*cm(idx,:))% imag
        hold on;
        grid on;
        title('Imaginary');
        xlabel('Frequency [Hz]');
        ylabel('Impedance imag [\Omega]');
    end

    set(ax(1),'FontSize',7);
    set(ax(2),'FontSize',7);
    axis(ax(1),'tight');    % rescale axis to fit data
    axis(ax(2),'tight');    % rescale axis to fit data
    disp('Info: Fitted data succesfully plotted');
    
function loadckt(hObject, eventdata, handles)
[fileName, filePath] = uigetfile( ...
    {'*.ckt','Circuit files (*.ckt)';       % File type definition: CKT
         '*.*','All Files (*.*)'}, ...      % File type definition: others
   'Select the circuit file','Multiselect','off');

% What happens if no file was selected? (i.e. cancel button)
if isequal(fileName,0)
    set(handles.txt_savestatus,'string','Error: NO file selected');
   disp('Info: No file was selected');
   return;  % terminate the callback here
end

fullfname = fullfile(filePath,fileName);
fid = fopen(fullfname);

line1 = fgetl(fid);   % first line: fitting string
line2 = fgetl(fid);   % second line: initial parameters
line3 = fgetl(fid);   % third line: lower boundary conditions
line4 = fgetl(fid);   % fourth line: upper boundary conditions

set(handles.edit_circuit,'String',line1);
set(handles.edit_initparams,'String',line2);
set(handles.edit_LB,'String',line3);
set(handles.edit_UB,'String',line4);

fclose(fid);

function saveckt(hObject, eventdata, handles)
[fileName, filePath] = uiputfile( ...
    {'*.ckt','Circuit files (*.ckt)';       % File type definition: CKT
         '*.*','All Files (*.*)'}, ...      % File type definition: others
   'Select the circuit file');

% What happens if no file was selected? (i.e. cancel button)
if isequal(fileName,0)
    set(handles.txt_savestatus,'string','Error: NO file selected');
   disp('Info: No file was selected');
   return;  % terminate the callback here
end

fullfname = fullfile(filePath,fileName);

fid = fopen(fullfname,'w');

line1 = get(handles.edit_circuit,'String');
line2 = get(handles.edit_initparams,'String');
line3 = get(handles.edit_LB,'String');
line4 = get(handles.edit_UB,'String');

fprintf(fid,strcat(line1,'\n'));   % first line: fitting string
fprintf(fid,strcat(line2,'\n'));   % second line: initial parameters
fprintf(fid,strcat(line3,'\n'));   % third line: lower boundary conditions
fprintf(fid,strcat(line4,'\n'));   % fourth line: upper boundary conditions

fclose(fid);

function simcircuit(hObject, eventdata, handles)
data = getappdata(handles.eismain,'data');        % input files loaded to the program

if isempty(data)
    set(handles.txt_savestatus,'string','Error: Missing input file with freq');
    disp('Error: You need to load at least one data file (with the frequencies for simulation in the first column). Add some files first!');
    return;
end
% Read configuration parameters from the edit boxes -----------------------
% comment: eval is required to parse the strings and get the arrays!
circuitstring = get(handles.edit_circuit,'String'); % equivalent circuit to be fitted
initparams = eval(get(handles.edit_initparams,'String')); % initial values for the circuit elemts

% Check formatting of text boxes, error handling
if isempty(circuitstring); disp('Error: Circuit string is empty'); return; end
if isempty(initparams); fprintf('Error: Init Params string is empty'); return; end

zsim = computecircuit(initparams,circuitstring,data{1}(:,1));

f4 = figure(4);
set(f4,'Name','Simulated Data');

ax(1) = subplot(2,1,1);
loglog(data{1}(:,1),zsim(:,1),'color','black');
title('Simulated Magnitude');
xlabel('Frequency [Hz]');
ylabel('Impedance [\Omega]');
grid on;
ax(2) = subplot(2,1,2);
semilogx(data{1}(:,1),zsim(:,2),'color','black');
title('Simulated Phase');
xlabel('Frequency [Hz]');
ylabel('Phase [degrees]');
grid on;

set(ax(1),'FontSize',7);
set(ax(2),'FontSize',7);
axis(ax(1),'tight');    % rescale axis to fit data
axis(ax(2),'tight');    % rescale axis to fit data



function run_fitting(hObject, eventdata, handles)
data = getappdata(handles.eismain,'data');        % input files loaded to the program
fnames = getappdata(handles.eismain,'fnames');    % index of the file names

if isempty(data)
    set(handles.txt_savestatus,'string','Error: NO input data');
    disp('Error: there is NO input data selected yet. Add some files first!');
    return;
end

% Read configuration parameters from the edit boxes -----------------------
% comment: eval is required to parse the strings and get the arrays!
circuit = get(handles.edit_circuit,'String'); % equivalent circuit to be fitted
initparams = eval(get(handles.edit_initparams,'String')); % initial values for the circuit elemts
setappdata(handles.eismain,'initparams',initparams);    % store them for later use on calculate_correlations.m

LB = eval(get(handles.edit_LB,'String'));  % lower boundary for all parameters
UB = eval(get(handles.edit_UB,'String'));  % upper boundary for all parameters

% Check formatting of text boxes, error handling
if isempty(circuit) disp('Error: Circuit string is empty'); return; end
if isempty(initparams) fprintf('Error: Init Params string is empty'); return; end
if isempty(LB) fprintf('Error: Lower Bounds string is empty'); return; end
if isempty(UB) fprintf('Error: Upper Bounds string is empty'); return; end

% Check if the dimensions are consistent
if length(initparams) ~= length(LB); disp(strcat('Error: check dimensions of init params (',int2str(length(initparams)),') OR lower boundaries (',int2str(length(LB)),')')); return; end
if length(initparams) ~= length(UB); disp(strcat('Error: check dimensions of init params (',int2str(length(initparams)),') OR upper boundaries (',int2str(length(UB)),')')); return; end

% perform the fitting
tic();
%disp(datestr(clock));
disp('Info: Starting fitting process... -please wait-');
set(handles.txt_savestatus,'string','-FITTING- please wait');
h = waitbar(0,'Performing fitting... please wait');

% initializing variables for speed optimization!
results = cell(length(data),length(initparams)); % preallocating for speed

% check the selected algorithm, weighting and max iterations
algorithm = get(handles.algorithmmenu,'Value');
weighting = get(handles.weightingmenu,'Value');
maxiter = str2double( get(handles.edit_iterations,'String') );
ncores = str2double( get(handles.ncores,'String'));

if ncores == 1
    for idx = 1:length(data)
        % First we do the fitting!
        [params,zbest{idx}] = fitting_engine(data{idx},circuit,initparams,LB,UB,algorithm,weighting,maxiter);
        
        % Calculation of the error estimates of individual parameters
        % ToDo... this depends on the algorithms

        % Copy here the results to the global var (for exporting them later)
        results(idx,:) = num2cell(params);
        
        % Update the waitbar with the next sample!
        wtext = strjoin( ['Fitting ',int2str(idx),' of ',int2str(length(data)),' | File: ',strrep(fnames(idx),'_','\_')] , '' );
        waitbar(idx / length(data), h, wtext);
    end
    close(h);
else
    pool = parpool(ncores);
    parfor idx = 1:length(data)
        % First we do the fitting!
        [params,zbest{idx}] = fitting_engine(data{idx},circuit,initparams,LB,UB,algorithm,weighting,maxiter);
        
        % Calculation of the error estimates of individual parameters
        % ToDo... this depends on the algorithms

        % Copy here the results to the global var (for exporting them later)
        results(idx,:) = num2cell(params);
        
        % Update the waitbar with the next sample!
        % ToDo: this does not work with parfor!!
        %wtext = strjoin( ['Fitting ',int2str(idx),' of ',int2str(length(data)),' | File: ',strrep(fnames(idx),'_','\_')] , '' );
        %waitbar(idx / length(data), h, wtext);
    end
    close(h);
    delete(pool);
end

setappdata(handles.eismain,'results',results);
setappdata(handles.eismain,'zbest',zbest);

disp('Info: Fitting completed successfully');
fittime = toc();

set(handles.txt_savestatus,'string','Fitting results ready, please save');
set(handles.txt_savestatus,'string',['Fit done. Time: ' num2str(fittime) ' seconds.']);


plotnyq2(hObject, eventdata, handles);  % plot nyquist in second axes

% Display a table with the fitting results in a new figure
fres = figure(3);
set(fres,'Name',['Fitting Results for circuit Z = ',circuit]);
cnames = cell(1,size(results,2)+1); % width = number of parameters + 1
for idx=1:length(cnames)
    if idx==1
        cnames{idx}='Filename';
    else
        cnames{idx}=strcat('Param',int2str(idx-1));
    end
end

setappdata(handles.eismain,'param_cnames',cnames);


t = uitable(fres,'data',[fnames results],'ColumnWidth',{80},'ColumnName',cnames);
set(t,'Position',[ 0 0 800 600]);
fig = gcf;

% Adjust the size to match the table
fig.Position = [20 100 800 600];
set(fig,'Resize','off');

% Calculate the goodness of fit and overall correlations
calculate_correlations(hObject, eventdata, handles);

function save_results(hObject, eventdata, handles)
fnames = getappdata(handles.eismain,'fnames');
results = getappdata(handles.eismain,'results');
corr_values = getappdata(handles.eismain,'corr_values');
corr_cnames = getappdata(handles.eismain,'corr_cnames');
param_cnames = getappdata(handles.eismain,'param_cnames');

if isempty(results) 
    disp('Error: there is NO output data to be saved yet. Fit some data first!');
    return;
end

[outFileName,outPathName] = uiputfile({'*.xls','Excel Spreadsheet (*.xls)';
                                       '*.csv','Comma separated values (*.csv)'});
if isequal(outFileName,0)
   disp('Info: No file was selected');
   return;  % terminate the callback here
end

h = waitbar(0,'Saving data... please wait');

disp('Info: Saving the results -please wait-');
set(handles.txt_savestatus,'string','-SAVING- please wait');

outfullfname = char(fullfile(outPathName,outFileName));
[path,name,ext] = fileparts(outfullfname);
switch upper(ext)   % convert extension to uppercase
    case '.XLS'
        xlswrite(outfullfname, [param_cnames corr_cnames ; fnames results corr_values]);
    case '.CSV'
        T = table([param_cnames corr_cnames ; fnames results corr_values]);
        writetable(T,outfullfname);
    otherwise
        disp('Warning: other file types not currently supported');
end

disp('Info: Results saved successfully!');
set(handles.txt_savestatus,'string','Results saved as XLS');
waitbar(1);
close(h);


%% LICENSE INFORMATION
% Copyright (C) 2016  Juan J. Montero-Rodriguez
% 
%     This program is free software: you can redistribute it and/or modify
%     it under the terms of the GNU General Public License as published by
%     the Free Software Foundation, in the version 3.
% 
%     This program is distributed in the hope that it will be useful,
%     but WITHOUT ANY WARRANTY; without even the implied warranty of
%     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%     GNU General Public License for more details.
% 
%     You should have received a copy of the GNU General Public License
%     along with this program.  If not, see <http://www.gnu.org/licenses/>.


