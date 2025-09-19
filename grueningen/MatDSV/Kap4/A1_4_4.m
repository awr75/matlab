% M-File  A1_4_4.M      
% Lösung zu Kap.4, Aufgabe 4

home
disp(' ')
disp('Sie haben mit sptool ein kausales LTI-System (FIR- oder IIR-Filter) entworfen') 
disp('und es unter dem Namen filt1 in den Arbeitsspeicher exportiert.')
disp('Drücken Sie jetzt die ENTER-Taste.'), pause
disp(' ')


% Impulsantwort plotten
filt1
Koeffizienten_des_Zaehlerpolynoms=filt1.tf.num
Koeffizienten_des_Nennerpolynoms=filt1.tf.den
h=impz(filt1.tf.num,filt1.tf.den);
impz(filt1.tf.num,filt1.tf.den),title('Impulsantwort des kausalen Filters')
xlabel('Zeitindex n'),pause,close


% Aus dem kausalen LTI-System mit filtfilt ein nichtkausales LTI-System machen.
% Zur Demonstration filtfilt auf den Einheitspuls anwenden.
disp(' ')
disp('Der Befehl filtfilt macht daraus ein nichtkausales LTI-System') 
disp(' ')
L=ceil(1.5*length(h)); n=-L:L; delta=zeros(1,2*L+1); delta(L+1)=1;
h=filtfilt(filt1.tf.num,filt1.tf.den,delta);
stem(n,h,'filled'),title('Impulsantwort des nichtkausalen Filters')
xlabel('Zeitindex n'),pause,close