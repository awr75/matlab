% M-File A1_7_9c.M,  Kap.7,  Aufgabe 9c) 
%
% Dieses M-File berechnet die Pole und Nullstellen eines Bandpassfilters 
% mit folgenden Parametern: fc=50Hz, BW=5Hz, A=1 und fs=1000Hz.
% Es Stellt das Pol-Nullstellen-Diagramm und den Amplitudengang dar.

home, disp(' ')
fc=50, BW=5, A=1, fs=1000
theta=2*pi*fc/fs, r=1-pi*BW/fs
K=A*((1-r)*sqrt(1-2*r*cos(2*theta)+r*r))/(2*abs(sin(theta)))
disp(' '), disp(' ')
disp('Die Pole und Nullstellen werden berechnet und in Betrags-Phasen-Form (Winkel in rad) dargestellt:')
p1=[r theta], p2=[r -theta], p=[r*exp(j*theta);r*exp(-j*theta)];
z1=[1 0], z2=[1 pi], z=[1;-1];
disp(' '),disp(' ')
disp('Weiter mit Tastendruck'), pause
set(gcf,'Units','normal','Position',[0.4 0.05 0.5 0.5]); zplane(z,p);
disp(' '),disp(' ')
disp('Weiter mit Tastendruck'), pause

disp(' '),disp(' ')
disp('Die b- und a-Koeffizienten lauten:'), disp(' ')
b=[K 0 -K]
a=[1 -2*r*cos(theta) r*r]

close

disp(' '),disp(' ')

% Amplitudengang darstellen
[H,f]=freqz(b,a,2048,fs);
set(gcf,'Units','normal','Position',[0.4 0.05 0.5 0.5]);
plot(f,20*log10(abs(H))), grid
title('Amplitudengang in dB')

pause, close

