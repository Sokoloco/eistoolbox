function calculate_correlations(hObject, eventdata, handles)
measured = getappdata(handles.eismain,'data');
simulated= getappdata(handles.eismain,'zbest');
% This function calculates the correlation coefficient between the input
% curve (expected) and the fitted curve (observed).

for idx=1:length(measured)
    expected_real{idx} = measured{idx}(:,2);     % real part of measured measured
    expected_imag{idx} = measured{idx}(:,3);     % imag part of measured measured
    observed_real{idx} = simulated{idx}(:,1);    % real part of fitted measured
    observed_imag{idx} = simulated{idx}(:,2);    % imag part of fitted measured
    expected_MAG{idx} = sqrt(expected_real{idx}.^2 + expected_imag{idx}.^2);    % magnitude of measured measured
    observed_MAG{idx} = sqrt(observed_real{idx}.^2 + observed_imag{idx}.^2);    % magnitude of fitted measured
end


% Beginning of Pearson Chi-Square Test
% for goodness of fit of an observed distribution to a theoretical one
% this test is wrongly implemented - WORK IN PROGRESS ---------------------

for idx=1:length(measured)
    % Calculate correlation (magnitude)
    R1{idx} = corr(expected_MAG{idx},observed_MAG{idx});
    
    % Chi square test
    df = 1; % wrong!
    chi2{idx} = sum((observed_MAG{idx}-expected_MAG{idx}).^2 ./ expected_MAG{idx});
    p{idx} = 1 - chi2cdf(chi2{idx},df);
    
    % Goodness of fit by Mean Square Errors
    fit{idx} = goodnessOfFit(observed_MAG{idx}, expected_MAG{idx},'MSE');
end

% R1 is the correlation coefficient of magnitude
% chi2 is the chi square stats for magnitude
% p is the pearson coefficient
% fit is the goodness of fit by mean square error

% -------------------------------------------------------------------------

cm=colormap(hsv(length(measured))); % define a colormap

corrgui; % opens the correlation window
axreal=findobj('Type','axes','Tag','axesreal');
axes(axreal);
cla;    % clear previous data

% Correlation (X,Y) plots, ideally should be straight lines
for idx=1:length(expected_real)
    plot(expected_real{idx},observed_real{idx},...
        'color',0.8*cm(idx,:),...
        'marker','.',...
        'markersize',12);
    hold on;
    grid on;
end
title('Correlation plot (X,Y) for Real Part');
xlabel('Measured (real)');
ylabel('Fitted (real)');
set(gca,'FontSize',7);

aximag=findobj('Type','axes','Tag','axesimag');
axes(aximag);
cla;    % clear previous data

for idx=1:length(measured)
    plot(expected_imag{idx},observed_imag{idx},...
        'color',0.8*cm(idx,:),...
        'marker','.',...
        'markersize',12);
    hold on;
    grid on;
end
title('Correlation plot (X,Y) for Imaginary Part');
xlabel('Measured (imag)');
ylabel('Fitted (imag)');
set(gca,'FontSize',7);

% Correlation of magnitude
axmag=findobj('Type','axes','Tag','axesmag');
axes(axmag);
cla;    % clear previous data

for idx=1:length(measured)
    plot(expected_MAG{idx},observed_MAG{idx},...
        'color',0.8*cm(idx,:),...
        'marker','.',...
        'markersize',12);
    hold on;
    grid on;
end
title('Correlation plot (X,Y) for Magnitude');
xlabel('Measured (mag)');
ylabel('Fitted (mag)');
set(gca,'FontSize',7);

% Calculate here the linear regression coefficients for real and imaginary
% fit (observed) vs measured (expected)
% analysis from http://de.mathworks.com/help/matlab/data_analysis/linear-regression.html
for idx=1:length(expected_real)
    % linear fit using polyfit
    p_re{idx} = polyfit(expected_real{idx},observed_real{idx},1); %p1=slope, p2=intersect
    % evaluate the line to get measured points
    yfit_re{idx} = polyval(p_re{idx},expected_real{idx});
    % calculate the residual values
    yresid_re{idx} = observed_real{idx} - yfit_re{idx};
    % square the residuals and get the residual sum of squares
    SSresid_re{idx} = sum(yresid_re{idx}.^2);
    % compute the total sum of squares by multiplying  variance by n-1
    SStotal_re{idx} = (length(observed_real{idx})-1) * var(observed_real{idx});
    % compute R^2
    rsq_re{idx} = 1 - SSresid_re{idx}/SStotal_re{idx};
    % compute adjusted R^2 to account for degrees of freedom
    rsq_adj_re{idx} = 1 - SSresid_re{idx}/SStotal_re{idx} * (length(observed_real{idx})-1)/(length(observed_real{idx})-length(p_re{idx}));
    
    % The same is done for the imaginary parts
    % linear fit using polyfit
    p_im{idx} = polyfit(expected_imag{idx},observed_imag{idx},1); %p1=slope, p2=intersect
    % evaluate the line to get measured points
    yfit_im{idx} = polyval(p_im{idx},expected_imag{idx});
    % calculate the residual values
    yresid_im{idx} = observed_imag{idx} - yfit_im{idx};
    % square the residuals and get the residual sum of squares
    SSresid_im{idx} = sum(yresid_im{idx}.^2);
    % compute the total sum of squares by multiplying  variance by n-1
    SStotal_im{idx} = (length(observed_imag{idx})-1) * var(observed_imag{idx});
    % compute R^2
    rsq_im{idx} = 1 - SSresid_im{idx}/SStotal_im{idx};
    % compute adjusted R^2 to account for degrees of freedom
    rsq_adj_im{idx} = 1 - SSresid_im{idx}/SStotal_im{idx} * (length(observed_imag{idx})-1)/(length(observed_imag{idx})-length(p_im{idx}));
    
    % The same is done for the magnitude
    % linear fit using polyfit
    p_mag{idx} = polyfit(expected_MAG{idx},observed_MAG{idx},1); %p1=slope, p2=intersect
    % evaluate the line to get measured points
    yfit_mag{idx} = polyval(p_mag{idx},expected_MAG{idx});
    % calculate the residual values
    yresid_mag{idx} = observed_MAG{idx} - yfit_mag{idx};
    % square the residuals and get the residual sum of squares
    SSresid_mag{idx} = sum(yresid_mag{idx}.^2);
    % compute the total sum of squares by multiplying  variance by n-1
    SStotal_mag{idx} = (length(observed_MAG{idx})-1) * var(observed_MAG{idx});
    % compute R^2
    rsq_mag{idx} = 1 - SSresid_mag{idx}/SStotal_mag{idx};
    % compute adjusted R^2 to account for degrees of freedom
    rsq_adj_mag{idx} = 1 - SSresid_mag{idx}/SStotal_mag{idx} * (length(observed_MAG{idx})-1)/(length(observed_MAG{idx})-length(p_mag{idx}));
end

corrs= transpose([rsq_re; rsq_adj_re; rsq_im; rsq_adj_im; rsq_mag; rsq_adj_mag; R1; chi2; p; fit]);
cnames={'real_R^2','real_R^2(adj)','imag_R^2','imag_R^2(adj)','MAG_R^2','MAG_R^2(adj)','R1','chi2','p','fit'};

t=findobj('Tag','tablecorr');
set(t, 'Data', corrs,'ColumnWidth',{80},'ColumnName',cnames);
% implement residual errors plot, check Orazem, Chapter 20

setappdata(handles.eismain,'corr_values',corrs);
setappdata(handles.eismain,'corr_cnames',cnames);
