% M-File  Bandpass2Ord
%
% Dieses M-File simuliert einen kontinuierlichen Bandpass 2. Ordnung

% -----------------------  7.2.04 / DvG ----------------------------

close, home, colordef white

disp(' ')
disp('Simulation eines Bandpasses 2. Ordnung mit den Parametern omega0 und q')
disp('----------------------------------------------------------------------')
disp(' '),disp(' ')
disp('Geben Sie ein:')
disp(' ')
disp('Die Resonanzkreisfrequenz omega0 und die Güte q')
disp(' ')
disp('Schliessen Sie die Eingabe mit der Buchstabenfolge   return   ab.')
disp(' '),disp(' ')
disp('Eingabe-Beispiele:')
disp(' ')
disp('omega0=2*pi*1; q=5; return')
disp(' ')
disp('omega0=2*pi*1; q=1; return')
disp(' ')
disp('omega0=2*pi*1; q=0.2; return')
disp(' ')
disp(' '),disp(' ')


keyboard


% Initialisierung
b=[omega0/q 0]; a=[1 omega0/q omega0^2];
H=tf(b,a); 

% PN-Plot
subplot(2,2,1), sgrid
pzmap(H)

% Ampl.gang
f=logspace(log10(omega0/(2*pi*10)),log10(omega0*10/(2*pi)),500);
HdB=20*log10(abs(freqs(b,a,2*pi*f))); 
subplot(2,2,2); semilogx(f,HdB);
title('Amplitudengang in dB'), xlabel('f in Hz')

% Schrittantwort
[k,p]=residue(b(1),a);
tau=1/min(abs(real(p)));  t=0:tau/100:5*tau;
subplot(2,1,2); uout=real(k(1)*exp(p(1)*t)+k(2)*exp(p(2)*t));  plot(t,uout)
title('Schrittantwort'), xlabel('t in s')

pause,close


