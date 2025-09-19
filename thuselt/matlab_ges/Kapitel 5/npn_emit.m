% Programm npn_emit.m
% Berechnung der Kennlinien eines npn-Transistors in Emitterschaltung
% einschließlich Early-Effekt und Stoßionisation

disp(' ');
disp(' Berechnung der Kennlinien eines npn-Transistors in Emitterschaltung');
disp(' einschließlich Early-Effekt und Stoßionisation');
% (nach Pierret)
% Zur Bearbeitung wird das Unterprogramm npn0.m benötigt.
% UP npn0.m ruft seinerseits die Unterprogramme mye.m und myh.m 
        % sowie das UP Silizium.m für die Substanzdaten auf.
% Für die Berücksichtigung der Basisweitenveränderung durch den Early-Effekt
        % wird zusätzlich das Unterprogramm npn_early.m aufgerufen. 

clear
npn0 
% Im Unterprogramm npn0.m werden Konstanten, Materialparameter und Bauelementedaten 
        % festgelegt.

% ********************************************
% Berechnung der Ebers-Moll-Parameter (W = WB) 
% ********************************************
disp(' ');
disp(' Allgemeine Lösung (1) oder Näherung schmaler Basis? (2)...(Default: allgemein) :');
sb = input('   Bitte wählen... ');
if isempty(sb), sb = 1; end   

W = WB; 
a = W/LB;
rEB = DE*pE0*LB/(DB*nB0*LE);
rCB = DC*pC0*LB/(DB*nB0*LC);
if sb ==1
   % allgemeine Lösung
   fB = (DB/LB)*nB0*coth(a); 
   IES = q*A*((DE/LE)*pE0 + fB);    % Sperrstrom des Emitter-Basis-Übergangs bei UCB=0
   ICS = q*A*((DC/LC)*pC0 + fB);    % Sperrstrom des Kollektor-Basis-Übergangs bei UEB=0
   aV = 1 /(cosh(a)+rEB*sinh(a)); 
   aR = 1 /(cosh(a)+rCB*sinh(a)); 
else
   % Näherung schmaler Basis
   W = WB; 
   fB = (DB/W)*nB0;
   IES = q*A*((DE/LE)*pE0 + fB);    % Sperrstrom des Emitter-Basis-Übergangs bei UCB=0
   ICS = q*A*((DC/LC)*pC0 + fB);    % Sperrstrom des Kollektor-Basis-Übergangs bei UEB=0
   aV = 1 /(1+a*rEB);
   aR = 1 /(1+a*rCB);
end

% **********************************
% Bereichsgrenzen für die Spannungen
% **********************************
UbiE = kT*log(NE*NB/ni_0^2); % Diffusionsspannung des Emitter-Basis-Übergangs
UbiC = kT*log(NC*NB/ni_0^2); % Diffusionsspannung des Kollektor-Basis-Übergangs
                             % (wird nur beim Early-Effekt benötigt)

UCB_min = 1;      % Minimalwert für die Berechnung von UCB in Volt
UCB_max = 2;   	% Maximalwert
UCE_min = 1;      % Minimalwert für die Berechnung von UCE in Volt
UCE_max = 100; 	% Maximalwert
% Zur Veränderung der Material- und Bauelementeparameter
        % müssen die Daten in npn0 variiert werden.
close

UCB_max = 60*(NC/1.0e16).^(-3/4); 
m = 6; 
UCE_max = UCB_max*(1-aV).^(1/m);

% ***************************************
% Abfrage nach gewünschtem Kennlinienfeld
% ***************************************
disp('');
disp(' Gewünschtes Kennlinienfeld:');
disp('   Eingangskennlinien der Emitterschaltung (1),');
disp('   Ausgangskennlinien der Emitterschaltung (2)');
disp('   IC(IB)-Kennlinie in Emitterschaltung (3)');
disp('   UBE(UCE)-Kennlinie der Emitterschaltung / Parameter ist IB (4)');
c = input('   Bitte wählen... (Default:1)');
if isempty(c), c = 1; end   

j = input(' Zahl der Kurven pro Kennlinienfeld... (Default:6) ');
if isempty(j), j = 6; end   

bw = input(' mit Basisweitenmodulation? 1-Ja, 2-Nein...(Default: Ja) '); 
if isempty(bw), bw = 1; end   

ii = 2; 
if c == 2 & bw == 1, 
   ii=input(' mit Stoßionisation? 1-Ja, 2-Nein...(Default:Ja) '); 
	if isempty(ii), ii = 1; end   
end 


% *******************************************
% Rechnung
% *******************************************
for i = 1:j, 
   switch c
   % *************************************************
   % Fall (1): Eingangskennlinien der Emitterschaltung
   % *************************************************
	case 1 
	   UEC = (i-1)*5; 
  		UEB = 0:0.005:UbiE; 
   	jj = length(UEB); 
   	if bw == 1, 
     		UCB = UEB-UEC; 
     		npn_early 
      end   
   	IB0 = (1-aV).*IES+ (1-aR).*ICS; 
   	IB1 = (1-aV).*IES+ (1-aR).*ICS.*exp(-UEC/kT); 
   	IB =(IB1.*exp(UEB/kT)-IB0)*(1.0e6); 
 		% 1.0e6 zur Umrechnung Ampere in Mikroampere 
     	if i==j, 
         plot(UEB,IB); axis([0 UbiE -5 20]); grid; xlabel('U_E_B(V)'); ylabel ('I_B(mA)'); 
		   title('Eingangskennlinien in Emitterschaltung'); 
      else 
     	   plot(UEB,IB); 
   	end 
   
   % *************************************************
   % Fall (2): Ausgangskennlinien der Emitterschaltung
   % *************************************************
   case 2 
      Schrittweite = 50;	% in Mikroampere
      IB = (i-1) * Schrittweite * 1e-6; % in Ampere
   	UECA = 0:0.01:UCE_min; 
   	UECB = UCE_min:UCE_min/200:UCE_max; 
   	UEC = [UECA,UECB]; 
   	jj = length(UEC); 
	  	if bw == 1, 
         UEB = 0; 		
         % Emitter-Basis-Spannung << Emitter-Kollektor-Spannung 
     		UCB = UEB-UEC; 
     		npn_early
   	end 
   	if ii == 1,       % mit Stoßionisation
         M = 1.0./(1-(-UCB/UCB_max).^m); 
     		aV = M.*aV; 
   	end 
  		IB0 = (1-aV).*IES + (1-aR).*ICS; 
  		IB1 = (1-aV).*IES + (1-aR).*ICS.*exp(-UEC/kT); 
  		IC = ((aV.*IES-ICS.*exp(-UEC/kT)).*(IB+IB0)./IB1 + ICS - aV.*IES)*(1.0e3); 
      if i == j, 
   		jA = length(UECA); 
   		plot(UEC,IC); axis([0 UCE_max 0 1.5*IC(jA)]); 
   		grid; xlabel('U_E_C(V)'); ylabel('I_C(mA)'); 
	  		str4 = ['Parameter: I_B / Schrittweite = ',num2str(Schrittweite),' _/uA']; 
         text(0.26*UCE_max,1.1*IC(jA),str4); 
 		   title('Ausgangskennlinien in Emitterschaltung'); 
    	else 
     	   plot(UEC,IC); 
      end
   % *************************************************
   % Fall (3): IC(IB)-Kennlinie in Emitterschaltung
   % *************************************************
   case 3 
      Schrittweite = 5;
      UEC = (i-1) * Schrittweite; 
  		IBmax = 0.25e-3;   % maximaler Strom in Ampere
    	IB = 0 : IBmax/500 : IBmax ;
      
	  	if bw == 1, 
         UEB = 0; 		
         % Emitter-Basis-Spannung << Emitter-Kollektor-Spannung 
     		UCB = UEB-UEC; 
     		npn_early
   	end 
  		IB0 = (1-aV).*IES + (1-aR).*ICS; 
  		IB1 = (1-aV).*IES + (1-aR).*ICS.*exp(-UEC/kT); 
  		IC = ((aV.*IES-ICS.*exp(-UEC/kT)).*(IB+IB0)./IB1 + ICS - aV.*IES)*(1.0e3); 
      if i == j, 
			plot (IB,IC);
        	grid on; xlabel('I_B(mA)'); ylabel('I_C(mA)'); 
        	title('Stromverstärkung in Emitterschaltung');
        	str5 = ['Parameter: U_E_C / Schrittweite = ',num2str(Schrittweite),' V']; 
        	text(0.02*max(IB),0.93*max(IC),str5); 
   	else 
         plot (IB,IC);
      end
   % ********************************************************************
   % Fall (4): UBE(UCE)-Kennlinie der Emitterschaltung / Parameter ist IB
   % ********************************************************************
   case 4 
      Schrittweite = 50;	% in Mikroampere
      IB = (i-1) * Schrittweite * 1e-6; % in Ampere
   	UECA = 0:0.01:UCE_min; 
   	UECB = UCE_min:UCE_min/200:UCE_max; 
   	UEC = [UECA,UECB]; 
   	jj = length(UEC); 
	  	if bw == 1, 
         UEB = 0; 		
         % Emitter-Basis-Spannung << Emitter-Kollektor-Spannung 
     		UCB = UEB-UEC; 
     		npn_early
   	end 
  		IB0 = (1-aV).*IES + (1-aR).*ICS; 
  		IB1 = (1-aV).*IES + (1-aR).*ICS.*exp(-UEC/kT); 
  		expUEB = (IB+IB0)./IB1 ; 
      UEBx = kT*log(expUEB);
      if i == j, 
   		jA = length(UECA); 
   	  	plot(UEC,UEBx);  
   		grid; xlabel('U_E_C(V)'); ylabel('U_E_B(mA)'); 
	  		str6 = ['Parameter: I_B / Schrittweite = ',num2str(Schrittweite),' _/uA']; 
         text(0.26*UCE_max,0.5*max(UEBx),str6); 
 		   title('U_E_B(U_E_C)-Kennlinie der Emitterschaltung'); 
    	else 
     	   plot(UEC,UEBx);
  		end
	end 
hold on
end 
hold off 