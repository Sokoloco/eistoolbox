function varargout = eistoolbox(varargin)
% Toolbox to fit Electrochemical Impedance Spectroscopy data to circuit models
% eistoolbox -by Juan J. Montero-Rodriguez
% 
% Quick start guide:
% 1. Click the "Add files..." button to load some CSV or DTA files
% 2. Write a circuit model using the format from Zfit (or load a predefined one)
% 3. Select the desired algorithm to perform the fitting
% 4. Click the "Fit" button to perform the computations
% 5. Save the results to a .xls file to obtain the fitted parameters!
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
    'fminsearchbnd' ...    % option 1 : fminsearchbnd
    });

function weightingmenu_Callback(hObject, eventdata, handles)

function weightingmenu_CreateFcn(hObject, eventdata, handles)
% Set here the labels for the weighting functions
set(hObject,'String',{ ...
    'Proportional', ...
    'Unit', ...
    'Modulus'
    });

% AXES CREATION -----------------------------------------------------------
function axes1_CreateFcn(hObject, eventdata, handles)
grid on;

function axes2_CreateFcn(hObject, eventdata, handles)
grid on;

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
    
    set(handles.txt_savestatus,'string','No data to save');
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

function plotnyq(hObject, eventdata, handles)
% plots input data as Nyquist
    data=getappdata(handles.eismain,'data');

    if isempty(data)
        disp('Error: there is NO input data selected yet. Add some files first!');
        return;
    end
    
    disp('Info: Plotting Nyquist response of input data files');

    % Now we plot all the acquired data from the files
    axes(handles.axes1); % Select the axes 1 for plotting input data (Nyquist)
    cla reset;  % Clears any old information already present in the diagram
    set(gca,'FontSize',7);
    set(gca,'xscale','linear');    % change x axis to linear
    hold on;
    grid on;

    cm=colormap(hsv(length(data))); % define a colormap
    for idx=1:length(data)
        plot(data{idx}(:,2),abs(data{idx}(:,3)),...
            'color',0.8*cm(idx,:),...
            'marker','.',...
            'markersize',12);
    end

    disp('Info: Input data files succesfully plotted');
    
function plotbod(hObject, eventdata, handles)
% plots input data as Bode
    data=getappdata(handles.eismain,'data');

    if isempty(data)
        disp('Error: there is NO input data selected yet. Add some files first!');
        return;
    end
    
    disp('Info: Plotting Bode response of input data files');

    % Now we plot all the acquired data from the files
    axes(handles.axes1); % Select the axes 1 for plotting input data (Nyquist)
    cla;  % Clears any old information already present in the diagram
    set(gca,'xscale','log');    % change x axis to log
    hold on;
    
    cm=colormap(hsv(length(data))); % define a colormap
    for idx=1:length(data)
        [ax,hLine1,hLine2] = plotyy(data{idx}(:,1),sqrt(data{idx}(:,2).^2 + abs(data{idx}(:,3)).^2 ), ... %magnitude
            data{idx}(:,1),atan(data{idx}(:,2) ./ data{idx}(:,3))*180/pi, ... % phase
            'semilogx');
        set(ax(1),'FontSize',7,'YColor',[0 0 0.7]);
        set(ax(2),'FontSize',7,'YColor',[0.7 0 0]);
        hLine1.LineStyle = ':';
        hLine1.Marker = '.';
        hLine1.MarkerSize = 12;
        hLine1.Color = 0.8*cm(idx,:);
        hLine2.LineStyle = ':';
        hLine2.Marker = 'x';
        hLine2.MarkerSize = 5;
        hLine2.Color = 0.8*cm(idx,:);
        if idx > 1; set(ax(2),'YTick',[]); end % prevents marker overlapping
    end
    
    grid on;
    
    disp('Info: Input data files succesfully plotted');

function plotnyq2(hObject, eventdata, handles)
% plots input data as Nyquist
    zbest=getappdata(handles.eismain,'zbest');

    if isempty(zbest)
        disp('Error: there is NO fitted data selected yet. Fit some data first!');
        return;
    end
    
    disp('Info: Plotting Nyquist response of fitted data');

    % Display results from zbest in second plot
    axes(handles.axes2);
    cla reset;  % Clears any old information already present in the diagram
    set(gca,'FontSize',7);
    set(gca,'xscale','linear');    % change x axis to linear
    hold on;
    grid on;
    
    cm=colormap(hsv(length(zbest))); % define a colormap
    for idx=1:length(zbest)
        plot(zbest{idx}(:,1),abs(zbest{idx}(:,2)),...
            'color',0.8*cm(idx,:),...
            'marker','.',...
            'markersize',12);
    end
    
    disp('Info: Fitted data succesfully plotted');

function plotbod2(hObject, eventdata, handles)
% plots input data as Bode
    zbest=getappdata(handles.eismain,'zbest');  % fitting 
    data= getappdata(handles.eismain,'data');   % frequencies

    if isempty(zbest)
        disp('Error: there is NO fitted data selected yet. Fit some data first!');
        return;
    end
    
    disp('Info: Plotting Bode response of fitted data');

    % Display results from zbest in second plot
    axes(handles.axes2);
    cla reset;  % Clears any old information already present in the diagram
    set(gca,'xscale','log');    % change x axis to log
    hold on;
   
    cm=colormap(hsv(length(data))); % define a colormap
    for idx=1:length(data)
       [ax,hLine1,hLine2] =  plotyy(data{idx}(:,1),sqrt(zbest{idx}(:,1).^2 + abs(zbest{idx}(:,2)).^2 ), ... %magnitude
            data{idx}(:,1),atan(zbest{idx}(:,1) ./ zbest{idx}(:,2))*180/pi, ... % phase
            'semilogx'); 
        set(ax(1),'FontSize',7,'YColor',[0 0 0.7]);
        set(ax(2),'FontSize',7,'YColor',[0.7 0 0]);
        hLine1.LineStyle = ':';
        hLine1.Marker = '.';
        hLine1.MarkerSize = 12;
        hLine1.Color = 0.8*cm(idx,:);
        hLine2.LineStyle = ':';
        hLine2.Marker = 'x';
        hLine2.MarkerSize = 5;
        hLine2.Color = 0.8*cm(idx,:);
        if idx > 1; set(ax(2),'YTick',[]); end % prevents marker overlapping
    end

    grid on;
    
    disp('Info: Fitted data succesfully plotted');
    
function loadckt(hObject, eventdata, handles)
[fileName, filePath] = uigetfile( ...
    {'*.ckt','Circuit files (*.ckt)';       % File type definition: CKT
         '*.*','All Files (*.*)'}, ...      % File type definition: others
   'Select the circuit file','Multiselect','off');

% What happens if no file was selected? (i.e. cancel button)
if isequal(fileName,0)
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

function run_fitting(hObject, eventdata, handles)
data = getappdata(handles.eismain,'data');        % input files loaded to the program
fnames = getappdata(handles.eismain,'fnames');    % index of the file names

if isempty(data)
    disp('Error: there is NO input data selected yet. Add some files first!');
    return;
end

% Read configuration parameters from the edit boxes -----------------------
    %  comment: eval is required to parse the strings and get the arrays!
circuit = get(handles.edit_circuit,'String'); % equivalent circuit to be fitted
initparams = eval(get(handles.edit_initparams,'String')); % initial values for the circuit elemts

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
h = waitbar(0,'Performing fitting... please wait');

% initializing variables for speed optimization!
results = cell(length(data),length(initparams)); % preallocating for speed

% check the selected algorithm, weighting and max iterations
algorithm = get(handles.algorithmmenu,'Value');
weighting = get(handles.weightingmenu,'Value');
maxiter = str2double( get(handles.edit_iterations,'String') );

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

setappdata(handles.eismain,'results',results);
setappdata(handles.eismain,'zbest',zbest);

disp('Info: Fitting completed successfully');
toc();

set(handles.txt_savestatus,'string','Fitting results ready, please save');

plotnyq2(hObject, eventdata, handles);  % plot nyquist in second axes

% Display a table with the fitting results in a new figure
fres = figure();
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

[outFileName,outPathName] = uiputfile({'*.xls','Excel Spreadsheet (*.xls)'});
if isequal(outFileName,0)
   disp('Info: No file was selected');
   return;  % terminate the callback here
end

h = waitbar(0,'Saving data... please wait');

disp('Info: Saving the results -please wait-');
outfullfname = fullfile(outPathName,outFileName);
xlswrite(outfullfname, [param_cnames corr_cnames ; fnames results corr_values]);
disp('Info: Results saved successfully!');
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
