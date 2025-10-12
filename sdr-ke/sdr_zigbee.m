function sdr_zigbee
% Beispiel zur Signalerzeugung bei ZigBee (IEEE 802.15.4)
%
%------------------------------------------------
% (c) Eberhard Gamm (www.ibega.de),
%     LIKE (www.like.e-technik.uni-erlangen.de),
%     2013
%------------------------------------------------

close all;

% Polynom x^4 + x^3 + 1 ohne konstanten Koeffizienten
p_seq = [ 1 1 0 0 ];
m_seq = length(p_seq);
SF    = 2^m_seq - 1;

% Vektor fuer Spreizcode anlegen
b_seq = zeros(1,SF);

% Register initialisieren
reg = [ 1 zeros( 1, m_seq - 1 ) ];

% Spreizcode berechnen
for i = SF : -1 : 1
    b_seq(i) = reg(end);
    reg = mod( [ 0 reg(1:end-1) ] + reg(end) * p_seq, 2 );
end

% Ueberabtastung fuer das Basisbandsignal
M = 4;

% Root Raised Cosine Filter berechnen
r = 1;
N = 17;
g = root_raised_cosine_filter( N, M, r );

% binaere Daten
b_d = round(rand(1,10000));

% Spreizung
b_1 = kron( b_d, ones( 1, SF ) );
b_2 = repmat( b_seq, 1, length( b_d ) );
b_s = mod( b_1 + b_2, 2 );

% BPSK-Mapper
s_s = 1 - 2 * b_s;

% Basisbandsignal bilden
x = conv( kron( s_s, [ M zeros( 1, M - 1 ) ] ), g );

% Spektrum berechnen
[ S_x, f_x ] = power_spectrum_density( x, 1.2, 256 );

% Rauschen addieren
l_x = length(x);
P_x = real( x * x' ) / l_x;
SNR = 6.3;
P_n = M * P_x / SNR;
n   = sqrt( P_n / 2 ) * ( randn( 1, l_x ) + 1i * randn( 1, l_x ) );

% Spektrum mit Rauschen berechnen
[ S_x_n, f_x_n ] = power_spectrum_density( x + n, 1.2, 256 );

% Root Raised Cosine Filterung im Empfaenger
x_r = conv( x, g );
n_r = conv( n, g );

% Abtastung der gespreizten Symbole
s_r = x_r( N : M : end - N );
s_n = n_r( N : M : end - N );

% Symbol-Rausch-Abstand SNR_r
SNR_r = s_r * s_r' / ( s_n * s_n' );
fprintf(1,'Symbol-Rausch-Abstand: SNR_r = %g = %g dB\n',SNR_r,10*log10(SNR_r));

% Spektren im Empfaenger
[ S_x_r, f_x_r ] = power_spectrum_density( x_r, 1.2, 256 );
[ S_n_r, f_n_r ] = power_spectrum_density( n_r, 1.2, 256 );

% Entspreizung
s_seq = 1 - 2 * b_seq;
h_seq = fliplr( conj( kron( s_seq, [ 1/SF zeros( 1, M - 1 ) ] ) ) );
x_d = conv( x_r, h_seq );
n_d = conv( n_r, h_seq );

% Symbolabtastung
s_d = x_d( N + M * SF - 1 : M * SF : end - M * SF );
s_n = n_d( N + M * SF - 1 : M * SF : end - M * SF );

% Symbol-Rausch-Abstand SNR_d
SNR_d = s_d * s_d' / ( s_n * s_n' );
fprintf(1,'Symbol-Rausch-Abstand: SNR_d = %g = %g dB\n',SNR_d,10*log10(SNR_d));

figure(1);
plot(0:N-1,g,'bs','Linewidth',3,'Markersize',3);
axis([0 N-1 -0.05 0.35]);
grid;
xlabel('n');
title('Root Raised Cosine Filter');

figure(2);
plot(f_x,S_x,'b-','Linewidth',1);
hold on;
plot(f_x_n,S_x_n,'r-','Linewidth',1);
hold off;
grid;
axis([-0.6 0.6 -80 -10]);
xlabel('f [MHz]');
title('Spektrum');
legend('Sender','Empfaengereingang','Location','SouthEast');

figure(3);
plot(f_x_r,S_x_r,'b-','Linewidth',1);
hold on;
plot(f_n_r,S_n_r,'r-','Linewidth',1);
hold off;
grid;
axis([-0.6 0.6 -80 -10]);
xlabel('f [MHz]');
title('Spektren im Empfaenger nach der RRC-Filterung');
legend('Signalanteil','Rauschanteil','Location','SouthEast');
