% File to generate csv file for a Randles circuit
% This allows fitting experimental data to the original circuit
% Accuracy should be close to 100%

params = [100 100 1e-6];
freq = logspace(0,6);

R1 = params(1)*ones(size(freq));
R2 = params(2)*ones(size(freq));
C1 = 1./(1i*2*pi*freq*params(3));

% Randles circuit
z = R1 + (R1.*C1)./(R1+C1);

csvwrite('randles_ideal.csv',[freq' real(z') imag(z')]);
