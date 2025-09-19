% Programm "diffsp.m"
% Diffusionsspannung in Si, Ge, GaAs und GaP 
% an einem (p+/n)- bzw. (p/n+)-�bergang bei 300 K
% aufgetragen �ber der Dotierungskonzentration Ndot
% des schw�cher dotierten Gebiets 

clf
clear

% *******************************************
% Wahl des Dotierungsbereichs (1e14 bis 1e19)
% *******************************************
Ndot = logspace(14,19);

% *******************************************
% Wahl der Halbleitersubstanzen,
% f�r die Berechnung durchgef�hrt werden soll 
% *******************************************
material = {'Silizium'
            'Germanium'
            'GaAs'
            'GaP'};
   % Substanznamen werden als String array gespeichert

% *******************************************
% Wahl der Substanzen 
% *******************************************
for ii = 1:length(material)

   a=eval('material(ii)');
   eval(char(a));
      % Durch diese Konstruktion werden die einzelnen Elemente
      % des String arrays herausgel�st und die jeweiligen M-Files
      % aufgerufen, die die Substanzdaten laden
      % Beispiel: silizium macht alle Parameter des M-Files "Silizium-m" 
      % verf�gbar
   UD = 2*kT.*log(Ndot./ni_0);   
      % Berechnung der Diffusionsspannung f�r jeweilige Substanz
   semilogx (Ndot,UD,'-'); 
   if ii==1 % hier beim 1. Durchlauf Achsenbeschriftungen usw.
      hold on;
      axis ([1.0e14  1.0e19  0  2.3]);
      xlabel ('N_A or N_D (cm^-^3)')
      ylabel ('U_D (Volt)')
      title ('Diffusionsspannung')
   end
   % Beschriftung der einzelnen Kurven (Substanzdaten)    
      set (gca,'DefaultTextUnits','normalized')
      s1 = sprintf('%s, n_i = %1.4g cm^-^3', char(a), ni_0);  
      text (.20,UD(5)/2.3,s1);
end
hold off;


