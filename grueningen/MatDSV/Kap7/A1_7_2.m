% M-File A1_7_2.M,  Kap.7, Aufgabe 2 
%
% Dieses M-File generiert ein Tiefpass-Signal und filtert
% es mit einem FIR- und einem IIR-Tiefpassfilter.

close, colordef black


load A1_7_2
[H,f]=freqz(b1,a1,512,1);
subplot(2,1,1), plot(f,abs(H)), grid
title('Amplitudengang des FIR-Filters')
[H,f]=freqz(b2,a2,512,1);
subplot(2,1,2), plot(f,abs(H)), grid
title('Amplitudengang des IIR-Filters'), pause, close


[G,f]=grpdelay(b1,a1,512,1);
subplot(2,1,1), plot(f,G), grid
title('Gruppenlaufzeit des FIR-Filters')
[G,f]=grpdelay(b2,a2,512,1);
subplot(2,1,2), plot(f,G), grid
title('Gruppenlaufzeit des IIR-Filters'), pause, close


n=0:601;
x=1/1*sin(2*pi*0.005*n)+1/3*sin(2*pi*0.015*n)+1/5*sin(2*pi*0.025*n)+1/7*sin(2*pi*0.035*n);
subplot(2,1,1), plot(n,x),title('Eingangssignal x[n]')
y=filter(b1,a1,x);
subplot(2,1,2), plot(n,y); title('Ausgangssignal y[n] des FIR-Filters'), pause, close


subplot(2,1,1), plot(n,x),title('Eingangssignal x[n]')
y=filter(b2,a2,x);
subplot(2,1,2), plot(n,y); title('Ausgangssignal y[n] des IIR-Filters'), pause, close
