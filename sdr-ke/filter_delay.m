function h_delta=filter_delay(h,delta)
% h_delta = filter_delay( h, delta )
%
% Berechnung eines Filters h_delta mit einer um 0 <= delta < 1
% groesseren Verzoegerung im Vergleich zum Filter h
%
%------------------------------------------------
% (c) Eberhard Gamm (www.ibega.de),
%     LIKE (www.like.e-technik.uni-erlangen.de),
%     2013
%------------------------------------------------

% Laengen bilden
l_h = length(h);
l_f = 2^( ceil( log2( l_h + 1 ) ) );

% Koeffizienten mit Nullen auffuellen
h_n = [ h zeros( 1, l_f - l_h ) ];

% FFT der Laenge l_f
H_n = fft( h_n );

% komplexen Drehvektor bilden
D = exp( -2i * pi * delta * ( 1 : ( l_f - 1 ) / 2 ) / l_f );
D = [ 1 D 0 conj( fliplr( D ) ) ];

% Drehen und Ruecktransformieren
h_n = ifft( H_n .* D );

% Nullen abschneiden
h_delta = real( h_n( 1 : l_h + 1 ) );
