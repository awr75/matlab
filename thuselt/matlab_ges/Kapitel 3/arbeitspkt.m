% arbeitspkt.m
% Ermittlung des Arbeitspunkts einer Diode 
% (graphisch und iterativ)

clear;

% ************************
% Konstanten und Parameter
% ************************
konstanten

U0 = 0.3;      % Startwert für Iteration in Volt
tol = 1.0e-6;  % Toleranz der Spannungswerte bei Iteration in V
n = 1;         % Exponentialfaktor in Diodengleichung (zwischen 1 und 2)
Udc = 1.5;     % Klemmenspannung in V
R = 1.0e3;     % Ohmscher Widerstand in Ohm
js = 2e-10;    % Sättigungsstrom in A

% Wertebereich:
Umin = 0.25 ; Umax = .6;
U = Umin:0.001:Umax;

% ********************************************************
% Graphische Darstellung von Diodenstrom und Arbeitsgerade
% ********************************************************
j = js * (exp(U/(n*kT)) - 1);	% Diodenstrom
ia = (Udc - U)/R;             % Arbeitsgerade

plot(U,j,'k', U,ia,'m')
hold on;
axis([Umin, Umax, 0, max(ia)])
title('Ermittlung des Arbeitspunktes')
xlabel('Spannung (V)')
ylabel('Strom (A)')
text(U(200),ia(200),'   Arbeitsgerade')
   % U(200) und ia(200) definieren Koordinaten für Stringausgabe
text(U(100),j(100),'   Diodenkennlinie')

% ********************************************************
% Ermittlung des Schnittpunkts durch Iteration
% ********************************************************
jd(1) = js * (exp(U0/(n*kT)) - 1); Ud(1) = U0;  % Startwerte

i = 1;
Udiff = 1;
while Udiff > tol
   plot(Ud(i),jd(i),'ko')  % Darstellung der Iterationswerte in der Graphik
   text(Ud(i),jd(i),['  ', num2str(i)]) % Anzeige: Nummer des iterationsschritts
   jd(i+1) = (Udc - Ud(i))/R;
   Ud(i+1) = Ud(i) + n*kT*log(jd(i+1)/jd(i));
   Udiff = abs(Ud(i+1) - Ud(i));
   i = i+1;
end

% Arbeitspunkt der Diode (Udiode, jdiode)
Udiode = Ud(i)
jdiode = jd(i)

hold off;


