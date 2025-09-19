% Programm leitf.m
% Darstellung der Leitfähigkeit der Majoritätsträger 
% über der Störstellenkonzentration im Silizium bei 300 K
% ruft mye(N,T) und myh(N,T) auf

konstanten;
T = 300;
%****************************
% Ausdruck Tabelle myh(N)
%****************************
N=[1e14 2e14 5e14 1e15 2e15 5e15 1e16 2e16 5e16 1e17];
disp(' ***************************');
disp(' N       sigma in cm^2/Vs');
disp(' ***************************');
for i = 1:10
   sigma_h = q * N(i)*myh(N(i),T);
   string1 = sprintf(' %0.4g   %1.6g', N(i), sigma_h);
   disp(string1);
end

%****************************
% Ausdruck Tabelle N*mye(N)
%****************************
disp(' ***************************');
disp(' N       sigma in cm^2/Vs');
disp(' ***************************');

for i = 1:10
   sigma_e = q * N(i)*mye(N(i),T);
   string1 = sprintf(' %0.4g   %1.6g', N(i), sigma_e);
   disp(string1);
end

%****************************
% Plot
%****************************

Nu = 1e14; No = 1e19;			% Intervallgrenzen bei Plot

diff = log10(No) - log10(Nu);	% Intervall-Länge
interval = 1/(100*diff);		% 100 Schritte pro Dekade
N1log = [log10(Nu):interval:log10(No)]; 
N1 = 10.^(N1log);					% Zwischenwerte

imax = size(N1,2);
for i = 1:imax
   sigma_h(i) = q * N1(i).*myh(N1(i),T);
   sigma_e(i) = q * N1(i).*mye(N1(i),T);
end
loglog (N1, sigma_h, 'm', N1, sigma_e, 'b'); grid on;
title ('Leitfähigkeit der Majoritätsträger in Silizium (rot: Löcher, blau: Elektronen)');
xlabel ('N in cm^-^3'); ylabel ('sigma in cm^2/Vs');

