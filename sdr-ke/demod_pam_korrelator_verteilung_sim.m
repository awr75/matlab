function datei = demod_pam_korrelator_verteilung_sim(Es_N0_dB)
% Verteilungsdichte der normierten Korrelation bei
% PAM-Praeambeldetektion simulieren
%
%------------------------------------------------
% (c) Eberhard Gamm (www.ibega.de),
%     LIKE (www.like.e-technik.uni-erlangen.de),
%     2013
%------------------------------------------------

datei = sprintf('demod_pam_korrelator_verteilung_%02d.mat',Es_N0_dB);
if exist( datei, 'file' )
    return;
end

% Simulationsparameter:
% Anzahl
sim_len = 1e6;

% Signalparameter:
% Rolloff-Faktor
r = 0.33;
% Ueberabtastfaktor
M = 8;

% Praeambel-Symbole
n_p = 31;
n   = 0 : n_p - 1;
s_p = exp( 1i * pi * n .* ( n + 1 ) / n_p );
% Root Raised Cosine Filter
l_g = 32;
g_s = root_raised_cosine_filter( l_g + 1, M, r );
g_r = root_raised_cosine_filter( l_g, M, r );
% Matched Filter
h_m = fliplr( conj( kron( s_p, [ 1 zeros( 1, M - 1 ) ] ) ) );
h_m = h_m( M : end );
% Ueberlappung in Symbolen
D = 4;
% Mittelungsfilter
N_r = ( n_p + 2 * D + 1 ) * M;
h_r = ones( 1, N_r ) / N_r;
% Skalierungsfaktor fuer Rauschen
P_n_n = M * 10^( - Es_N0_dB / 10 );
k_n   = sqrt( P_n_n / 2 );
% Symbol-Alphabet
s_m = [ 1 1i -1i -1 ];
% Spreizvektor fuer Modulation
spread = [ M zeros( 1, M - 1 ) ];

% Ergebnisvektoren:
% Detektionsmaximum
E_m_n = zeros( 1, sim_len );
% Position des Maximums im Bereich 1...4
i_m_n = zeros( 1, sim_len );

fprintf( 1, 'Simuliere Es/N0 = %d dB ...', Es_N0_dB );
t = clock;
for i = 1 : sim_len

    % Symbole
    i_s = floor( 3.99 * rand( 1, 8 ) );
    s   = [ s_p s_m( i_s + 1 ) ];
    l_s = length(s);
    % absolute Symbole
    s_a = ones( 1, l_s + 1 );
    for k = 1 : l_s
        s_a(k+1) = s_a(k) * s(k);
    end
    % Symbole + Vor-/Nachlauf
    s_a_v = [ zeros( 1, 8 ) s_a zeros( 1, 8 ) ];
    % Modulation
    x = conv( kron( s_a_v, spread ), g_s );
    % Rauschen addieren 
    l_x = length(x);
    x_n = x + k_n * ( randn(1,l_x) + 1i * randn(1,l_x) );
    % Root Raised Cosine Filter
    x_r  = conv( x_n, g_r );
    % Differenzsignal
    x_d = x_r .* conj( [ zeros( 1, M ) x_r( 1 : end - M ) ] );
    % Korrelator
    c_m = filter( h_m, 1, x_d );
    % Leistung berechnen
    p_r = filter( h_r, 1, abs(x_r).^2 );
    % verzoegerte Korrelation
    c_m_d = [ zeros( 1, M * D ) c_m( 1 : end - M * D ) ];
    % normierte Korrelation
    c_m_n = abs( c_m_d ) ./ p_r;
    % Auswertung
    [ E_m_n(i), i_m_n(i) ] = max( c_m_n( 373 : 380 ) );

end
fprintf( 1, ' Dauer: %g\n', etime( clock, t ) );

% Histogramme der Detektionsmaxima berechnen
E_m_n_min = floor( min( E_m_n ) );
E_m_n_max = ceil( max( E_m_n ) );
bin = 0.05;
[ y_m, x_m ] = hist( E_m_n , E_m_n_min : bin : E_m_n_max );
y_m = y_m / ( bin * length(E_m_n) );

save(datei,'Es_N0_dB','x_m','y_m');
