% M-File  gfilter.m
%
% Das M-File generiert ein Signal, das aus der Ueberlagerung von zwei Sinus-Schwingungen
% und weissem Rauschen besteht. 
% Dieses Signal wird mit dem Goertzel-Filter verarbeitet.
% Das Ausgangssignal wird nicht in Form von Abtastwerten, sondern - 
% der besseren grafischen Darstellung wegen - in Form von Treppenstufen
% dargestellt.
% Zusaetzlich wird der Frequenzgang der Leistung berechnet.

clc, clear, close

% Textausgabe
disp(' '),disp(' ')
disp('A signal consisting of two sinus with the frequencies  f01  and  f02  ')
disp('and the amplitudes  Xhat1  and  Xhat2  ')
disp('and Gaussian white noise with the RMS value  Xrms  is sampled with  fs.')
disp(' ')
disp('fk is the desired DFT-frequency and')
disp('N the number of samples in the measuring interval.')
disp(' ')
disp('The Goertzel Filter then works during M measuring intervals.')
disp(' ')
disp('The Goertzel Filter provides at the end of every Nth sampling interval')
disp('the power of the input signal at the DFT-frequency  fk=k*fs/N.')
disp(' ')
disp('The program also computes the frequency response of the power')
disp('at the output of the Goertzel Filter.')
disp(' '),disp(' '), pause

% Parameterwerte initialisieren
f01=1000; f02=50;
Xhat1=0; Xhat2=0;
Xrms=1;
fs=8000;
fk=1000; N=50; M=8;


J=1;
while J==1
  
 % Parameterwerte auf Bildschirm darstellen
 close,disp(' '),disp('The parameters are:'),disp(' ')
 disp(['1.  ','f01     =  ',num2str(f01),   ' Hz  '])
 disp(['2.  ','Xhat1   =  ',num2str(Xhat1), '     '])
 disp(['3.  ','f02     =  ',num2str(f02),   ' Hz  '])
 disp(['4.  ','Xhat2   =  ',num2str(Xhat2), '     '])
 disp(['5.  ','Xrms    =  ',num2str(Xrms),  '     '])
 disp(['6.  ','fs      =  ',num2str(fs),    ' Hz  '])
 disp(['7.  ','fk      =  ',num2str(fk),    ' Hz  '])
 disp(['8.  ','N       =  ',num2str(N),     '     '])
 disp(['9.  ','M       =  ',num2str(M),     '     '])
 disp(' ')
     disp(' '), disp('Input your new data and close by keying in R E T U R N')
 disp(' '), keyboard
 T=1/fs;  k=fk*N/fs;

 % Mit fs abgetastetes Signal berechnen
 t=0:T:(N*M-1)*T; 
 x=Xhat1*sin(2*pi*f01*t)+Xhat2*sin(2*pi*f02*t)+Xrms*randn(1,M*N);
 ts=0; te=N*M*T;
 
 % Goertzel-Filter initialisieren
 a=2*cos(2*pi*k/N);
 WkN=exp(-j*2*pi*k/N); br=real(-WkN); bi=imag(-WkN); 
 wu2dN=sqrt(2)/N; twodN=2/N^2;
 Pk=zeros(1,M);

 % Goertzel-Filter ausführen 
 for l=1:M
   [y,v]=filter(1,[1 -a 1],x((l-1)*N+1:l*N),[0 0]);
   Pk(l)=twodN*((v(1)+br*y(N))^2+(bi*y(N))^2);
 end
 
 % Mittelwert von Pk berechnen
 Pkmean=sum(Pk(2:M))/(M-1);
 disp(' '),  disp(['    ','Mean Value of Pk =  ',num2str(Pkmean),    ' ']), disp(' ')

 % Eingangs- und Ausgangssignal darstellen
 subplot(2,1,1), plot(t,x), axis([ts te 1.2*min(x) 1.2*max(x)]), grid
 title(['Signal  x,   f01= ',num2str(f01),' Hz,   Xhat1= ',num2str(Xhat1),...
         ',  f02= ',num2str(f02),' Hz,  Xhat2= ',num2str(Xhat2),...
         ',   Xrms= ',num2str(Xrms),',   fs= ',num2str(fs),' Hz'])
 tG=0:N*T:M*N*T; subplot(2,1,2), stairs(tG,[0 Pk])
 axis([ts te -0.2*max(Pk) 1.2*max(Pk)]), grid
 title(['Output Pk,   M= ',num2str(M),',  N= ',num2str(N),',  fk= ',num2str(fk),...
        ' Hz,  fs= ',num2str(fs),' Hz'])
 xlabel('Time in seconds');    
 set(gcf,'Units','normal','Position',[0 0 1 1]), pause, close

 
% Frequenzgang der Leistung berechnen
% (Gemäss internen Unterlagen von D. v. Grünigen: "Goertzel Algorithm", 1996)

 JJ=1;
 while JJ==1

    KK=menualt(['In which frequency range would you like ',...
               'to depict the frequency response?'],...
               'In the  Nyquist range','In the frequency range   f1  ...  f2');disp('')
      if KK==1
      deltaf=.5*fs/511; f=0:deltaf:.5*fs;
    else
      f1=input('Input the lower frequency limit  f1= ');disp(' ');
      f2=input('Input the higher frequency limit   f2= ');disp(' ');
      Deltaf=(f2-f1)/511; f=f1:Deltaf:f2;
    end
    W=exp(j*2*pi*k/N*[0:N-1]);
    H=freqz(W,1,f,fs);Hpow=(1/N^2)*(real(H).^2+imag(H).^2);

   
    % Nochmals Ausgangssignal darstellen
    tG=0:N*T:M*N*T; subplot(2,1,2), stairs(tG,[0 Pk])
	 axis([ts te -0.2*max(Pk) 1.2*max(Pk)]), grid
    title(['Output Pk,   M= ',num2str(M),',  N= ',num2str(N),',  fk= ',num2str(fk),...
        ' Hz,  f01= ',num2str(f01),' Hz,   f02= ',num2str(f02),' Hz,   Xrms= ',...
        num2str(Xrms)])
	 xlabel('Time in seconds');    

	 % Frequenzgang der Leistung darstellen
	 subplot(2,1,1),semilogy(f,Hpow), axis('auto'),grid
    xlabel('Frequency in Hz')
    title(['Frequency Response of the Power Pk,  N= ',num2str(N),',  fk= ',num2str(fk),' Hz,  fs= ',num2str(fs),' Hz'])
    set(gcf,'Units','normal','Position',[0 0 1 1]), pause, close
    JJ=menualt('Do you want to input new frequency limits?','Yes','No');
 end

 J=menualt('Do you want to continue?','Yes','No'); clc

end
