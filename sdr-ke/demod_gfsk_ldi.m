function demod_gfsk_ldi
% LDI-Demodulation einer GFSK-Paketsendung
%
%------------------------------------------------
% (c) Eberhard Gamm (www.ibega.de),
%     LIKE (www.like.e-technik.uni-erlangen.de),
%     2013
%------------------------------------------------

close all;

% Signalparameter:
% Symbolrate
f_s = 1;
% Modulationsindex
h = 1;
% BT-Produkt
BT = 1;
% Ueberabtastfaktor
M = 8;
% Signal-Rausch-Abstand des Basisbandsignals
% innerhalb der Kanalbandbreite
SNR_x_db = 6;
% Frequenzoffset
f_off = 0;

% abhaengige Parameter:
% Shift
f_shift = h * f_s;
% Abtastrate
f_a = M * f_s;
% Kanalbandbreite
B_ch = f_s + f_shift;

% Praeambel
p_p = [ 1 0 1 0 0 ];
m_p = length(p_p);
M_p = 2^m_p - 1;
b_p = zeros( 1, M_p + 1 );
reg = ones( 1, m_p );
for i = 1 : M_p
    b_p(i) = reg(end);
    reg = mod( [ 0 reg(1:end-1) ] + reg(end) * p_p, 2 );
end

% zufaellige Nutzbits
n_bytes = 40;
n_bits  = 8 * n_bytes;
b_u = round( rand( 1, n_bits ) );
l_b = length(b_u);

% CRC-16:
% CRC-Polynom 0xBAAD = 1011 1010 1010 1101
%  OHNE die fuehrende Eins und MIT nachfolgender Eins
p_crc = [ 0 1 1  1 0 1 0  1 0 1 0  1 1 0 1  1 ];
l_crc = length(p_crc);
reg   = b_u( 1 : l_crc );
for i = 1 + l_crc : l_b
    reg = mod( [ reg(2:end) b_u(i) ] + reg(1) * p_crc, 2 );
end
for i = 1 : l_crc
    reg = mod( [ reg(2:end) 0 ] + reg(1) * p_crc, 2 );
end

% Datenbits
b_d = [ b_u reg ];

% Symbole: Praeambel + Daten
sym = 2 * [ b_p b_d ] - 1;

% Signal erzeugen
g = gauss_filter( BT, M, 21 );
s = conv( kron( sym, [ M zeros( 1, M-1 ) ] ), g );
x = exp( 1i * pi * f_shift / f_a * cumsum( s ) );

% Frequenzoffset erzeugen
x = x .* exp( 2i * pi * f_off / f_a * ( 1 : length(x) ) );

% Signal mit Rampe versehen und verlaengern
rmp = [ zeros( 1, 203 * M + 3 ), sqrt( ( 1 : 5 * M ) / ( 5 * M ) ) ];
x_n = [ x(1) * rmp * x(1), x, x(end) * fliplr(rmp) ];
l_x = length(x_n);

% Rauschen addieren
P_n_n = f_a / ( B_ch * 10^( SNR_x_db / 10 ) );
x_n = x_n + sqrt( P_n_n / 2 ) * ( randn(1,l_x) + 1i * randn(1,l_x) );

% Kanalfilter
h_ch = lowpass_filter( B_ch / f_a );
l_ch = length(h_ch);
x_r  = conv( x_n, h_ch );
x_r  = x_r( l_ch : end - l_ch + 1 );

% FM-Demodulation
dx_r = x_r( 2 : end ) .* conj( x_r( 1 : end-1 ) );
s_r = M / ( pi * h ) * angle( dx_r );

% T-Integrator
h_i = ones( 1, M ) / M;
s_i = conv( s_r, h_i );

t = ( 1 : length(s_i) ) / M;

figure(1);
plot(t,s_i,'b-');
grid;
axis([0 max(t) -3 3]);
xlabel('t / T_s');
title('Ausgangssignal des LDI-Demodulators (SNR = 6 dB)');
