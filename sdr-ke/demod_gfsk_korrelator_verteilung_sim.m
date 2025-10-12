function datei = demod_gfsk_korrelator_verteilung_sim(Es_N0_dB)
% Verteilungsdichte des Korrelatormaximums bei
% GFSK-Praeambeldetektion simulieren
%
%------------------------------------------------
% (c) Eberhard Gamm (www.ibega.de),
%     LIKE (www.like.e-technik.uni-erlangen.de),
%     2013
%------------------------------------------------

datei = sprintf('demod_gfsk_korrelator_verteilung_%02d.mat',Es_N0_dB);
if exist( datei, 'file' )
    return;
end

% Simulationsparameter:
% Anzahl
sim_len = 1e6;

% Signalparameter:
% Modulationsindex
h = 1;
% Ueberabtastfaktor
M = 8;
% BT-Produkt
BT = 1;

% Praeambel
p_p = [ 1 0 1 0 0 ];
m_p = length(p_p);
M_p = 2^m_p - 1;
n_p = M_p + 1;
b_p = zeros( 1, n_p );
reg = ones( 1, m_p );
for i = 1 : M_p
    b_p(i) = reg(end);
    reg = mod( [ 0 reg(1:end-1) ] + reg(end) * p_p, 2 );
end
% Daten: Praeambel + 10 zufaellige Bits
b_d = [ b_p round( rand( 1, 10 ) ) ];
% Symbole erzeugen
sym = 2 * b_d - 1;
% Gauss-Filter
l_g = 21;
g = gauss_filter( BT, M, l_g );
% Kanalfilter
h_ch = lowpass_filter( ( 1 + h ) / M );
% Mittelungsfilter
h_i = ones( 1, M ) / M;
% Matched Filter
h_m = fliplr( kron( 2 * b_p - 1, [ 1 zeros( 1, M - 1 ) ] ) );
h_m = h_m( M : end );
% Filter fuer Mittelwert und Energie
h_s = abs( h_m );
% Signal erzeugen
s = conv( kron( sym, [ M zeros( 1, M-1 ) ] ), g );
x = exp( 1i * pi * h / M * cumsum( s ) );
% Signal mit Rampe versehen und verlaengern
rmp = [ zeros( 1, 13 * M + 4 ), sqrt( ( 1 : 5 * M ) / ( 5 * M ) ) ];
x_t = [ rmp * x(1), x, x(end) * fliplr(rmp) ];
l_x = length(x_t);
% Skalierungsfaktor fuer Rauschen
P_n_n = M * 10^( - Es_N0_dB / 10 );
k_n   = sqrt( P_n_n / 2 );

% Ergebnisvektoren:
% Detektionsmaximum
E_m   = zeros( 1, sim_len );
E_m_e = zeros( 1, sim_len );
% Position des Maximums im Bereich 1...4
i_m   = zeros( 1, sim_len );
i_m_e = zeros( 1, sim_len );

fprintf( 1, 'Simuliere Es/N0 = %d dB ...', Es_N0_dB );
t = clock;
for i = 1 : sim_len

    % Rauschen addieren
    x_n = x_t + k_n * ( randn(1,l_x) + 1i * randn(1,l_x) );
    % Kanalfilter
    x_r  = conv( x_n, h_ch );
    % FM-Demodulation
    dx_r = x_r( 2 : end ) .* conj( x_r( 1 : end-1 ) );
    s_r  = M / ( pi * h ) * angle( dx_r );
    % Mittelungsfilterung
    s_i = conv( s_r, h_i );
    % Korrelator
    c_m   = conv( s_i, h_m );
    c_s   = conv( s_i, h_s );
    c_e   = conv( s_i.^2, h_s );
    c_m_e = 2 * c_m - c_e + c_s.^2 / n_p;
    % Auswertung
    [ E_m(i),   i_m(i) ]   = max( c_m( 61 * M : 61 * M + 3 ) );
    [ E_m_e(i), i_m_e(i) ] = max( c_m_e( 61 * M : 61 * M + 3 ) );

end
fprintf( 1, ' Dauer: %g\n', etime( clock, t ) );

% Histogramme der Detektionsmaxima berechnen
E_m_min = floor( min( E_m ) );
E_m_max = ceil( max( E_m ) );
bin = 0.05;
[ y_m, x_m ] = hist( E_m , E_m_min : bin : E_m_max );
y_m = y_m / ( bin * length(E_m) );
E_m_e_min = floor( min( E_m_e ) );
E_m_e_max = ceil( max( E_m_e ) );
bin = 0.05;
[ y_m_e, x_m_e ] = hist( E_m_e , E_m_e_min : bin : E_m_e_max );
y_m_e = y_m_e / ( bin * length(E_m_e) );

% Timing-Jitter berechnen
sigma_m   = sqrt( sum( ( i_m - 2.5 ).^2 ) / length(i_m) ) / M;
sigma_m_e = sqrt( sum( ( i_m - 2.5 ).^2 ) / length(i_m) ) / M;

save(datei,'Es_N0_dB','x_m','y_m','x_m_e','y_m_e','sigma_m','sigma_m_e');
