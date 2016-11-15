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

% License information:
% This file is modified from the original 'Zfit.m' library, to include only
% the sections and options used in 'eistoolbox.m'. Date: 15.08.2016
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
    case 2  % genetic algorithm
        options = optimoptions('ga','MaxGenerations', maxiter,'InitialPopulationMatrix',param);
        [p,fval]=ga(@distance,length(param),[],[],[],[],LB,UB,[],options);
    case 3  % simulated annealing
        options = optimoptions('simulannealbnd','MaxIterations',maxiter);
        [p,fval]=simulannealbnd(@distance,param,LB,UB,options);
    case 4  % fmincon
        options = optimoptions('fmincon','Algorithm','interior-point','MaxIterations',maxiter,'MaxFunctionEvaluations',maxiter);
        [p,fval]=fmincon(@distance,param,[],[],[],[],LB,UB,[],options);
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

