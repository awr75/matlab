% gain.m
% Gain in direkten Halbleitern für mehrere Elektronenkonzentrationen
% benutzt die Funktion rez_fermi.m

clear;
clf;
%****************************************
% Vorgabe der Substanz:
%****************************************
GaAs                     % Aufruf Substanzparameter
a = 3.95e4;              % Normierung für Absorptionskoeffizient in GaAs
mrel = 1/(1/me + 1/mh);  % reduzierte Masse

%****************************************
% Vorgabe der Teilchenkonzentrationen:
%****************************************
ne = 1e18:.5e18:5e18;
nh = ne;

%****************************************
% Rechnung:
%****************************************
jjmax = length(ne);
for jj=1:jjmax
   EFe = kT*rez_fermi(ne(jj)/Nc_0);   % Fermi-Energie der Elektronen
   EFh = kT*rez_fermi(nh(jj)/Nv_0);   % Fermi-Energie der Löcher

   dE = 0.01*kT;                      % Energieintervall
   Emax = 2*kT + max(EFe,EFh);        % Endwert für die Berechnung
   Erel = 0:dE:Emax; 

   iimax = length(Erel);
   for ii=1:iimax
      Ee = (mrel/me)*Erel(ii); Eh = (mrel/mh)*Erel(ii);
      fe = 1/(1+exp((Ee-EFe)/kT));     % Verteilungsfunktion der Elektronen
      fh = 1/(1+exp((Eh-EFh)/kT));     % Verteilungsfunktion der Löcher
      grel(ii) = sqrt(Erel(ii)) * (fe + fh - 1);
      g(ii) = grel(ii)*a;
   end
   E_opt = Erel + EG;
   
   %----------------------------------------
   % Plot:
   %----------------------------------------
   plot(E_opt,g);
   grid on; hold on;
end

%****************************************
% Beschriftung des Abbildung:
%****************************************
title('Gain in GaAs');
xlabel('E_o_p_t/eV'); ylabel('Gain/cm^-^1');
axis([EG EG+Emax -2000 max(g)]); 
str1 = ['n_e = ',num2str(ne(1)),' bis ',num2str(ne(jjmax)),'cm^-^3']; 
text(.93*max(EG+Emax), .6*max(g), str1); 
hold off;