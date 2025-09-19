% Programm solar_leistung_2.m
% Berechnung der maximalen Leistung einer Si-Solarzelle
% durch Minimierung als Funktion von U
% benötigt das Funktionsprogramm p.m für die Leistung p

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

UD = 0.85;               % Diffusionsspannung
U = 0:.01: UD;           % Bereich der angelegten Spannung (in Volt)
js = 2.49e-8;            % Sättigungsstrom
jopt = -20;              % Photostrom in mA pro cm^2

% ******************************
% Berechnung des Gesamtstroms
% ******************************
j =  jopt + js * (exp(U/kT) - 1);	    % Gesamtstrom
U0 = fminbnd('p', 0.2, UD,[],jopt,js);   
     % Berechnung der Spannung, für die die Leistung maximal
     % (hier wegen Vorzeichens minimal) wird 
     % Matrix [0] bedeutet: keine Zwischenwerte ausgeben
j0 = jopt + js .* (exp(U0/kT) - 1);     % zugehöriger Strom
p0 = U0*j0;                             % zugehörige Leistung

% ******************************
% Ausgabe der Ergebnisse
% ******************************
disp ('Ergebnis der direkten Minimumsuche mit Unterprogramm')
string1 = sprintf('Spannung unter optimalen Bedingungen: U_optim = %2.4f V', U0);
disp(string1);
string2 = sprintf('Gesamtstrom unter optimalen Bedingungen: %2.4f mA', j0);
disp(string2);
string3 = sprintf('Leistung unter optimalen Bedingungen: P_optim = %2.4f mW', -p0);
disp(string3);
disp (' ')
disp (' ')
