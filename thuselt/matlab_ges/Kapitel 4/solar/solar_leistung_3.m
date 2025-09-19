% Programm "solar_leistung_3.m"
% Berechnung der maximalen Leistung einer Si-Solarzelle
% durch Minimierung "von Hand" als Funktion von U
% mit Darstellung der Leistung als Funktion der Photospannung
% Parameter der Kurvenschar ist der Photostrom 
% 

disp(' ');
disp('Berechnung der maximalen Leistung einer Si-Solarzelle')
clear
close

% ************************
% Konstanten und Parameter
% ************************
konstanten;  

% **************************
% Wahl der Eingangsvariablen
% **************************

UD = 0.85;              % Diffusionsspannung
U = 0:.01: UD;          % Bereich der angelegten Spannung (in Volt)
js = 2.49e-8;           % Sättigungsstrom
jopt = -20;             % Photostrom in mA pro cm^2

% ******************************
% Berechnung des Gesamtstroms
% ******************************
j =  jopt + js * (exp(U/kT) - 1);	  % Gesamtstrom

% **************************
% Minimumsuche und Plot
% **************************
UV_min=0; UV_max = 1; p_max = max(-j.*U);
plot(U,-j.*U); axis([UV_min UV_max 0 p_max]);
grid; xlabel('U(V)'); ylabel('-j.*U (VmA/cm^-^2)'); 
title('Leistung einer Solarzelle über der Spannung'); 
[pmax,index] = max(-j.*U);  % liefert den maximalen Wert der Leistung
                            % und den Index dazu
U_optim = U(index);         % zugehörige Spannung
j_optim = j(index);         % zugehöriger Strom

% ******************************
% Ergebnisse
% ******************************
disp ('Optimale Werte')
disp ('Ergebnis der direkten Minimumsuche ohne Unterprogramm')
string1 = sprintf('Spannung unter optimalen Bedingungen: U_optim = %2.4f V', U_optim);
disp(string1);
string2 = sprintf('Gesamtstrom unter optimalen Bedingungen: %2.4f mA', j_optim);
disp(string2);
string3 = sprintf('Leistung unter optimalen Bedingungen: P_optim = %2.4f mW', -pmax);
disp(string3);
pmax
disp (' ')
