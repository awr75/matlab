function ddc_polyphasen_fir_filter
% Beispiel fuer ein Polyphasen-FIR-Filter
%
% In diesem Beispiel wird ein Audio-Signal mit einer Abtastrate
% von 48 kHz auf eine Abtastrate von 32 kHz unterabgetastet.
% Der Unterabtastfaktor betraegt M = 3/2.
%
%------------------------------------------------
% (c) Eberhard Gamm (www.ibega.de),
%     LIKE (www.like.e-technik.uni-erlangen.de),
%     2013
%------------------------------------------------

close all;

print_flush( 'Die Signale werden berechnet ... ' );

% Signal einlesen
if exist('audioread','file')
    x = audioread( 'radio.wav' );
else
    x = wavread( 'radio.wav' );
end
x = x.';

% Parameter
P = 2;
Q = 3;

% Filterkoeffizienten berechnen ...
h = resampling_filter( max( P, Q ) );
% ... und Laenge auf ein Vielfaches von P bringen
m = mod( length(h), P );
if m > 0
    h = [ h zeros( 1, P - m ) ];
end

% einfache Berechnung:
% Startzeit
t_0 = clock;
% Nullen einfuegen
x_p = kron( x, [ P zeros( 1, P - 1 ) ] );
% Filterung
y_p = conv( x_p, h );
% Unterabtastung
y_0 = y_p( 1 : Q : end );
% Rechenzeit
t_0 = etime( clock, t_0 );

% Laenge der Teilfilter
N = length(h) / P;

% Polyphasen-Zerlegung
h_p = P * reshape( h, P, N );

% Signal erweitern
x   = [ zeros(1,N-1) x zeros(1,N-1) ];
l_x = length(x);

% Ausgangssignal anlegen
l_y = ceil( l_x * P / Q + 1 );
y   = zeros( 1, l_y );

% Polyphase initialisieren
p = 0;

% Berechnung
i_x = 0;
i_y = 0;
t = clock;
while i_x + N <= l_x
    
    % Ausgabewert berechnen
    i_y = i_y + 1;
    y(i_y) = x( i_x + N : -1 : i_x + 1 ) * h_p( p + 1, : ).';
    
    % naechste Polyphase berechnen
    p_next = mod( p + Q, P );
    
    % Eingangssignal weiterschieben
    i_x = i_x + ( p + Q - p_next ) / P;
    
    % naechste Polyphase setzen
    p = p_next;
    
end
t = etime( clock, t );

% Ausgangssignal kuerzen
y = y( 1 : i_y );

print_flush( 'OK\n' );

% Rechenzeiten und Differenz zwischen den Varianten
fprintf( 1, 'Rechenzeiten:\n' );
fprintf( 1, ' t   = %g sec\n', t );
fprintf( 1, ' t_0 = %g sec\n', t_0 );
fprintf( 1, 'Diff = %g', max( abs( y - y_0 ) ) );
print_flush('\n');

% Ausgabe
print_flush( 'Signal mit 48 kHz Abtastrate ... ' );
audio_ausgabe( x, 48000 );
print_flush( 'OK\nSignal mit 32 kHz Abtastrate ... ' );
audio_ausgabe( y, 32000 );
print_flush( 'OK\n' );
