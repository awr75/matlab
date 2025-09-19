% M-File A1_7_5a.m,  Kap.7, Aufgabe 5a
%
% Dieses M-File zeigt den Amplitudengang des analogen und des digitalen Tiefpasses 1. Ordnung.

close, colordef black

f=logspace(0,log10(4e3),200);
RC=0.00159; 
Hsabs=abs(1./(1+j*2*pi*f*RC));
T=1/8000; b0=1/(1+RC/T); a1=-b0*RC/T;
Hzabs=abs(b0./(1+a1*exp(j*2*pi*f*T)));
loglog(f,Hsabs,f,Hzabs)
title('Amplitudengang des analogen (gelb) und des digitalen (magenta) Tiefpassfilters')
xlabel('Frequenz in Hz')
pause, close
