% M-File  A1_5_13.M      
% Lösung zu Band 1, Kap.5, Aufgabe 13 
%
% Dieses M-File identifiziert ein LTI-System mithilfe der Kreuzkorrelations-Methode und 
% vergleicht die geschätzte Impulsantwort  und den geschätzten Amplitudengang
% mit der wahren Impulsantwort und dem wahren Amplitudengang.

clear, close, home, colordef black

disp(' '),disp(' ')
disp('Daten in Form eines Zeilenvektors eingeben')
disp(' ')
b=input('Koeffizienten des Zählerpolynoms  b=  ');
disp(' ')
a=input('Koeffizienten des Nennerpolynoms  a=  ');
disp(' ')
fs=input('Abtastfrequenz in Hz  fs=  ');
disp(' ')

% Impulsantwort und Amplitudengang plotten
subplot(2,1,1), set(gcf,'Units','normal','Position',[0 0 1 1])
impz(b,a), title('Impulsantwort h[n]')
pause, set(gcf,'Units','normal','Position',[0.4 0 0.6 0.3])

% Eingangs- und Ausgangssignal generieren
disp(' ')
N=input('Länge des Eingangssignals  N=  ');
disp(' ')
x=randn(1,N); y=filter(b,a,x);

% Kreuzkorrelieren
m_max=input('Maximale Verschiebungszeit  m_max=  ');
disp(' ')
[rhxyunbiased,m]=xcorr(y,x,m_max,'unbiased'); [rhxybiased,m]=xcorr(y,x,m_max,'biased');
close, set(gcf,'Units','normal','Position',[0 0 1 1]); subplot(2,1,1)
h=stem(m,rhxybiased,'.m'); grid; hold on; h=stem(m,rhxyunbiased,'.y');
set(h,'linewidth',0.5); ylabel('h,  rhxyunbiased,  rhxybiased');
y=zeros(1,2*m_max+1); h=impz(b,a,m_max+1);
hold on; y(m_max+1:2*m_max+1)=h; h=stem(m,y,'.g');
set(h,'linewidth',0.5); grid
title('Exakte Impulsanwort: grün,        geschätzte Impulsantwort:   magenta: erwartungstreu,   gelb: asympt. erwartungstreu')

% Amplitudengang
[H,f]=freqz(b,a,512);
f=0:fs/1024:fs/2-fs/1024;
subplot(2,1,2), H_biased=freqz(rhxybiased(m_max+1:2*m_max+1),1,f,fs); h=semilogy(f,abs(H_biased),'m');
set(h,'linewidth',0.5); xlabel('f   [Hz]'), ylabel('|H(f)|:  exact,  unbiased,  biased')
title('Exakter Amplitudengang:  grün,        geschätzter Amplitudengang:   magenta: erwartungstreu,   gelb: asympt. erwartungstreu')
axis([0 0.5*fs 1e-6 1e2]),grid
hold on; H_unbiased=freqz(rhxyunbiased(m_max+1:2*m_max+1),1,f,fs); h=semilogy(f,abs(H_unbiased),'y');
set(h,'linewidth',0.5);
hold on; h=semilogy(f,abs(H),'g'); set(h,'linewidth',0.5);


pause,close