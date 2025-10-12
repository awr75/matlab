function sdr_gfsk_signal
% Beispiel fuer die Erzeugung eines GFSK-Signals
%
%------------------------------------------------
% (c) Eberhard Gamm (www.ibega.de),
%     LIKE (www.like.e-technik.uni-erlangen.de),
%     2013
%------------------------------------------------

close all;

% Modulationsindex
h = 0.5;
% BT-Produkt
BT = 1;
% Symboldauer
T_s = 1;
% Ueberabtastung
M = 8;
% Abtastrate
f_a = M / T_s;
% Abtastintervall
T_a = 1 / f_a;
% Shift
f_shift = h / T_s;
% Bandbreite des Gauss-Filters
B_g = BT / T_s;

% Binaersymbole als PRBS erzeugen
b = round( rand( 1, 10000) );
s = 2 * b - 1;

% Rechteck-Former = M-fache Wiederholung jedes Symbols
s_r = kron( s, ones( 1, M ) );

% Gauss-Filter berechnen
n   = floor( 0.5 * M / BT );
t   = ( -n : n ) * T_a;
g_g = sqrt( 2 * pi / log(2) ) * B_g * T_a * ...
      exp( -2 * ( pi * B_g * t ).^2 / log(2) );

% Gauss-Filterung
s_fm = conv( s_r, g_g );

% Basisbandsignal erzeugen
x = exp( 1i * pi * f_shift * T_a * cumsum( s_fm ) );

% Spektrum berechnen
[ p, f_norm ] = power_spectrum_density( x, f_a, M * 256 );

% pseudo-kontinuierliches Gauss-Filter
t_t   = 0.01 * ( -110 * n : 110 * n ) * T_a;
g_g_t = sqrt( 2 * pi / log(2) ) * B_g * T_a * ...
        exp( -2 * ( pi * B_g * t_t ).^2 / log(2) );

% Frequenzgang
[ G_g, f ] = freqz( g_g, 1, 256, f_a );
G_g = [ fliplr( G_g(2:end)' ) G_g' ];
f   = [ -fliplr( f(2:end)' ) f' ];

% idealer Frequenzgang
G_g_i = -3 * ( f / B_g ).^2;

figure(1);
plot(f_norm,p,'b-','Linewidth',1);
grid;
axis([min(f_norm) -min(f_norm) -80 -10]);
xlabel('T_s * f');
ylabel('S_x [dB]');
title(sprintf('Spektrum fuer BT = %g',BT));

figure(2);
plot(t/T_a,g_g,'bs','Linewidth',3,'Markersize',2);
hold on;
plot(t_t/T_a,g_g_t,'b--');
hold off;
grid;
axis([min(t_t/T_a) max(t_t/T_a) 0 0.4]);
xlabel('n');
ylabel('g_g');
title('Filterkoeffizienten');

figure(3);
plot(f,20*log10(abs(G_g)),'b-','Linewidth',2);
hold on;
plot(f,G_g_i,'r--','Linewidth',1);
hold off;
grid;
axis([min(f) max(f) -50 10]);
xlabel('T_a * f');
ylabel('|G_g|');
title('Frequenzgang');
legend('reales Filter','ideales Filter');
