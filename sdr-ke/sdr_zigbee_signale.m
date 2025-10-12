function sdr_zigbee_signale
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
M = 64;

% Root Raised Cosine Filter berechnen
r = 1;
N = 273;
g = root_raised_cosine_filter( N, M, r );

% binaere Daten
b_d = [ 1 1 0 0 1 1 0 1 0 0 0 1 1 0 ];

% Spreizung
b_1 = kron( b_d, ones( 1, SF ) );
b_2 = repmat( b_seq, 1, length( b_d ) );
b_s = mod( b_1 + b_2, 2 );

% BPSK-Mapper
s_s = 1 - 2 * b_s;

% Basisbandsignal bilden
x   = conv( kron( s_s, [ M zeros( 1, M - 1 ) ] ), g );
i   = ( length(x) - M ) / 2;
x_i = x( i - 2 * M * SF : i + 2 * M * SF );

% Root Raised Cosine Filterung im Empfaenger
x_r   = conv( x, g );
i     = ( length(x_r) - M ) / 2;
x_r_i = x_r( i - 2 * M * SF : i + 2 * M * SF );

% Entspreizung
s_seq = 1 - 2 * b_seq;
h_seq = fliplr( conj( kron( s_seq, [ 1/SF zeros( 1, M - 1 ) ] ) ) );
x_d   = conv( x_r, h_seq );
i     = floor( ( length(x_d) - M ) / 2 );
x_d_i = x_d( i - 2 * M * SF : i + 2 * M * SF );

figure(1);
plot((1:length(x_i))/M,x_i,'b-','Linewidth',1);
axis([0 length(x_i)/M -1.5 1.5]);
grid;
xlabel('t / T_s');
title('Basisbandsignal im Sender');

figure(2);
plot((1:length(x_r_i))/M,x_r_i,'b-','Linewidth',1);
axis([0 length(x_r_i)/M -1.5 1.5]);
grid;
xlabel('t / T_s');
title('Basisbandsignal im Empfaenger nach der RRC-Filterung');

figure(3);
plot((1:length(x_d_i))/M,x_d_i,'b-','Linewidth',1);
axis([0 length(x_d_i)/M -1.5 1.5]);
grid;
xlabel('t / T_s');
title('Basisbandsignal im Empfaenger nach der Entspreizung');
