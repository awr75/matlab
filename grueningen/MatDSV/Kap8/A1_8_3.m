% M-File  A1_8_3.M,  Kap.8, Aufgabe 3 

disp(' '),disp(' ')
fpass=input('Durchlassfrequenz des TP-Filters in Hz,  fpass =  ');
disp(' '),disp(' '),disp(' ')

% Parameter
fs=1000; T=1/fs; f0=10; 

% Dreieckschwingung generieren
x=[0:0.04:0.96, 1:-.04:0.04]; x=[x -x x -x x -x x -x x -x];
t=0:T:length(x)*T-T;
subplot(4,1,1),plot(t,x),axis([0 0.4 -1.5 1.5])
title('Dreieckschwingung')

% Amplitudengang des TP-Filters 
[b,a]=ellip(4,.2,60,2*fpass/fs);
f=0:fs/200:fs/2; H=freqz(b,a,f,fs);
subplot(4,1,2), plot(f,abs(H))
title('Amplitudengang Tiefpassfilter')

% Gefilterte Dreieckschwingung
y=filter(b,a,x);
subplot(4,1,3), plot(t,y),axis([0 0.4 -1.5 1.5])
title('Gefilterte Dreieckschwingung')

% Sinusschwingung generieren
x=sin(2*pi*f0*t);
subplot(4,1,4),plot(t,x),axis([0 0.4 -1.5 1.5])
title('Ideale Sinusschwingung')

pause,close
