function sdr_kanal_symbol_snr
% Symbol-Rausch-Leistung bei Pulsamplitudenmodulation am Beispiel von QPSK
%
%------------------------------------------------
% (c) Eberhard Gamm (www.ibega.de),
%     LIKE (www.like.e-technik.uni-erlangen.de),
%     2013
%------------------------------------------------

close all;

% QPSK-Alphabet
s_m = sqrt(0.5) * [ 1+1i -1+1i 1-1i -1-1i ];

% Binaerdaten fuer 10000 Symbole
b_d = round( rand( 1, 20000 ) );

% Indices berechnen
i_s_m = b_d(1:2:end) + 2 * b_d(2:2:end);

% Symbole erzeugen
s_d = s_m( i_s_m + 1 );

% Root Raised Cosine Filter
r = 0.5;
M = 4;
N = 23;
g = root_raised_cosine_filter( N, M, r );

% Sendesignal erzeugen
x = conv( kron( s_d, [ M zeros(1,M-1) ] ), g );

% Rauschen erzeugen
SNR   = 10;
l_x   = length( x );
P_x   = real( x * x' ) / l_x;
P_n_n = M * P_x / SNR;
n     = sqrt( P_n_n / 2 ) * ( randn( 1, l_x ) + 1i * randn( 1, l_x ) );

% getrennte Filterung von Nutzsignal und Rauschen im Empfaenger
x_r_x = conv( x, g );
x_r_n = conv( n, g );

% getrennte Abtastung von Nutzsymbolen und Rauschanteil
s_d_i = x_r_x( N : M : length( x_r_x ) - N );
s_n_i = x_r_n( N : M : length( x_r_n ) - N );

% Leistungen berechnen
P_x_r = real( x_r_x * x_r_x' ) / length( x_r_x );
P_n_r = real( x_r_n * x_r_n' ) / length( x_r_n );
P_s   = real( s_d_i * s_d_i' ) / length( s_d_i );
P_n   = real( s_n_i * s_n_i' ) / length( s_n_i );

fprintf(1,'Signalleistung P_x   = %g\n',P_x);
fprintf(1,'Rauschleistung P_n_n = %g\n',P_n_n);
fprintf(1,'Signalleistung P_x_r = %g\n',P_x_r);
fprintf(1,'Rauschleistung P_n_r = %g\n',P_n_r);
fprintf(1,'Symbolleistung P_s   = %g\n',P_s);
fprintf(1,'Rauschleistung P_n   = %g\n',P_n);
fprintf(1,'Symbol-Rausch-Abstand: SNR_d = P_s / P_n = %g\n',P_s/P_n);

% Spektren berechnen
[ S_x  , f_x   ] = power_spectrum_density( x, M );
[ S_n  , f_n   ] = power_spectrum_density( n, M );
[ S_x_r, f_x_r ] = power_spectrum_density( x_r_x, M );
[ S_n_r, f_n_r ] = power_spectrum_density( x_r_n, M );
[ S_d_i, f_d_i ] = power_spectrum_density( s_d_i, 1 );
[ S_n_i, f_n_i ] = power_spectrum_density( s_n_i, 1 );

% Korrekturfaktor
k_m = 10 * log10(M);

figure(1);
plot(f_x,S_x,'b-','Linewidth',1);
hold on;
plot(f_n,S_n,'r-','Linewidth',1);
hold off;
grid;
axis([-2 2 -80 -10]);
xlabel('f / f_s');
title('Signal- und Rauschspektrum am Eingang des Empfaengers');
legend('Signal','Rauschen');

figure(2);
plot(f_x_r,S_x_r,'b-','Linewidth',1);
hold on;
plot(f_n_r,S_n_r,'r-','Linewidth',1);
hold off;
grid;
axis([-2 2 -80 -10]);
xlabel('f / f_s');
title('Signal- und Rauschspektrum nach Filterung im Empfaenger');
legend('Signal','Rauschen');

figure(3);
plot(f_d_i,S_d_i+k_m,'b-','Linewidth',1);
hold on;
plot(f_n_i,S_n_i+k_m,'r-','Linewidth',1);
hold off;
grid;
axis([-2 2 -80 -10]);
xlabel('f / f_s');
title('Symbol- und Rauschspektrum nach Abtastung im Empfaenger');
legend('Signal','Rauschen');

figure(4);
plot(s_m,'b*');
grid;
axis(1.8*[-1 1 -1 1]);
axis equal;
set(gca,'PlotBoxAspectRatio',[1 1 1]);
set(gca,'XTick',-1.5:0.5:1.5);
set(gca,'YTick',-1.5:0.5:1.5);
title('Gesendete Symbole');

figure(5);
plot(s_d_i,'b*');
grid;
axis(1.8*[-1 1 -1 1]);
axis equal;
set(gca,'PlotBoxAspectRatio',[1 1 1]);
set(gca,'XTick',-1.5:0.5:1.5);
set(gca,'YTick',-1.5:0.5:1.5);
title('Empfangene Symbole ohne Rauschen');

figure(6);
plot(s_d_i+s_n_i,'b*');
grid;
axis(1.8*[-1 1 -1 1]);
axis equal;
set(gca,'PlotBoxAspectRatio',[1 1 1]);
set(gca,'XTick',-1.5:0.5:1.5);
set(gca,'YTick',-1.5:0.5:1.5);
title('Empfangene Symbole mit Rauschen (SNR = 10 dB)');
