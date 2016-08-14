function varargout = menu_about(varargin)
% MENU_ABOUT MATLAB code for menu_about.fig
%      MENU_ABOUT, by itself, creates a new MENU_ABOUT or raises the existing
%      singleton*.
%
%      H = MENU_ABOUT returns the handle to a new MENU_ABOUT or the handle to
%      the existing singleton*.
%
%      MENU_ABOUT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MENU_ABOUT.M with the given input arguments.
%
%      MENU_ABOUT('Property','Value',...) creates a new MENU_ABOUT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before menu_about_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to menu_about_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help menu_about

% Last Modified by GUIDE v2.5 14-Aug-2016 10:26:55

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @menu_about_OpeningFcn, ...
                   'gui_OutputFcn',  @menu_about_OutputFcn, ...
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


% --- Executes just before menu_about is made visible.
function menu_about_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to menu_about (see VARARGIN)

% Choose default command line output for menu_about
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes menu_about wait for user response (see UIRESUME)
% uiwait(handles.figure1);

set(handles.txt_about,'string','eistoolbox (c) 2016 Juan J. Montero-Rodriguez');
set(handles.txt_about2,'string', 'This toolbox is released under the GPL3 license, which means you can use it, redistribute it in binary or source formats, modify it and even sell your adaptations if you KEEP the license information intact.' );

    'This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version. This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details. You should have received a copy of the GNU General Public License along with this program.  If not, see <http://www.gnu.org/licenses/>.'



% --- Outputs from this function are returned to the command line.
function varargout = menu_about_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


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
