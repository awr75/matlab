function varargout = f_myie (n, substanz, T, donorflag)
% Funktion varargout = f_myie(n, substanz, T, donorflag)
% Berechnung des störstellenbedingten Leitungsbandbeitrags zur Gapshift 
% in Abhängigkeit von der Dotierung und der Temperatur
%
% Quelle: Thuselt, Rösler, phys.stat.sol. (b) 130, K139 (1985)
%
% - n ist die Elektronenkonzentration
% - substanz ist das m-File des Halbleitermaterials, in Hochkomma eingeschlossen
%     (Default: 'Silizium')
% - Wenn donorflag = 1, dann Elektronen und Löcher vertauscht, also Akzeptordotierung
%     Dotierung mit Donatoren angenommen, dadurch Elektronendichte vorgegeben
%     Löcherdichte wird nach MWG berechnet
%     In allen anderen Fällen Donatordotierung angenommen (Default) 
%       donorflag kann für Donatordotierung auch weggelassen werden
% - T ist die abolute Temperatur (Default: 300 K)
%
% Wenn Akzeptordotierung vorgegeben (p-Material) (donatorflag = 1),
%       dann wird vertauscht
%       Ryde <-> Rydh
%       abe <-> abh

%*********************************************************

% Allgemeines
if nargin < 4, donorflag = 0; end
if nargin < 3, T = 300; end
if nargin < 2, substanz = 'Silizium'; end
if strcmpi(substanz,'Si'); substanz = 'Silizium'; end
if strcmpi(substanz,'Ge'); substanz = 'Germanium'; end

n = n(:)';
%***********************************************
% Aufruf Halbleitermaterial -> Substanzparameter
%***********************************************
eval(substanz);
% Hieraus resultieren:
% Nc_0 = eff. Zustandsdichte im LB
% Nv_0 = eff. Zustandsdichte im VB
% me = eff. Masse der Majoritätsträger (Elektronen)
% mh = eff. der Minoritätsträger (Löcher)
% nue_e = Tälerzahl (im Valenzband =1)

if donorflag == 1
   % Bohrradien und Rydberg bei Akzeptordotierung:
	Ryde = EA*1e3;             	% Elektronen-Rydberg in meV
	Rydh = ED*1e3;             	% Löcher-Rydberg in meV
	abe = aBh*1e2;                % Bohrradius des Elektrons in cm
	abh = aBe*1e2;                % Bohrradius des Lochs in cm
   Nc0 = Nv_0;                   % eff. Zustandsdichte im LB
   Nv0 = Nc_0;                   % eff. Zustandsdichte im VB
   nuee = 1;							% keine Vieltalstruktur im Valenzband
else
	% Bohrradien und Rydberg bei Donatordotierung:
	Ryde = ED*1e3;             	% Elektronen-Rydberg in meV
	Rydh = EA*1e3;             	% Löcher-Rydberg in meV
	abe = aBe*1e2;                % Bohrradius des Elektrons in cm
	abh = aBh*1e2;                % Bohrradius des Lochs in cm
   Nc0 = Nc_0;                   % eff. Zustandsdichte im LB
   Nv0 = Nv_0;                   % eff. Zustandsdichte im VB
   nuee = nue_e;	   
end

% Weitere Abkürzungen:
ninorm2 = exp(-EG/kT);  
   		      % ni normiert: ninorm = ni/sqrt(Nc_0*Nv_0)
kT1 = kB*T*1000;	% von hier ab kT in meV benötigt

%*********************************************************
% Bereichsgrenzen
%*********************************************************
% Bereichsgrenzen für ie

kTT_e = 3.48 * nuee^2 * Ryde; % Intersection line kTT_e (hohe/niedrige Temperaturen)
QT1 = 1 / (kT1/kTT_e+1); QT2 = 1 / (kTT_e/kT1+1); % Vorfaktoren mit kTT_e berechnen

% *******************************
% Berechnung der chem. Potentiale
% *******************************

% Grenzen zwischen den Bereichen
   n0_tilde = 0.015 * nuee^4;
   % (Grenze zwischen TF screening und Debye-Screening bei hohen Konzentrationen)
	n1_tilde = 0.00124 * (kT1/Ryde)^2;
   % (Grenze zwischen Debye screening und sw screening)
   n2_tilde = 0.0023 * nuee * (kT1/Ryde)^1.5;
   % (Grenze zwischen Debye screening und TF screening)

% fitting coefficients
	alpha_0_e=1.4; alpha_0str_e=1.4; gamma_0_e=2/3;
	alpha_1_e=0.35; alpha_1str_e=5.6; gamma_1_e=2/3;
	alpha_2_e=1.2; alpha_2str_e=1.2;
   
   ne_tld = n * abe^3;
   Ni = n;
   Ni_tld = Ni * abe^3;
   
% Energien für die einzelnen Näherungen
   myi_e_D = -2.51 * sqrt(Ryde/kT1) * Ni_tld ./ sqrt(ne_tld) * Ryde;
   myi_e_sw = -0.471 * Ni_tld ./ ne_tld.^.75 * Ryde; % sw screening
   myi_e_TF = -0.331 * nuee^(1/3) * Ni_tld ./ ne_tld.^(5/6) * Ryde;
   
% Übergangsbereiche
   Q0 = (ne_tld/n0_tilde).^gamma_0_e;
   Q1 = (ne_tld/n1_tilde).^gamma_1_e; Q2 = ne_tld./n2_tilde;
   K01 = 1./(alpha_0_e.*Q0 + 1); K02 = 1./(alpha_0str_e./Q0 + 1);
   K11 = 1./(alpha_1_e.*Q1 + 1); K12 = 1./(alpha_1str_e./Q1 + 1);
   K21 = 1./(alpha_2_e.*Q2 + 1); K22 = 1./(alpha_2str_e./Q2 + 1);
   
% Approximationen
   myi_e_0 = myi_e_sw.*K01 + myi_e_TF.*K02; 
   myi_e_low = myi_e_D.*K11 + myi_e_0.*K12;
   myi_e_high = myi_e_D.*K21 + myi_e_TF.*K22;
   myi_e_appr = myi_e_low.*QT1 + myi_e_high.*QT2;
      
% *******************************
% Ergebnisse
% *******************************
varargout {4} = myi_e_TF;
varargout {3} = myi_e_sw;
varargout {2} = myi_e_D;
varargout {1} = myi_e_appr;