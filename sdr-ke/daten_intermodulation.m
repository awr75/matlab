function daten_intermodulation
% Intermodulation durch eine nichtlineare Kennlinie
%
%------------------------------------------------
% (c) Eberhard Gamm (www.ibega.de),
%     LIKE (www.like.e-technik.uni-erlangen.de),
%     2013
%------------------------------------------------

close all;

% Parameter
A  = 10;
c3 = 0.3;
c5 = 0.6;

% Laenge der FFT zur Berechnung des Spektrums
l_fft = 1024;
% Anzahl der ausgewerteten Linien des Spektrums
% (Nutzanteil und 6 Intermodulationsprodukte)
l_ov = 7;
% Zweiton-Signal mit Toenen, die in die Bins 16 und 17 der FFT fallen
% (Spektrum kann ohne Fenster berechnet werden)
xs = sin( 2 * pi * 16 * ( 0 : l_fft - 1 ) / l_fft ) + ...
     sin( 2 * pi * 17 * ( 0 : l_fft - 1 ) / l_fft );
% auszuwertender Amplitudenbereich
xa = 10.^( -2 : 0.01 : 0.5 );
l_xa = length(xa);
% Ausgangssignale
ys = zeros( l_xa, length(xs) );
% ausgewertete Linien des Spektrums
ya = zeros( l_xa, l_ov );
% Schleife ueber den Amplitudenbereich
for i = 1 : l_xa
    % Ausgangssignal berechnen
    ys( i, : ) = nonlinear( xa(i) * xs, A, c3, c5 );
    % Spektrum berechnen
    yf = 2 * abs( fft( ys( i, : ) ) ) / l_fft;
    % auszuwertende Linien aus dem Spektrum entnehmen
    ya( i, : ) = yf( 18 : 18 + l_ov - 1 );
    % Beispiel-Spektrum aufbewahren
    if i == 150
        yfi = yf;
    end
end
% Endwert fuer die Signaldarstellung ergaenzen
ys = [ ys ys(:,1) ];
% normierte Zeitachse
ts = ( 0 : l_fft ) / l_fft;

figure(1);
loglog(xa,ya(:,1),'b-','Linewidth',2);
hold on;
for i=2:l_ov
    loglog(xa,ya(:,i),'r-','Linewidth',2);
end
plot(xa,A*xa,'b--','Linewidth',1);
plot(xa,3*A*c3*xa.^3/4,'r--','Linewidth',1);
plot(xa,5*A*c5*xa.^5/8,'r--','Linewidth',1);
hold off;
grid;
axis([0.01 3 1e-6 40]);
xlabel('Eingangsamplitude');
ylabel('Ausgangsamplitude');
title('Amplituden der Grundwellen und der Intermodulationsprodukte');
legend('Grundwellen','IM-Produkte','Location','NorthWest');


figure(2);
plot(ts,ys(101,:),'b-','Linewidth',1);
hold on;
plot(ts,ys(171,:),'r-','Linewidth',1);
hold off;
grid;
axis([0 1 -6 8]);
title('Verlauf der Ausgangssignale fuer ein Zweitonsignal');
legend('Amplitude = 0.1','Amplitude =  0.5');

figure(3);
k=[15:20 48:53 81:86];
for i=1:length(k)
    ki=k(i);
    semilogy([ki ki],[1e-4 yfi(ki)],'b-','Linewidth',2);
    hold on;
end
hold off;
grid;
axis([1 90 1e-4 1e1]);
xlabel('normierte Frequenz');
ylabel('Amplitude');
title('Spektrum des Ausgangssignals')
