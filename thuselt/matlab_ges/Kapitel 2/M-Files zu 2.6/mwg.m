% Programm mwg.m
% Massenwirkungsgesetz mit Berücksichtigung der Entartung
%*********************************************************
% berechnet die relative Konzentration von Löchern p/NV
% in Abhängigkeit von der Elektronenkonzentration
% x-Achse der Graphik entweder n/NC (normiert) oder n in cm^-3
% (Ändern der Ausgabe durch "Auskommentieren" des Plot-Befehls)
% ohne xci

clf;
Silizium;

N_max = Nc_0; %falls die Elektronen Majoritätsträger sind
    % sonst N_max = Nv_0;

%*******************
% Bereichsgrenzen
%*******************
xmin = 1e-10; xmax = 10; 	
	% Bereich der x-Werte (normierte Konzentrationen) der Majoritätsträger
   % (Elektronen)
	% bezogen auf Nc:  x = n/Nc
midpoints = 1201;
logx = linspace(log10(xmin),log10(xmax),midpoints);

%*******************
%Rechnung   
%*******************
for ii = 1 : midpoints
	x(ii) = 10^(logx(ii));
	u(ii) = rez_fermi(x(ii));
     % Lage des Fermi-Niveaus bezüglich LB-Rand
	exponent = -u(ii) + log(x(ii));
     % Lage des Fermi-Niveaus bezüglich VB-Rand
   prel(ii) = exp(exponent);
     % relative Konzentration der Löcher p/p0
end

%*******************
% Plots
%*******************
semilogx(x,prel,'r'); xlabel ('x = n/N_max'); grid;
%loglog(x,prel,'r'); xlabel ('x = n/N_max'); grid;

semilogx(x*N_max,prel,'r'); xlabel ('n / cm^-^3'); grid; 
ylabel ('p_r_e_l = p/p_0 ');
legend ('Abweichung der Löcherkonzentration vom MB-Fall', 0 );
title ('MWG');





