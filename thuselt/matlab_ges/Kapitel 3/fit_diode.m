% fit_diode.m
% Anpassung der Strom-Spannungs-Kennlinie einer Diode an experimentelle Werte
%

clf
% ******************
% Parameter
% ******************

konstanten

% Messwerte
U = [0.1 0.2 0.3 0.4 0.5 0.6 0.7]; % Zahlenwerte in Volt oder eV
I = [0.1e-12  2.0e-12  3.41e-11  3.21e-10  4.1e-9  5.6e-8  8.86e-7];

lnI = log(I); % Bilde Logarithmus des Stroms

% ******************
% Anpassung
% ******************
p_fit = polyfit(U,lnI,1);  % Koeffizienten der besten Anpassung an Gerade

% Anpassung an lineare Gleichung y = m*x + b
b = p_fit(2);
m = p_fit(1);
Ifit = m*U + b;

% Berechnung von Is und n
Is = exp(b)
n = 1/(m*kT)

% ******************
% Ausgabe
% ******************
% Darstellung U über ln(I); Anpassung an Gerade
subplot(2,1,1)    % Subplots als (2x1)-Matrix - oberes Feld
plot(U,Ifit,'k', U, lnI,'or'); grid on;
axis([0,0.7,-35,-10])
ylabel('ln(I)')
title('Anpassung an Gerade')

% Darstellung U über I (Kennlinie)
subplot(2,1,2)    % - unteres Feld
U1 = 0:.01:0.7;
Ifit1 = m*U1 + b;
I1 = exp(Ifit1);
plot(U1,I1,'k', U, exp(lnI),'or'); grid on
xlabel('U (V)')
ylabel('I (A)')
title('Kennlinie')
