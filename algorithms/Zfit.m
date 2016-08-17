function [pbest,zbest,fval,exitflag,output]= ...
    Zfit(data,circuitstring,pbest,indexes,fitstring,LB,UB)
% This file is modified from the original 'Zfit.m' library, to include only
% the sections and options used in 'eistoolbox.m'. Date: 15.08.2016
%
% The original file is Copyright (c) 2005 Jean-Luc Dellis; can be found in:
% http://de.mathworks.com/matlabcentral/fileexchange/19460-zfit
% See the bottom of this file for the original license.

%% MAIN FUNCTION
freq=data(:,1);
options=[];                                        
if isempty(indexes)
    indexes=1:length(freq);
end
freq=data(indexes,1); 
zrzi=[data(indexes,2),data(indexes,3)];
[pbest,fval,exitflag,output]=curfit(pbest,circuitstring,freq,zrzi,@computecircuit,LB,UB,fitstring,options);
zbest=computecircuit(pbest,circuitstring,freq);
end % END of ZFIT =========================================================

%% CURFIT
function [p,fval,exitflag,output]=curfit(pinit,circuitstring,freq,zrzi,handlecomputecircuit,LB,UB,fitstring,options)
% Minimization function calling fminsearch
param=pinit;
[p,fval,exitflag,output]=fminsearchbnd(@distance,param,LB,UB,options);
		
    % DISTANCE is nested, so it knows handlecomputecircuit,circuitstring,freq,fitstring and zrzi
    function dist=distance(param)

        % The next line simulates the circuit and extracts the impedance,
        % by evaluating the circuit with the last OR supplied parameters.
        % This line is equivalent to ymod=computecircuit(param,circuitstring,freq)
        ymod=feval(handlecomputecircuit,param,circuitstring,freq);

        % Then the cummulative distance between fitted and measured is
        % calculated. This is the parameter that needs to be minimized.
        if isequal('fitNP',fitstring)
            dist=sum(sum((ymod-zrzi).^2));
        else
            dist=sum(sum(((ymod-zrzi)./zrzi).^2));  
        end

    end         % END of DISTANCE
end % END of CURFIT =======================================================

%% COMPUTECIRCUIT
% This function takes the 'circuitstring' and parses it to obtain the 
% impedance of the circuit as a function of the frequency. z = f(freq).

% This is done by identifying each element (R1, C1, etc) and computing the
% impedance of each element separately (using the circuit element functions
% below).

% The impedance behavior of each element is stored in a column of z.

% Finally the total impedance is calculated, table z is destroyed and the
% impedance response of the circuit is presented at the output of the
% function.

function z=computecircuit(param,circuit,freq)
    
    % Computes the complex impedance Z of the circuit string
    % process CIRCUIT to get the elements and their numeral inside CIRCUIT
    A=circuit~='p' & circuit~='s' & circuit~='(' & circuit~=')' & circuit~=',';
    element=circuit(A);

    k=0;
    % for each element
    for i=1:2:length(element-2)
        k=k+1;
        nlp=str2num(element(i+1));% idendify its numeral
        localparam=param(1:nlp);% get its parameter values
        param=param(nlp+1:end);% remove them from param
        
        % compute the impedance of the current element for all the frequencies
        z(:,k)=eval([element(i),'([',num2str(localparam),']',',freq)']);
        
        % modify the initial circuit string (to use it later with eval)
        circuit=regexprep(circuit,element(i:i+1),['z(:,',num2str(k),')'],'once');
    end
    
    z=eval(circuit);        % compute the global impedance
    z=[real(z),imag(z)];    % real and imaginary parts are separated to be processed

end % END of COMPUTECIRCUIT

% CIRCUIT ELEMENT FUNCTIONS
% Calculate the impedance response of a single element
function z=R(p,f)% resistor
z=p*ones(size(f));
end

function z=C(p,f)% capacitor
z=1i*2*pi*f*p;
z=1./z;
end

function z=L(p,f)% inductor
z=1i*2*pi*f*p;
end

function z=E(p,f)% CPE
z=1./(p(1)*(1i*2*pi*f).^p(2));
end

% sub functions for adding multiple elements in parallel or series
% modified 15.08.2016 - jjmontero9
function z=s(varargin)
    z = 0;
    for idx = 1:nargin
       z = z + varargin{idx};
    end
end  

function z=p(varargin)
    z = 0;
    for idx = 1:nargin
       z = z + (1 ./ varargin{idx}) ;
    end
    z = 1 ./ z;
end       

%% LICENSE INFORMATION FOR THIS FILE: 'Zfit.m'
% The original license for the Zfit.m function reads as follows:
% 
% Copyright (c) 2005, Jean-Luc Dellis
% All rights reserved.
% 
% Redistribution and use in source and binary forms, with or without
% modification, are permitted provided that the following conditions are
% met:
% 
%     * Redistributions of source code must retain the above copyright
%       notice, this list of conditions and the following disclaimer.
%     * Redistributions in binary form must reproduce the above copyright
%       notice, this list of conditions and the following disclaimer in
%       the documentation and/or other materials provided with the distribution
% 
% THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
% AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
% IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
% ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
% LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
% CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
% SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
% INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
% CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
% ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
% POSSIBILITY OF SUCH DAMAGE.
