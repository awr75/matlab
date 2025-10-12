function sdr_fsk_signal_manchester
% Beispiel fuer die Erzeugung eines FSK-Signals mit Manchester-Codierung
%
%------------------------------------------------
% (c) Eberhard Gamm (www.ibega.de),
%     LIKE (www.like.e-technik.uni-erlangen.de),
%     2013
%------------------------------------------------

close all;

% Symbolrate
f_s = 32768;
% Ueberabtastung
M = 16;
% Abtastrate
f_a = M * f_s;
% Abtastintervall
T_a = 1 / f_a;
% Shift
f_shift = 1e5;

% Binaersymbole als PRBS erzeugen
b_d = round( rand( 1, 10000) );
s_d = 2 * b_d - 1;

% Manchester-Codierung durch Sequenz-Spreizung
s_c = kron( s_d, [ 1 -1 ] );

% Rechteck-Former = M-fache Wiederholung jedes Symbols
s_r   = kron( s_d, ones( 1, M ) );
s_r_c = kron( s_c, ones( 1, M ) );

% Basisbandsignale erzeugen
x   = exp( 1i * pi * f_shift * T_a * cumsum( s_r ) );
x_c = exp( 1i * pi * f_shift * T_a * cumsum( s_r_c ) );

% Spektren berechnen
[ p,   f_norm   ] = power_spectrum_density( x,   f_a, M * 256 );
[ p_c, f_c_norm ] = power_spectrum_density( x_c, f_a, M * 256 );

figure(1);
plot(1e-3*f_norm,p,'b-','Linewidth',1);
hold on;
plot(1e-3*f_c_norm,p_c,'r-','Linewidth',1);
hold off;
grid;
axis([-250 250 -70 0]);
xlabel('f [kHz]');
ylabel('S_x [dB]');
title('Spektrum eines FSK-Signals ohne/mit Manchester-Codierung');
legend('ohne','mit');
