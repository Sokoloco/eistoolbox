function [pbest,zbest,fval,exitflag,output]=Zfit(varargin)
% ZFIT is a function which can PLOT, SIMULATE and FIT impedance data.
%
%[pbest,zbest,fval,exitflag,output]=Zfit(varargin)
%
% [pbest,zbest,fval,exitflag,output]=
% ... Zfit(data,plotstring,circuitstring,circuitparameters,indexes,fitstring,LB,UB,options)
%
% SYNTAXES:
%
% Zfit(data)
%                       Plots the impedance DATA if it is a 3-columns wise 
%                   matrix [FR, ZR, ZI].
%                   first column = FR = vector of the corresponding frequencies 
%                   second column = ZR = vector of the real part of an impedance
%                   third column = ZI = vector of the imaginary part of an impedance
%                   DATA may be a single frequency column vector when simulations
%                   are desired.
%                   Impedance, admittance, capacitance and modulus representations
%                   in the complex plane are then pushbutton obtainable.
%
% Zfit(...,plotstring)
%                       PLOTSTRING precises which representation has to be used
%                   when plotting. 'z' : Impedance, 'y' : admittance, 
%                   'c' : capacitance and 'm' : modulus.
%                   For programmatic purposes, the plotting can be switched off
%                   when plotstring is any other string or empty ...
%
% [p,z]=Zfit(...,circuitstring,circuitparameters)
%                   Computes the impedance z of a circuit at the frequencies 
%                   given in DATA(:,1). These simulated data can be graphically compared
%                   to the experimental DATA(:,2 and 3) if these columns
%                   exist. P is simply circuitparameters. Z is a 2-columns
%                   matix containing the real and imaginary parts of the
%                   impedance.
%
%                   - CIRCUITSTRING is a string 
%                   It has to be composed of the operators S and/or P which put elements
%                   in series (lower S) or in parallel (lower P). For instances:
%                   'p(R1,C1)' defines an resistor R and an capacitor C in parallel.
%                   's(R1,p(R1,C1))' a R//C parallel circuit is put in series with a resistor.
%                   's(p(R1,C1),p(R1,C1))' 2-R//C circuits are put in series.
%                   'p(p(R1,C1),E2)' a CPE is put in parallel with a R//C circuit.
%                   'E2' is a CPE alone
%
%                   The available elements are R, C, L, E which are built-in functions and 
%                   any user defined function. It is convenient to write the elements 
%                   with upper letter for a better reading of the circuit string.
%
%                   For all the elements, it is MANDATORY to precise the number of parameters
%                   used by the involved element. This is achieved by allocating a numeral to it.
%                   So R, C and L will allways have an 'one' attached to them, when E will be
%                   followed by the numeral 2. This is due to the computation of the
%                   user-defined elements for which the code would not know the number of
%                   parameters otherwise.
%
%                   - CIRCUITPARAMETERS is a vector of parameters 
%                   The vector elements are the parameter values used to compute the element
%                   impedances. These values are written in the same order the elements
%                   come in the CIRCUIT string. For instance, the circuit
%                   'p(R1,C1)' need 2 parameters, the resistor value and
%                   the capacitor value, one can write:
%                   circuitparameters=[1e3, 1e-9] for 1 kOhms and 1 nF...
%
%                   In the following definitions, p=circuitparameters:
%                   R: resistor, z=p(1)
%                   C: capacitor, z=1/(j.p(1).2.pi.freq)
%                   L: inductor, z=j.p(1).2.pi.freq
%                   E: constant phase element (CPE), z=1/(p(1).(j.2.pi.freq)^p(2))
%                   X: user-defined function. Its name has to be of ONE LETTER and a format
%                   like the one given in the belower example and in the
%                   sub-functions R,L,C and E.
%
%                   Example:
%
%                   freq=logspace(-1,6,100);freq=freq(:);
%                   circuit='s(p(R1,C1),p(R1,U2))'
%                   param=[100,1e-8,1e3,1e-6,0.65];
%                   Zfit(freq,'z',circuit,param);
%
%                   where U is an user file saved apart:
%                               function z=U(p,f)
%                               z=1./(p(1)*j*2*pi*f).^p(2);
%                               end
%
% [p,z]=Zfit(...,indexes)
%                       INDEXES is a vector containing the row-indexes of data
%                   which have to be plotted, simulated or fitted (fitting is 
%                   described belower). That is usefull to discard outliers.
%                   If indexes is the empty vector then all data are taken into account.
%
% [pbest,zbest,fval,exitflag,output]=Zfit(...,fitstring)
%                       Fit process is asked by the user.
%                   PBEST is the vector of the "best" circuit parameters.
%                   Zbest is the 2-columns wise matrix [Real_Z,Imag_Z]
%                   computed with pbest and the circuitstring. The others
%                   outputs are given by fminsearch, see the Matlab help
%                   documentation for details.
%
%                       If FITSTRING is any string even empty '' except 'fitNP',
%                   then the weighting method is proportionnal meaning that all
%                   the data point counts in the same way whatever their amplitudes.
%                   If FITSTRING is 'fitNP', then there is no weighting meaning
%                   that the data points with higher modules have a greater influence in
%                   the minimization process that those with smaller values.
%
% [pbest,zbest,fval,exitflag,output]=Zfit(...,LB)
%                   LB - lower bound vector that circuitparameters can be in the fit process.
%                   It must be the same size as circuitparameters.
%                   If no lower bounds exist for one of the variables, then
%                   supply -inf for that variable.
%                   If no lower bounds at all, then LB may be left empty.
%
% [pbest,zbest,fval,exitflag,output]=Zfit(...,UB)
%                   UB - upper bound vector that circuitparameters can be in the fit process.
%                   It must be the same size as circuitparameters.
%                   If no upper bounds exist for one of the variables, then
%                   supply +inf for that variable.
%                   If no upper bounds at all, then UB may be left empty.
%
% [pbest,zbest,fval,exitflag,output]=Zfit(...,options)
%                       Minimizes with the optimization parameters specified 
%                   in the structure options. You can define these parameters 
%                   using the optimset function. See the Matlab help
%                   documentation for details. These options are those of
%                   the Matlab function fminsearch.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%                   
% EXAMPLE 1:
% creating simulated z-data for a simple circuit:
%
%                         freq=logspace(-1,6,100);
%                         freq=freq(:);                             % frequencies in a column vector
%                         circuit='s(p(R1,C1),p(R1,E2))';     %describes the circuit shape
%                         param=[5e4, 1e-10, 4e4, 5e-8,0.6]; % puts the values in one vector
%                         % which corresponds to a resistor =80 kOhms, a
%                         % "pure" capacitor=0.1 nF, a second resistor =1.5ek Ohms
%                         % and a CPE with peudo-capacitor =1e-8 and exponent =0.8.
%                         % now computes and plots the simulated data:
%                         [p,zsimu]=Zfit(freq,'z', circuit, param);
% EXAMPLE 2:
% add noise and compare the 2 sets, in an impedance plot:
%                         zexp=zsimu.*(1+0.05*randn(size(zsimu))); 
%                         Zfit([freq,zexp],'z', circuit, param);
% EXAMPLE 3:
% get best parameters with approximate starting parameters on a portion of the experimental data
% for instance for the points 1 to 60 and 80 to 100, holding the first resistor R=4e4 constant and
% using a Non Proportionnal weighting method
%                         indexes=[1:60,80:100];
%                         param=[4e4, 1e-10, 4e4, 5e-8,0.6];
%                         LB=[4e4,-inf,-inf,-inf,-inf];
%                         UB=[4e4,inf,inf,inf,inf];
%                         [p,zbest]=Zfit([freq,zexp],'z',circuit,param,indexes,'fitNP',LB,UB);
% HINTS:
%                   - Use LB and UB with care. In practical, i used them only 
%                   in order to keep constant one or several parameters.
%                   - the complexity of the space variable increases quickly with the numbers
%                   of circuit parameters, it is IMPERIOUS to begin with good starting values.
%                   Indeed, fminsearch finds minimun which can only be an local minimum.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% NOTE that         fminsearch has been improved with the FMINSEARCHBND of           
%                   JOHN D'ERRICO which allows to put constraints on the
%                   parameters (circuitparameters in this program):
%                   http://www.mathworks.com/matlabcentral/fileexchange
%                   fminsearchbnd is supplied here as a
%                   sub-function and can be saved in a separate file.
%
% NOTE that         all functions are ending by "end" since one of them is nested
%
%
%may 2005
%modified october 2007
%minor corrections april 2008
%mars 2010, the way circuit is entered has been modified to ease the use
%jean-luc.dellis@u-picardie.fr
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MAIN function 
    switch nargin
        
        case 0 % not allowed
        error('PLEASE, supply at least a 3-columns wise data matrix: [FREQ,RealZEXP,ImagZEXP]')

        % Zfit(data)
        case 1
        data=varargin{1};
        freq=data(:,1);
        plotz(freq,size(data)*nan,data,'z')
        return

        % Zfit(data,plotstring)
        case 2
        data=varargin{1};
        freq=data(:,1);
        plotstring=varargin{2};
        if ~strcmp(plotstring,'z')&&~strcmp(plotstring,'y')&&~strcmp(plotstring,'c')&&~strcmp(plotstring,'m'),return,end
        plotz(freq,size(data)*nan,data,plotstring)
        return

        case 3 % not allowed
        error('PLEASE, if circuit simulation is wishing then supply at least a parameter vector')

% [pbest,zbest]=Zfit(data,plotstring,circuitstring,circuitparameters)
        case 4
        data=varargin{1};
        freq=data(:,1);
        plotstring=varargin{2};    
        circuitstring=varargin{3};
        pbest=varargin{4};

% [pbest,zbest]=Zfit(data,plotstring,circuitstring,circuitparameters,indexes)
        case 5
        data=varargin{1};
        freq=data(:,1);
        plotstring=varargin{2};    
        circuitstring=varargin{3};
        pbest=varargin{4};
        indexes=varargin{5};if isempty(indexes),indexes=1:length(freq);end,freq=data(indexes,1);
    
% [pbest,zbest,fval,exitflag,output]=
% ... Zfit(data,plotstring,circuitstring,circuitparameters,indexes,'fitP' or 'fitNP')
        case 6
        data=varargin{1};
        freq=data(:,1);
        plotstring=varargin{2};    
        circuitstring=varargin{3};
        pbest=varargin{4};
        options=[];                                        
        indexes=varargin{5};if isempty(indexes),indexes=1:length(freq);end,freq=data(indexes,1); 
        fitstring=varargin{6};
        LB=-inf*ones(length(pbest),1);UB=inf*ones(length(pbest),1);
        zrzi=[data(indexes,2),data(indexes,3)];
        [pbest,fval,exitflag,output]=curfit(pbest,circuitstring,freq,zrzi,@computecircuit,LB,UB,fitstring,options);
    
% [pbest,zbest,fval,exitflag,output]=
% ... Zfit(data,plotstring,circuitstring,circuitparameters,indexes,'fitP' or 'fitNP',LB)
        case 7
        data=varargin{1};
        freq=data(:,1);
        plotstring=varargin{2};    
        circuitstring=varargin{3};
        pbest=varargin{4};
        options=[];                                        
        indexes=varargin{5};if isempty(indexes),indexes=1:length(freq);end,freq=data(indexes,1); 
        fitstring=varargin{6};
        LB=varargin{7};
        UB=inf*ones(length(pbest),1);
        zrzi=[data(indexes,2),data(indexes,3)];
        [pbest,fval,exitflag,output]=curfit(pbest,circuitstring,freq,zrzi,@computecircuit,LB,UB,fitstring,options);
    
% [pbest,zbest,fval,exitflag,output]=
% ... Zfit(data,plotstring,circuitstring,circuitparameters,indexes,'fitP' or 'fitNP',LB,UB)
        case 8
        data=varargin{1};
        freq=data(:,1);
        plotstring=varargin{2};    
        circuitstring=varargin{3};
        pbest=varargin{4};
        options=[];                                        
        indexes=varargin{5};if isempty(indexes),indexes=1:length(freq);end,freq=data(indexes,1); 
        fitstring=varargin{6};
        LB=varargin{7};
        UB=varargin{8};
        zrzi=[data(indexes,2),data(indexes,3)];
        [pbest,fval,exitflag,output]=curfit(pbest,circuitstring,freq,zrzi,@computecircuit,LB,UB,fitstring,options);
    
% [pbest,zbest,fval,exitflag,output]=
% ... Zfit(data,plotstring,circuitstring,circuitparameters,indexes,'fitP' or 'fitNP',LB,UB,options)
        case 9
        data=varargin{1};
        freq=data(:,1);
        plotstring=varargin{2};    
        circuitstring=varargin{3};
        pbest=varargin{4};
        indexes=varargin{5};if isempty(indexes),indexes=1:length(freq);end,freq=data(indexes,1); 
        fitstring=varargin{6};
        zrzi=[data(indexes,2),data(indexes,3)];
        LB=varargin{7};
        UB=varargin{8};    
        options=varargin{9};
        [pbest,fval,exitflag,output]=curfit(pbest,circuitstring,freq,zrzi,@computecircuit,LB,UB,fitstring,options);
        
        otherwise
        error('No more than 9 inputs in Zfit')
    end
zbest=computecircuit(pbest,circuitstring,freq);
if ~strcmp(plotstring,'z')&&~strcmp(plotstring,'y')&&~strcmp(plotstring,'c')&&~strcmp(plotstring,'m')&&~isempty(plotstring)
    error('The second input has to be one of these strings: ''z'', ''y'', ''c'', ''m'' or left empty: ''''')
end
if ~isempty(plotstring)
plotz(freq,zbest,data,plotstring)
end
end                     % END of ZFIT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function z=computecircuit(param,circuit,freq)
% Computes the complex impedance Z 
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
    func=[element(i),'([',num2str(localparam),']',',freq)'];% buit an functionnal string
    z(:,k)=eval(func);% compute its impedance for all the frequencies
    % modify the initial circuit string to make it functionnal (when used
    % with eval)
    circuit=regexprep(circuit,element(i:i+1),['z(:,',num2str(k),')'],'once');
end

z=eval(circuit);% compute the global impedance
z=[real(z),imag(z)];% real and imaginary parts are separated to be processed

end             % END of COMPUTECIRCUIT
% sub functions for the pre-buit elements
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
% sub functions for the operators parallel and series
function z=s(z1,z2) % 2 zs in series
z=z1+z2;
end  

function z=p(z1,z2) % 2 zs in parallel
z=1./(1./z1+1./z2);
end                    

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [p,fval,exitflag,output]=curfit(pinit,circuitstring,freq,zrzi,handlecomputecircuit,LB,UB,fitstring,options)
% Minimization function calling fminsearch
param=pinit;
[p,fval,exitflag,output]=fminsearchbnd(@distance,param,LB,UB,options);
		% DISTANCE is nested, so it knows handlecomputecircuit,circuitstring,freq,fitstring and zrzi
            function dist=distance(param)
            ymod=feval(handlecomputecircuit,param,circuitstring,freq);
            if isequal('fitNP',fitstring)
                dist=sum(sum((ymod-zrzi).^2));
            else
                dist=sum(sum(((ymod-zrzi)./zrzi).^2));  
            end
            end         % END of DISTANCE
end                     % END of CURFIT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%
%%%                %%%
%%% GRAPHICAL PART %%%
%%%                %%%
%%%%%%%%%%%%%%%%%%%%%%
function plotz(freq,zth,data,plotstring)

trace.capa=@tracecapa;                      % structure of subfunction handles
trace.admi=@traceadmi;
trace.impe=@traceimpe;
trace.modu=@tracemodu;
fH=PrepareGraphe(trace);            % creates figure and uicontrols if there are not existing
deleteobjects                       % deletes lines if there are existing
% store simulated and experimental data in the Application Data of the Figure
setappdata(fH,'contZth',[zth(:,1),-zth(:,2)]);      % theorical impedance
yth=1./(zth(:,1)+1i*zth(:,2));                       % theorical admittance
setappdata(fH,'contYth',[real(yth),imag(yth)]);
cth=yth./(1i*2*pi*freq);                             % theorical capacitance
setappdata(fH,'contCth',[real(cth),-imag(cth)]);
mth=1./cth;                                         % theorical modulus
setappdata(fH,'contMth',[real(mth),imag(mth)]);
[datarow,datancol]=size(data);
if isequal(datancol,3)
	zex=data(:,2)+1i*data(:,3);                      % experimental impedance
    setappdata(fH,'contZex',[real(zex),-imag(zex)]);
	yex=1./zex;                                     % experimental admittance
    setappdata(fH,'contYex',[real(yex),imag(yex)]);
	cex=yex./(1i*2*pi*data(:,1));                    % experimental capacitance
    setappdata(fH,'contCex',[real(cex),-imag(cex)]);
    mex=1./cex;                                     % experimental modulus
    setappdata(fH,'contMex',[real(mex),imag(mex)]);
elseif isequal(datancol,1)
    setappdata(fH,'contZex',[nan,nan]);
    setappdata(fH,'contYex',[nan,nan]);
    setappdata(fH,'contCex',[nan,nan]);
    setappdata(fH,'contMex',[nan,nan]);
end
% plot
switch plotstring
    case 'z'
        traceimpe
    case 'y'
        traceadmi
    case 'c'
        tracecapa
    case 'm'
        tracemodu
end
end                     % END of PLOTZ
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function fH=PrepareGraphe(trace)
fH=findobj('tag','Zfit_fig');           % is there an existing figure ?
if isempty(fH)                          % if not, create one and the uicontrols
   fH=controls(trace);
else
    figure(fH)
end
end                     % END of PREPAREGRAPH
%--------------------------------------------------------------------------
function fH=controls(trace)
fH=figure;set(fH,'tag','Zfit_fig')
set(fH,'units','normalized')
hig=0.03;
pos=[0.01,0.01,0.10,hig];
%capaH
uicontrol('tag','capa','units','normalized','position',pos+[0,2*hig,0,0],...
    'string','Capacitance','userdata',trace.capa,'callback','feval(get(gco,''userdata''))');
%admiH
uicontrol('tag','admi','units','normalized','position',pos+[0,hig,0,0],...
    'string','Admittance','userdata',trace.admi,'callback','feval(get(gco,''userdata''))');
%impeH
uicontrol('tag','impe','units','normalized','position',pos+[0,3*hig,0,0],...
    'string','Impedance','userdata',trace.impe,'callback','feval(get(gco,''userdata''))');
%moduH
uicontrol('tag','modu','units','normalized','position',pos+[0,0,0,0],...
    'string','Modulus','userdata',trace.modu,'callback','feval(get(gco,''userdata''))');
end                     % END of CONTROLS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function tracecapa
plotlinelegend('contCth','contCex','C the','C exp')
end
%
function traceadmi
plotlinelegend('contYth','contYex','Y the','Y exp')
end
%
function traceimpe
plotlinelegend('contZth','contZex','Z the','Z exp')
end
%
function tracemodu
plotlinelegend('contMth','contMex','M the','M exp')
end
%
function plotlinelegend(dth,dex,lth,lex)
deleteobjects
th=getappdata(gcf,dth); % get theorical and experimental data in the figure application data
ex=getappdata(gcf,dex);
line('xdata',th(:,1),'ydata',th(:,2),'markeredgecolor','r','marker','*','linestyle','none');
line('xdata',ex(:,1),'ydata',ex(:,2),'markeredgecolor','k','marker','o','linestyle','none');
set(gca,'xlimmode','auto','ylimmode','auto')
if ~isnan(ex(1,1)) && ~isnan(th(1,1))
 legend(lth,lex)
elseif ~isnan(th(1,1))
 legend(lth)
 elseif ~isnan(ex(1,1))
 legend(lex)
end
axis equal
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function deleteobjects
delete(findobj('marker','*'))
delete(findobj('marker','o'))
set(gca,'Xlabel',text('String','Real'),'Ylabel',text('String','+/- Imaginary'))
view(2)         % sets the default two-dimensional viewpoint specification
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%% FMINSEARCHBND can be saved in a separate file %%%%%%%%%%%%%%%%%%%%%
%%%%%%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [x,fval,exitflag,output]=fminsearchbnd(fun,x0,LB,UB,options,varargin)
% fminsearchbnd: fminsearch, but with bound constraints by transformation
% usage: fminsearchbnd(fun,x0,LB,UB,options,p1,p2,...)
% 
% arguments:
%  LB - lower bound vector or array, must be the same size as x0
%
%       If no lower bounds exist for one of the variables, then
%       supply -inf for that variable.
%
%       If no lower bounds at all, then LB may be left empty.
%
%  UB - upper bound vector or array, must be the same size as x0
%
%       If no upper bounds exist for one of the variables, then
%       supply +inf for that variable.
%
%       If no upper bounds at all, then UB may be left empty.
%
%  See fminsearch for all other arguments and options.
%  Note that TolX will apply to the transformed variables. All other
%  fminsearch parameters are unaffected.
%
% Notes:
%
%  Variables which are constrained by both a lower and an upper
%  bound will use a sin transformation. Those constrained by
%  only a lower or an upper bound will use a quadratic
%  transformation, and unconstrained variables will be left alone.
%
%  Variables may be fixed by setting their respective bounds equal.
%  In this case, the problem will be reduced in size for fminsearch.
%
%  The bounds are inclusive inequalities, which admit the
%  boundary values themselves, but will not permit ANY function
%  evaluations outside the bounds.
%
%
% Example usage:
% rosen = @(x) (1-x(1)).^2 + 105*(x(2)-x(1).^2).^2;
%
% fminsearch(rosen,[3 3])     % unconstrained
% ans =
%    1.0000    1.0000
%
% fminsearchbnd(rosen,[3 3],[2 2],[])     % constrained
% ans =
%    2.0000    4.0000

% size checks
xsize = size(x0);
x0 = x0(:);
n=length(x0);

if (nargin<3) || isempty(LB)
  LB = repmat(-inf,n,1);
else
  LB = LB(:);
end
if (nargin<4) || isempty(UB)
  UB = repmat(inf,n,1);
else
  UB = UB(:);
end

if (n~=length(LB)) || (n~=length(UB))
  error 'x0 is incompatible in size with either LB or UB.'
end

% set default options if necessary
if (nargin<5) || isempty(options)
  options = optimset('fminsearch');
end

% stuff into a struct to pass around
params.args = varargin;
params.LB = LB;
params.UB = UB;
params.fun = fun;
params.n = n;

% 0 --> unconstrained variable
% 1 --> lower bound only
% 2 --> upper bound only
% 3 --> dual finite bounds
% 4 --> fixed variable
params.BoundClass = zeros(n,1);
for i=1:n
  k = isfinite(LB(i)) + 2*isfinite(UB(i));
  params.BoundClass(i) = k;
  if (k==3) && (LB(i)==UB(i))
    params.BoundClass(i) = 4;
  end
end

% transform starting values into their unconstrained
% surrogates. Check for infeasible starting guesses.
x0u = x0;
k=1;
for i = 1:n
  switch params.BoundClass(i)
    case 1
      % lower bound only
      if x0(i)<=LB(i)
        % infeasible starting value. Use bound.
        x0u(k) = 0;
      else
        x0u(k) = sqrt(x0(i) - LB(i));
      end
      
      % increment k
      k=k+1;
    case 2
      % upper bound only
      if x0(i)>=UB(i)
        % infeasible starting value. use bound.
        x0u(k) = 0;
      else
        x0u(k) = sqrt(UB(i) - x0(i));
      end
      
      % increment k
      k=k+1;
    case 3
      % lower and upper bounds
      if x0(i)<=LB(i)
        % infeasible starting value
        x0u(k) = -pi/2;
      elseif x0(i)>=UB(i)
        % infeasible starting value
        x0u(k) = pi/2;
      else
        x0u(k) = 2*(x0(i) - LB(i))/(UB(i)-LB(i)) - 1;
        % shift by 2*pi to avoid problems at zero in fminsearch
        % otherwise, the initial simplex is vanishingly small
        x0u(k) = 2*pi+asin(max(-1,min(1,x0u(i))));
      end
      
      % increment k
      k=k+1;
    case 0
      % unconstrained variable. x0u(i) is set.
      x0u(k) = x0(i);
      
      % increment k
      k=k+1;
    case 4
      % fixed variable. drop it before fminsearch sees it.
      % k is not incremented for this variable.
  end
  
end
% if any of the unknowns were fixed, then we need to shorten
% x0u now.
if k<=n
  x0u(k:n) = [];
end

% were all the variables fixed?
if isempty(x0u)
  % All variables were fixed. quit immediately, setting the
  % appropriate parameters, then return.
  
  % undo the variable transformations into the original space
  x = xtransform(x0u,params);
  
  % final reshape
  x = reshape(x,xsize);
  
  % stuff fval with the final value
  fval = feval(params.fun,x,params.args{:});
  
  % fminsearchbnd was not called
  exitflag = 0;
  
  output.iterations = 0;
  output.funcount = 1;
  output.algorithm = 'fminsearch';
  output.message = 'All variables were held fixed by the applied bounds';
  
  % return with no call at all to fminsearch
  return
end

% now we can call fminsearch, but with our own
% intra-objective function.
[xu,fval,exitflag,output] = fminsearch(@intrafun,x0u,options,params);

% undo the variable transformations into the original space
x = xtransform(xu,params);

% final reshape
x = reshape(x,xsize);

% ======================================
% ========= begin subfunctions =========
% ======================================
function fval = intrafun(x,params)
% transform variables, then call original function

% transform
xtrans = xtransform(x,params);

% and call fun
fval = feval(params.fun,xtrans,params.args{:});
end                     % END of INTRAFUN

% ======================================
function xtrans = xtransform(x,params)
% converts unconstrained variables into their original domains

xtrans = zeros(1,params.n);
% k allows soem variables to be fixed, thus dropped from the
% optimization.
k=1;
for i = 1:params.n
  switch params.BoundClass(i)
    case 1
      % lower bound only
      xtrans(i) = params.LB(i) + x(k).^2;
      
      k=k+1;
    case 2
      % upper bound only
      xtrans(i) = params.UB(i) - x(k).^2;
      
      k=k+1;
    case 3
      % lower and upper bounds
      xtrans(i) = (sin(x(k))+1)/2;
      xtrans(i) = xtrans(i)*(params.UB(i) - params.LB(i)) + params.LB(i);
      % just in case of any floating point problems
      xtrans(i) = max(params.LB(i),min(params.UB(i),xtrans(i)));
      
      k=k+1;
    case 4
      % fixed variable, bounds are equal, set it at either bound
      xtrans(i) = params.LB(i);
    case 0
      % unconstrained variable.
      xtrans(i) = x(k);
      
      k=k+1;
  end
end
end                     % END of XTRANSFORM
end                     % END of FMINSEARCHBND



