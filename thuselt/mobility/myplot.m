% Programm myplot.m
% Tabelle und graphische Darstellung der Beweglichkeiten
% im Silizium in Abhängigkeit von der Störstellenkonzentration
% bei 300 K
% ruft mye.m und myh.m auf

clf;clear;
T = 300;
%****************************
% Ausdruck Tabelle myh(N)
%****************************
N=[1e14 2e14 5e14 1e15 2e15 5e15 1e16 2e16 5e16 1e17 2e17 5e17 1e18];
disp(' ***************************');
disp(' N       myh');
disp(' ***************************');
for i = 1:length(N)
   ah = myh(N(i),T);
   string1 = sprintf('%0.4g   %4.0f', N(i), ah);
   disp(string1);
end

%****************************
% Ausdruck Tabelle mye(N)
%****************************
disp(' ***************************');
disp(' N       mye');
disp(' ***************************');

for i = 1:1:length(N)
   ae = mye(N(i),T);
   string1 = sprintf('%0.4g   %4.0f', N(i), ae);
   disp(string1);
end

%****************************
% Plot
%****************************

Nu = 1e14; No = 1e19;			% Intervallgrenzen bei Plot

diff = log10(No) - log10(Nu);	% Intervall-Länge
interval = 1/(5*diff);		   % Zahl der Schritte pro Dekade
N1log = [log10(Nu):interval:log10(No)]; 
N1 = 10.^(N1log);					% Zwischenwerte

imax = size(N1,2);
for i = 1:imax
   my_e(i) = mye(N1(i),T);
   my_h(i) = myh(N1(i),T);
end
loglog (N1, my_h, 'r', N1, my_e, 'b'); grid;
title ('Beweglichkeiten in Silizium (rot: Löcher, blau: Elektronen)');
xlabel ('N in cm^-^3'); ylabel ('my in cm^2/Vs');

