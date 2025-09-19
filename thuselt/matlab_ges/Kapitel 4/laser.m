% laser.m
% Berechnung der Verlaufs n(J) und nph(J) bei einem Laser
% mit Auffinden der Laserschwelle

clear
clf
% ***********************************
% Parameter
% ***********************************
b_pn = 3e-6;         % Breite des pn-Übergangs in cm
tau_e = 1e-9;        % Elektronenlebensdauer in s
tau_p = 2.56e-12;    % Photonenlebensdauer in s
a = 1/tau_e;
b = 1/tau_p;
B = 3e-7;            % Rate der stim. Emission in cm^3 s^-1
C = 2.65e6;          % Rate der strahlenden Emission in s^-1 (C = 1/tau_r)
konstanten;          % Laden von Parameterdaten, hier: Elementarladung q

% ***********************************
% Bereich für Stromdichte
% ***********************************

J = 0:1000;          % Stromdichte in A/cm^2
je = J/q;            % Stromdichte in cm^-2 s^-1
je_b = je/b_pn;		% Stromdichte, dividiert durch Breite des pn-Übergangs
							% in cm^-3 s^-1
iimax = length(J);

% ***********************************
% Spezielle Werte
% ***********************************
js_b = a*b/B;        % Schwellstromdichte, dividiert durch Breite des pn-Übergangs
							% in cm^-3 s^-1
js = js_b * b_pn;    % Schwellstromdichte in cm^-2 s^-1
Js = js*q;           % Schwellstromdichte in A/cm^2
ns = b/B;            % Sättigungsdichte der Elektronen in cm^-2
% ns = js_b * tau_e;   % alternative Berechnung

% ***********************************
% Lineare Näherung
% ***********************************
for ii = 1:iimax
   if je(ii) < js
      n1(ii) = je_b(ii)*tau_e;
      p1(ii) = je_b(ii)*C*tau_e*tau_p;
      jj =ii;        % letztes ii vor dem Knick
   else
      n1(ii) = ns;
      p1(ii) = (je_b(ii)-js_b)*tau_p;
   end
end

subplot(2,1,1); plot(J,n1); grid on; hold on;
ylabel('Elektronendichte n/cm^-^3');
str1 = ['Schwellstromdichte J_s = ',num2str(Js),' Acm^-^2']; 
str2 = sprintf('Sättigungsdichte n_s = %2.4e cm^-^3',ns); 
text(0.7*Js, 0.6*ns, str1); 
text(0.7*Js, 0.4*ns, str2); 
subplot(2,1,2); plot(J,p1), grid on; hold on;
xlabel ('Stromdichte J /Acm^-^2'); ylabel('Photonendichte n_p_h/cm^-^3');

% ***********************************
% Exakte Rechnung
% ***********************************
% Quadratische Gleichung für n und nph
N_n = a*B - B*C;
N_p = B*b;
for ii = 1:iimax
   P_n = (a*b + je_b(ii)*B)/N_n;
   Q_n = je_b(ii)*b/N_n;
   n(ii) = .5*P_n - sqrt(.25*P_n^2 - Q_n); 
   P_p = (a*b - je_b(ii)*B)/N_p;
   Q_p = je_b(ii)*C/N_p;
   nph(ii) = -.5*P_p + sqrt(.25*P_p^2 + Q_p);
end
subplot(2,1,1); plot(J,n,'r'); hold off;
subplot(2,1,2); plot(J,nph,'r'); hold off;

