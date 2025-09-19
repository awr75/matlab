% M-File A1_7_13.M,  Kap.7,  Aufgabe 13 
%
% Dieses M-File entwirft ein elliptisches Filter in Kaskadenform.
% Es stellt die Amplitudengänge der Übertragungsfunktionen H01(z), 
% H02(z) und H03(z) dar (Bild 7.45).


close, colordef black

% H(z) entwerfen 
[b,a]=ellip(6,1,40,.2); b=0.1*b;
[H,f]=freqz(b,a,512,1);
subplot(4,1,1), plot(f,abs(H)), grid
title('Amplitudengang des elliptischen Filters')


% H(z) zerlegen in Blöcke 2.Ord.
sos=tf2sosI(b,a,'up','inf')

% Die Übertragungsfunktionen H01(z), H02(z) und H03(z) bestimmen
b01=sos(1,1:3); a01=sos(1,4:6);
b02=conv(b01,sos(2,1:3)); a02=conv(a01,sos(2,4:6));
b03=conv(b02,sos(3,1:3)); a03=conv(a02,sos(3,4:6));

% Amplitudengänge darstellen
[H01,f]=freqz(b01,a01,512,1);
subplot(4,1,2), plot(f,abs(H01)), grid
title('Amplitudengang von H01(z)')
[H02,f]=freqz(b02,a02,512,1);
subplot(4,1,3), plot(f,abs(H02)), grid
title('Amplitudengang von H02(z)')
[H03,f]=freqz(b03,a03,512,1);
subplot(4,1,4), plot(f,abs(H03)), grid
title('Amplitudengang von H03(z)')

pause, close

