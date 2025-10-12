function daten_rauschleistungsdichte
% Rauschleistungsdichte einer Komponente mit thermischem und 1/f-Rauschen
%
%------------------------------------------------
% (c) Eberhard Gamm (www.ibega.de),
%     LIKE (www.like.e-technik.uni-erlangen.de),
%     2013
%------------------------------------------------

close all;

% Boltzmann-Konstante
k = 1.38e-23;

% Referenztemperatur
T = 290;

% thermische Rauschleistungsdichte
S_n_th = k * T;
S_n_th_dBm = 30 + 10 * log10( S_n_th );

% Frequenzachse
f = 10.^(1:0.02:6);

% 1/f-Grenzfrequenz
f_g_1f = 1000;

% 1/f-Rauschleistungssichte
S_n_1f = k * T * f_g_1f ./ f;
S_n_1f_dBm = 30 + 10 * log10( S_n_1f );

% Rauschleistungsdichte
S_n = S_n_th + S_n_1f;
S_n_dBm = 30 + 10 * log10( S_n );


figure(1);
plot(1e-3*f,S_n_dBm,'b-','Linewidth',2);
hold on;
plot(1e-3*f,S_n_th_dBm*ones(1,length(f)),'b--');
plot(1e-3*f,S_n_1f_dBm,'b--');
hold off;
grid;
axis([0 5 -180 -150]);
xlabel('f [kHz]');
ylabel('S_n [dBm/Hz]');
title('Rauschleistungsdichte');


figure(2);
semilogx(f,S_n_dBm,'b-','Linewidth',2);
hold on;
semilogx(f,S_n_th_dBm*ones(1,length(f)),'b--');
semilogx(f,S_n_1f_dBm,'b--');
hold off;
grid;
axis([min(f) max(f) -180 -150]);
xlabel('f [Hz]');
ylabel('S_n [dBm/Hz]');
title('Rauschleistungsdichte');
