% M-File PerDirac.m
%
% Dieses M-File plottet die Funktion 
% x = 1+ 2*cos(2*pi*1*t) + ... + 2*cos(2*pi*N*t)
% 
% Diese Funktion hat demnach Spektrallinien bei f= -N, -(N-1), ..., -1, 0, 1, ..., (N-1), N
% Für N gegen unendlich besteht die Funktion demnach aus Dirac-Impulsen bei
% ganzen Vielfachen von 1.

clc, clear, close

disp(' '),disp(' ')
disp('Dieses M-File plottet die Funktion')
disp(' '), disp('x = 1 + 2*cos(2*pi*1*t) + ... + 2*cos(2*pi*N*t) ')
disp(' ')
disp('Diese Funktion hat demnach Spektrallinien bei f= -N, -(N-1), ..., -1, 0, 1, ..., (N-1), N.')
disp('Für N gegen unendlich besteht die Funktion demnach aus Dirac-Impulsen bei ganzen Vielfachen von 1.')
disp(' ')

J=1; while J==1

 disp(' '), disp(' '), disp('Input N ')
 N=input('N= '); disp(' '), disp(' ')

 clf, figure(1)
 x=1; t=-5:.01:5;
 for k=1:N
	x=x+2*cos(2*pi*k*t);
 end
 plot(t,x),grid,pause,close

J=menualt('Do you want to continue?','Yes','No');
end
