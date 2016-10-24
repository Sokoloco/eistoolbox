function [pbest,zbest,fval]= fitting_engine( ...
    data, ...           % input data
    circuitstring, ...  % circuit model (string representation)
    pbest, ...          % initial parameters
    LB, ...             % lower boundary conditions for parameters
    UB, ...             % upper boundary conditions for parameters
    algorithm, ...      % algorithm number
    weighting, ...      % weighting type number
    maxiter ...         % max number of iterations
    )
% This file is modified from the original 'Zfit.m' library, to include only
% the sections and options used in 'eistoolbox.m'. Date: 15.08.2016
%
% The original file is Copyright (c) 2005 Jean-Luc Dellis; can be found in:
% http://de.mathworks.com/matlabcentral/fileexchange/19460-zfit

%% MAIN FUNCTION
freq=data(:,1); 
zrzi=[data(:,2),data(:,3)];
[pbest,fval]=curfit(pbest,circuitstring,freq,zrzi,@computecircuit,LB,UB,algorithm,weighting,maxiter);
zbest=computecircuit(pbest,circuitstring,freq);
end % END of ZFIT =========================================================

%% CURFIT
function [p,fval]=curfit(param,circuitstring,freq,zrzi,handlecomputecircuit,LB,UB,algorithm,weighting,maxiter)

switch algorithm
    case 1  % fminsearchbnd
        options = optimset('MaxFunEvals', maxiter, 'MaxIter',maxiter);
        [p,fval]=fminsearchbnd(@distance,param,LB,UB,options);
    otherwise
        error('Error: Algorithm is not defined. Stopping.');
end

    % DISTANCE is nested, so it knows handlecomputecircuit,circuitstring,freq,fitstring and zrzi
    function dist=distance(param)

        % Calculate the fitted impedance Zi,calc as:
        ymod=feval(handlecomputecircuit,param,circuitstring,freq);

        % The weighting type determines the coefficients:
        switch weighting
            case 1 % proportional
                wreal = 1 ./ zrzi(:,1).^2;
                wimag = 1 ./ zrzi(:,2).^2;
            case 2 % unit
                wreal = 1;
                wimag = 1;
            case 3 % modulus
                wreal = 1 ./ (zrzi(:,1).^2+zrzi(:,2).^2);
                wimag = 1 ./ (zrzi(:,1).^2+zrzi(:,2).^2);
            case 4 % statistical
                % not implemented yet...
            otherwise
                wreal = 1;
                wimag = 1;
        end
        
        % Then the distance between fitted and measured is calculated:
        dist = sum( sum( wreal .* (zrzi(:,1) - ymod(:,1)).^2 + wimag .* (zrzi(:,2) - ymod(:,2)).^2 ) );

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
        nlp=str2double(element(i+1));% idendify its numeral
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

%% CIRCUIT ELEMENT FUNCTIONS
% Calculate the impedance response of a single element
function z=R(p,f);  z=p*ones(size(f));   end    % Resistor
function z=C(p,f);  z=1./(1i*2*pi*f*p);  end    % Capacitor
function z=L(p,f);  z=1i*2*pi*f*p;       end    % Inductor
function z=E(p,f);  z=1./(p(1)*(1i*2*pi*f).^p(2)); end % CPE

% Add multiple elements in series
function z=s(varargin)
    z = 0;
    for idx = 1:nargin
       z = z + varargin{idx};
    end
end  

% Add multiple elements in parallel
function z=p(varargin)
    z = 0;
    for idx = 1:nargin
       z = z + (1 ./ varargin{idx}) ;
    end
    z = 1 ./ z;
end       