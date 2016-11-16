%% Batch fitting of Gamry EIS files using Zfit
% Run this file to perform batch fitting of all Gamry .DTA files in a dir.
% 
% Tested with Gamry 1000 Interface data files (.DTA) from Gamry Framework
% 
% Requires the following libraries to be in the MATLAB path:
%   - Zfit.m by Jean Luc Dellis (the original file! download it from matlab central)
%   - GamryRead.m from Juan Montero
% 
% 
% USAGE INSTRUCTIONS
% Modify the following input parameters as you require.
% Input parameters:
%   - circuit: a string with the desired circuit model (see Zfit)
%   - initparams: the initial values of the parameters
%   - LB: lower boundary for parameter values
%   - UB: upper boundary for parameter values
%   - filepath: path to the directory containing .DTA files ONLY
% Check also the documentation of Zfit for the details.
%
%   % ToDo: sometimes the program says "increase MaxFunEvals option" when
%   % it cannot achieve a fit after a specified number of evaluations.
%   % It would be good to add this comment to the excel file, and also the
%   % option to increase this number of max evaluations.
%    
% Creation: 20.07.2016  Author: Juan Montero jjmontero9@gmail.com

%% USER CONFIGURATION (modify parameters as you need)
% file location -----------------------------------------------------------
filepath = 'C:\PROJECTS\sportsdata\';    % set here the path to the files

% circuit definition ------------------------------------------------------
circuit = 's(R1,p(R1,C1))';        % standard Randles cell
initparams = [100, 100, 1e-6];

% fitting parameters ------------------------------------------------------
indexes = []; % empty = all data is used, OR use custom ranges
fitstring = 'fitNP'; % 'fitNP' non-proportional, OR '' proportional
LB=[0,0,0];          % lower boundary for all parameters
UB=[inf,inf,inf];    % upper boundary for all parameters


%% PROCESSING OF IMPEDANCE CURVES (do not touch this section)
% disable the plots of Zfit library
plotstr = '';   % '' for silent computation

files = dir(filepath);
fileIndex = find(~[files.isdir]);

% initializing variables for speed optimization!
results     = cell(length(fileIndex),length(initparams));
filenames   = cell(length(fileIndex),1);

for i = 1:length(fileIndex)
    fileName = files(fileIndex(i)).name;    % get one file name
    strcat('Currently evaluating file: ',int2str(i),' of ',int2str(length(fileIndex)),'    Filename: ',fileName)
    data = GamryRead(fileName);             % load the data to memory

    % perform the fitting 
    [params,zbest] = Zfit(data,plotstr,circuit,initparams,indexes,fitstring,LB,UB);
    filenames(i,1) = cellstr(fileName);
    results(i,:) = num2cell(params);

end

%% SAVING AND EXPORTING THE RESULTS
% store the results as a csv/xls file
xlswrite('results.xls', [filenames results]);

%% PLOTTING A SPECIFIC DATA FILE
% Zfit(GamryRead('TEST5_05.DTA'),'z');

%% LICENSE
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
