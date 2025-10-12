function daten_inband_dynamik
% Beispiel zum Inband-Dynamikbereich
%
%------------------------------------------------
% (c) Eberhard Gamm (www.ibega.de),
%     LIKE (www.like.e-technik.uni-erlangen.de),
%     2013
%------------------------------------------------

close all;

% Daten des Empfaengers:
% Eingangs-Interceptpunkt
iip3_dbm = 0;
iip3 = 10^( ( iip3_dbm - 10 ) / 20 );
c3 = 4 / ( 3 * iip3^2 );
% Rauschzahl
f_db = 10;
f = 10^( f_db / 10 );

% minimales SNR
snr_min_db = 10;
% Symbolrate
fs = 2.5e5;
% Abtastrate
fa = 64 * fs;
% Kanalabstand
k = 4e5;

% Berechnung des IDR
idr_db = 2/3 * ( 174 + iip3_dbm - f_db - 10 * log10( fs ) ) ...
         - snr_min_db - 3;
fprintf( 1, 'Inband-Dynamikbereich: IDR = %4.1f dB \n', idr_db );

% vorgegebene Leistungen in dBm
nr = 3;
switch nr,
    case 1,
        p_1_dbm = -50;
        p_r_dbm = -100;
    case 2,
        p_1_dbm = -25;
        p_r_dbm = -66;
    case 3,
        p_1_dbm = -36.5;
        p_r_dbm = -97;
    otherwise,
        error('Fehler');
end

% 3 QPSK-Signale:
% Datenbits
b = round( rand( 3, 2000 ) );
% Symbole
s_m = 0.707 * [ 1+j -1+j 1-j -1-j ];
s = s_m( 1 + b(:,1:2:end) + 2 * b(:,2:2:end) );
% Basisbandsignal mit T/4 Abtastung
r = 0.5;
g = root_raised_cosine_filter( 23, 4, r );
x1 = conv( kron( s(1,:), [ 4 0 0 0 ] ), g );
x2 = conv( kron( s(2,:), [ 4 0 0 0 ] ), g );
x3 = conv( kron( s(3,:), [ 4 0 0 0 ] ), g );

% Ueberabtastung auf T/64
h = lowpass_filter( 0.8 * ( 1 + r ) / 64 );
x1 = conv( kron( x1, [ 16 zeros(1,15) ] ), h );
x2 = conv( kron( x2, [ 16 zeros(1,15) ] ), h );
x3 = conv( kron( x3, [ 16 zeros(1,15) ] ), h );

% Laenge der Signale
lx = length(x1);

% I/Q-Modulation der Signale auf benachbarte Kanaele
x1 = real( x1 .* exp( j * 2 * pi * (1:lx) * 4 * k / fa ) );
x2 = real( x2 .* exp( j * 2 * pi * (1:lx) * 5 * k / fa ) );
x3 = real( x3 .* exp( j * 2 * pi * (1:lx) * 3 * k / fa ) );

% Umskalierung auf vorgegebene Leistungen:
% Wellenwiderstand
z_l = 50;
% vorgegebene Leistungen in Watt
p_1 = 10^( ( p_1_dbm - 30 ) / 10 );
p_r = 10^( ( p_r_dbm - 30 ) / 10 );
% Leistung der erzeugten Signale
px = x1 * x1' / ( z_l * length(x1) );
% Umskalierung und Addition der Signale
x_hf = sqrt( p_1 / px ) * ( x1 + x2 ) + sqrt( p_r / px ) * x3;

% Rauschen des Empfaengers
pn = 1e-19 * fa * f;
x_hf = x_hf + sqrt( pn ) * randn( 1, lx );

% Intermodulation 3.Ordnung
x_hf = x_hf + c3 * x_hf.^3;

% I/Q-Demodulation
h = lowpass_filter( 0.2 );
m = exp( -j * 2 * pi * (1:lx) * 4.5 * k / fa );
x = conv( x_hf .* m, h );

% Unterabtastung auf T/16
x = x( 1 : 4 : end );
% Abtastrate anpassen
fa = fa / 4;

% Spektren berechnen
n_fft = 1024;
[ s_x, f ] = power_spectrum_density( x, fa, n_fft );

% Umrechnung der Spektren in dBm/Hz:
% Rauschbandbreite
w = blackman_window( n_fft );
nbw = fa * sum( w * w.' ) / sum( w )^2;
nbw_db = 10 * log10( nbw );
% Korrekturwert fuer die Umrechnung in dBm
c1_db = 30 - 10 * log10( z_l );
% Korrekturwert fuer den Verlust durch die I/Q-Demodulation
c2_db = 3;
% Summe der Korrekturwerte
c_db = c1_db + c2_db - nbw_db;
% Umrechnung
s_x = s_x + c_db;

figure(1);
plot(1e-6*f,s_x,'b-','Linewidth',1);
grid;
axis([1e-6*k*[-2 2] -180 -60]);
xlabel('f [MHz]');
ylabel('S [dBm/Hz]');
title('Spektrum in dBm/Hz');
