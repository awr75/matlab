% gain0.m
% Gain in direkten Halbleitern für eine Elektronenkonzentration
% benötigt die Funktion rez_fermi.m

clear;
clf;
%****************************************
% Vorgabe der Substanz:
%****************************************
GaAs        % Aufruf Substanzparameter. gaAs als Beispielsubstanz
mrel = 1/(1/me + 1/mh);  % reduzierte Masse

%****************************************
% Vorgabe der Teilchenkonzentrationen:
%****************************************
ne = 2e18;
nh = ne;

%****************************************
% Rechnung:
%****************************************
EFe = kT*rez_fermi(ne/Nc_0);  % Fermi-Energie der Elektronen
EFh = kT*rez_fermi(nh/Nv_0);  % Fermi-Energie der Löcher

dE = 0.01*kT;                 % Energieintervall
Emax = 0*kT + max(EFe,EFh);   % Endwert für die Berechnung
Erel = 0:dE:Emax;

iimax = length(Erel);
for ii=1:iimax
   Ee = (mrel/me)*Erel(ii); Eh = (mrel/mh)*Erel(ii);
   f_e = 1/(1+exp((Ee-EFe)/kT));     % Verteilungsfunktion der Elektronen
   f_h = 1/(1+exp((Eh-EFh)/kT));     % Verteilungsfunktion der Löcher
   g(ii) = sqrt(Erel(ii)) * (f_e + f_h - 1);
end
E_opt = Erel + EG;

%****************************************
% Plot:
%****************************************
plot(E_opt,g);
grid on;
title('Gain in GaAs');
xlabel('E_o_p_t/eV'); ylabel('Gain/rel. Einheiten');
str1 = ['n_e = ',num2str(ne),' cm^-^3']; 
text(.7*E_opt(iimax), .6*max(g), str1); 
