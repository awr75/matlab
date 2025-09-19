function varargout = f_myih (n, substanz, T, donorflag)
% Funktion varargout = f_myih(n, substanz, T, donorflag)
% Berechnung des störstellenbedingten Valenzbandbeitrags zur Gapshift 
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
if strcmp(substanz,'Si'); substanz = 'Silizium'; end
if strcmp(substanz,'Ge'); substanz = 'Germanium'; end

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
   x = mh/me;
else
	% Bohrradien und Rydberg bei Donatordotierung:
	Ryde = ED*1e3;             	% Elektronen-Rydberg in meV
	Rydh = EA*1e3;             	% Löcher-Rydberg in meV
	abe = aBe*1e2;                % Bohrradius des Elektrons in cm
	abh = aBh*1e2;                % Bohrradius des Lochs in cm
   Nc0 = Nc_0;                   % eff. Zustandsdichte im LB
   Nv0 = Nv_0;                   % eff. Zustandsdichte im VB
   nuee = nue_e;
   x = me/mh;
end

% Weitere Abkürzungen:
ninorm2 = exp(-EG/kT);  
   		      % ni normiert: ninorm = ni/sqrt(Nc_0*Nv_0)
kT1 = kB*T*1000;	% von hier ab kT in meV benötigt

%*********************************************************
% Bereichsgrenzen
%*********************************************************
% Bereichsgrenzen für ih

kTT_h = 0.61 * (nuee*x)^2 * Ryde; % Intersection line kTT_h (hohe/niedrige Temperaturen)
QT1 = 1 / (kT1/kTT_h+1); QT2 = 1 / (kTT_h/kT1+1); % Vorfaktoren mit kTT_h berechnen

% *******************************
% Berechnung der chem. Potentiale
% *******************************

% Grenzen zwischen den Bereichen
   n0_tilde = 4.6e-4 * nuee^4;
   % (Grenze zwischen TF screening und Debye-Screening bei hohen Konzentrationen)
	n1_tilde = 0.00124 * (kT1/Ryde)^2 / x^4;
   % (Grenze zwischen Debye screening und sw screening)
   n2_tilde = 0.062 * nuee * (kT1/Ryde)^1.5;
   % (Grenze zwischen Debye screening und TF screening)

% fitting coefficients
	alpha_0_h=0.76; alpha_0str_h=0.27; gamma_0_h=1/4;
	alpha_1_h=0.35; alpha_1str_h=5.6; gamma_1_h=2/3;
	alpha_2_h=0.8; alpha_2str_h=0.8;
   
   ne_tld = n * abe^3;
   Ni = n;
   Ni_tld = Ni * abe^3;
   
% Energien für die einzelnen Näherungen
   a = 0.992 * sqrt(Ryde/kT1) * nuee^(1/3) * sqrt(x) * ne_tld.^(1/6);
	myi_h_D = -2.51 * sqrt(Ryde/kT1) * Ni_tld ./ sqrt(ne_tld) * Ryde;
   myi_h_sw = -0.471 * Ni_tld ./ (x * ne_tld.^.75) * Ryde; % sw screening
   myi_h_TF = -6.33 * nuee^(-1/3) * (Ryde/kT1) .* J(a).* (Ni_tld ./ ne_tld.^(1/6)) * Ryde;
   
% Übergangsbereiche
   Q0 = (ne_tld/n0_tilde).^gamma_0_h;
   Q1 = (ne_tld/n1_tilde).^gamma_1_h; Q2 = ne_tld./n2_tilde;
   K01 = 1./(alpha_0_h.*Q0 + 1); K02 = 1./(alpha_0str_h./Q0 + 1);
   K11 = 1./(alpha_1_h.*Q1 + 1); K12 = 1./(alpha_1str_h./Q1 + 1);
   K21 = 1./(alpha_2_h.*Q2 + 1); K22 = 1./(alpha_2str_h./Q2 + 1);
   
% Approximationen
   myi_h_0 = myi_h_sw.*K01 + myi_h_TF.*K02; 
   myi_h_low = myi_h_D.*K11 + myi_h_0.*K12;
   myi_h_high = myi_h_D.*K21 + myi_h_TF.*K22;
   myi_h_appr = myi_h_low.*QT1 + myi_h_high.*QT2;
   
varargout {4} = myi_h_TF;
varargout {3} = myi_h_sw;
varargout {2} = myi_h_D;
varargout {1} = myi_h_appr;

%**********************
% Inline-Funktion J(a)
%**********************
function J = J(a)
	% Approximatinsformel
   J = 1./(1 + 1.2*a + 2*a.^2);
