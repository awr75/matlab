% M-File  A1_7_16.M      
% Lösung zu Band 1, Kap.7, Aufgabe 16 
%
% Dieses M-File berechnet den Mittelwert muy
% und die Standardabeichung sigmay des Quantisierungsrauschens 
% eines Direktform-I-IIR-Filters.
% Voraussetzung: Das Filter wurde mit spfilt entworfen, quantisiert
% und abgespeichert unter dem Namen filt1_quant_


close, home, colordef black

disp(' '),disp(' ')
BAD1=input('Wortlänge des AD-Wandlers (BAD+1)=  '); BAD=BAD1-1;
disp(' ')
B1=input('Wortlänge des Digitalfilters  (B+1)=  '); B=B1-1;
disp(' ')

% Filterkoeffizienten
b=filt1_quant_.tf.num; a=filt1_quant_.tf.den;

% Mittelwert my
EinsdurchA=freqz(1,a,[0,pi]);
muy=-0.5*EinsdurchA(1)

% Standardabweichung sigmay
s=1/(2*sqrt(3)); NG=nsgain(b,a); NGA=nsgain(1,a);
sigmay=s*sqrt(NG*2^(2*(B-BAD))+NGA)