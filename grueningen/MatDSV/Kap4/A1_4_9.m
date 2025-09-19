% M-File  A1_4_9.M      
% Lösung zu Kap.4, Aufgabe 9 
%
% Es wird ein Butterworth-Bandpassfilter 4.Ordnung entworfen und
% sein Amplitudengang und seine Gruppenlaufzeit werden dargestellt.
% Eine Wellengruppe, bestehend aus der Ueberlagerung 
% zweier Sinusschwingungen, deren Frequenzen innerhalb
% des Durchlassbereiches liegen, dient als
% Eingangssignal des Butterworth-Filters.
% Das Eingangs- und Ausgangssignal wird dargestellt und damit die Wirkung der
% Gruppenlaufzeit demonstriert.

close, home, colordef black

L=1;
while L==1

  clear, close, clc

  % Die Abtastfrequenz und die beiden Durchlassfrequenzen eingeben

  fs=input('Geben Sie die Abtastfrequenz in Hz ein:  fs= ');
  disp(' '),disp(' ')
  disp('Geben Sie die untere und die obere Durchlassfrequenz')
  disp('des Bandpassfilters in Hz ein.')
  disp('(Die beiden Frequenzen sollten ca. 20 mal kleiner als')
  disp('die Abtastfrequenz sein.)')
  fu=input('fu= ');fo=input('fo= ');disp(' '),disp(' '), T=1/fs;


  % Die Koeffizienten des Butterworth-Bandpassfilters bestimmen

  [b a]=butter(2,[fu/(0.5*fs) fo/(0.5*fs)]);


  % Amplitudengang und Gruppenlaufzeit berechnen und darstellen

  [H Omega]=freqz(b,a,1024); taug=T*grpdelay(b,a,1024); f=fs*Omega/(2*pi);
  subplot(2,1,1), semilogy(f,abs(H),'y'), axis([0 .25*fs 1e-4 1e1]), grid
  xlabel('f in Hz'),ylabel('|H|'),
  title('Amplitudengang des Butterworth-Bandpassfilters')
  subplot(2,1,2), plot(f,taug), axis([0 .25*fs -0.2*max(taug) 1.2*max(taug)])
  grid, xlabel('f in Hz'),ylabel('taug in s'),
  title('Gruppenlaufzeit des Butterworth-Bandpassfilters')  
  set(gcf,'Units','normal','Position',[0 0 1 1]), pause
  set(gcf,'Units','normal','Position',[0.4 0 0.6 0.3])


  % Die Wellengruppe mit den beiden Sinusschwingungen generieren,
  % filtern und darstellen. 

  disp('Geben Sie die Frequenzen der beiden Sinusschwingungen ein.')
  disp('(Die beiden Frequenzen sollten innerhalb des Durchlassbereichs liegen.)') 
  disp(' ')
  f1=input('f1= '); f2=input('f2= ');
  Deltaf=abs(f2-f1); tend=2/Deltaf;     % Da Deltaf die Frequenz der Schwebung
                                        % ist, werden durch die Wahl von
                                        % tend 2 Schwebungen dargestellt
  t=0:T:tend; x=sin(2*pi*f1*t)+sin(2*pi*f2*t); y=filter(b,a,x);
  n=round(1024*mean([fu fo])/(0.5*fs))+1; taugm=taug(n);       % Gruppenlaufzeit
                                        % bei der Mittenfrequenz bestimmen
  close,subplot(2,1,1),plot(t,x,'y'),axis([0 tend -2.5 2.5]),grid
  xlabel('t in s'),ylabel('x[n]')
  title(['Schwebung mit f1= ',num2str(f1),' Hz und f2= ',num2str(f2),' Hz'])
  subplot(2,1,2),plot(t,y,'g'),axis([0 tend -2.5 2.5]),grid
  xlabel('t in s'),ylabel('y[n]')
  title(['Gefilterte Schwebung,  taug= ',num2str(taugm),' s'])
  set(gcf,'Units','normal','Position',[0 0 1 1]), pause
  set(gcf,'Units','normal','Position',[0.4 0 0.6 0.3])

  L=menualt('Wollen Sie weiterfahren?','Ja','Nein');

  close
end