%% Read Gamry EIS data files (.DTA)
% This function removes the headers and all the non-relevant information,
% and imports the impedance spectroscopy curve to MATLAB.
% The input file should be a .DTA file from Gamry Framework Software.
% This script has been fully tested using a Gamry 1000 Interface.
%
% The output is a three-column matrix with the columns: FREQ, ZREAL, ZIMAG.
% This is the same format required for the Zfit library (Jean Luc Dellis).
%
% Example: If the input file is labelled 'EXPERIMENT.DTA', call this as
% > impmatrix = GamryRead('EXPERIMENT.DTA');
% This reads the file and stores the impedance data in a workspace variable.
% 
% Creation: 19.07.2016  Author: Juan Montero jjmontero9@gmail.com

%% GamryRead: read a .DTA file and return the impedance as a matrix
function [zfitdata] = GamryRead(filename)

    fileID = fopen(filename,'rt');   % open file for reading as text

    % search for the ZCURVE label on the DTA file
    % this label separates the header of the Gamry file from the data table
    labelfound = 0;
    while labelfound==0;
        tline = fgetl(fileID);                       % read one line
        
        if tline == -1  % this happens when the EOF is reached
            error('Please use a valid .DTA file from Gamry Instruments');
        end
        
        labelfound = strcmp(tline, 'ZCURVE	TABLE'); % check if it's the label
    end
    
    tline = fgetl(fileID); % line with titles
    tline = fgetl(fileID); % line with units
    
    tline = fgetl(fileID);          % get first line with data
    
    % read the rest of the file
    idx = 1;
    while tline ~= -1
        data = strsplit(tline);         % separate it into columns
        
        freq(idx) = str2double(data(4)); % output variable: frequency
        real(idx) = str2double(data(5)); % output variable: real(Z)
        imag(idx) = str2double(data(6)); % output variable: imag(Z)
        
        idx = idx + 1;
        tline = fgetl(fileID);          % get line with data
    end
    
    fclose(fileID);
    
    % Export the data (matrix with three columns): FREQ ZREAL ZIMAG
    outdata = transpose([freq;real;imag]);
    zfitdata = outdata;
    
end

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
