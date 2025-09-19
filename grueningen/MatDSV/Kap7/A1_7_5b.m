% M-File A1_7_5b.M,  Kap.7, Aufgabe 5b 
%
% Dieses M-File zeigt den Amplitudengang des analogen und des digitalen Integrators.

close, colordef black

f=logspace(0,log10(5e3),200);
Hsabs=abs(1./(j*2*pi*f*.001));
T=.0001; Hzabs=abs(.1./(1-exp(j*2*pi*f*T)));
loglog(f,Hsabs,f,Hzabs)
title('Amplitudengang des analogen (gelb) und des digitalen (magenta) Integrators')
xlabel('Frequenz in Hz')
pause, close
