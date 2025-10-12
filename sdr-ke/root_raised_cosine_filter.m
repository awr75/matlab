function [g,d] = root_raised_cosine_filter(n,m,r)
% [g,d] = root_raised_cosine_filter(n,m,r)
%
% Berechnung der Koeffizienten eines Root-Raised-Cosine-Filters
% im Frequenzbereich
%
%   g - Koeffizienten
%   d - Sperrdaempfung in dB
%   n - Anzahl Koeffizienten (n >= 10)
%   m - relative Abtastrate f_a / f_s (m >= 2)
%   r - Roffoff-Faktor (0.1 <= r <= 1)
%
%------------------------------------------------
% (c) Eberhard Gamm (www.ibega.de),
%     LIKE (www.like.e-technik.uni-erlangen.de),
%     2013
%------------------------------------------------

if n < 10
    error('Anzahl Koeffizienten ist zu gering');
end
if m < 2
    error('Relative Abtastrate ist zu gering');
end
if ( r < 0.1 ) || ( r > 1 )
    error('Unzulaessiger Rolloff-Faktor');
end

% Vektor im Frequenzbereich bilden
G   = zeros( 1, n );
l_s = n / m;
n_1 = ceil( ( 1 - r ) * l_s / 2 );
n_2 = ceil( ( 1 + r ) * l_s / 2 );
for i = 0 : n_1 - 1
    G(i+1) = exp( - j * pi * i * ( n - 1 ) / n );
end
for i = n_1 : n_2 - 1
    G(i+1) = cos( pi / ( 4 * r ) * ( 2 * i / l_s - 1 + r ) ) ...
             * exp( - j * pi * i * ( n - 1 ) / n );
end
l = floor( n / 2 );
G( n : -1 : n - l + 1 ) = conj( G( 2 : l + 1 ) );

% Impulsantwort berechnen und normieren
g = real( ifft(G) );
g = g / sum(g);

% Frequenzgang berechnen
l = 1024;
G = fft( g, 2 * l );
G = 20 * log10( abs( G(1:l) ) + 1e-12 );

% Maximum im Sperrbereich suchen
i = floor( l / m );
while G(i+1) < G(i)
    i = i + 1;
end
d = - max( G(i:l) );
