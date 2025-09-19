% Programm intrins_temp.m
% Zur Nullstellensuche
% der Differenz zwischen intrinsischer Ladungsträgerkonzentration ni(T)
% und Störstellenkonzentration ND
% - ruft Funktion ni(T,ND) auf; dort HL-Typ einstellen!
% - ni(T,ND)ruft ggf. Funktion Eg_Si(T) auf

% Rechenparameter
options = optimset;
%options.Display = 'iter';		% mit Anzeige von Zwischenwerten bei der Iteration
options.Display = 'off';		% ohne Anzeige von Zwischenwerten bei der Iteration

disp(' ');
disp('Eingabe der Donatorkonzentration');
ND = input('   ND = ');

T0 = 600;                     % Startwert 600 K
Ti = fzero('ni',T0,options,ND)