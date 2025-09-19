% Programm Egplot.m
% Plot des Bandgaps in Germanium, Silizium und GaAs
% als Funktion der Temperatur
% benutzt die Funktionen Eg_Ge.m, Eg_Si.m, Eg_Ge.m 

%****************************
% Tabelle Eg(T)
%****************************
clear
T=[0 10 100 200 300 400 500 600];
disp(' ***********************************************');
disp('  T    Eg(T)     Ge           Si         GaAs');
disp(' **********************************************');
for i = 1:8
   E_gg = [Eg_Ge(T(i)) Eg_Si(T(i)) Eg_GaAs(T(i))];
   string1 = sprintf(' %3.1f   %4.3e   %4.3e   %4.3e', T(i), E_gg);
   disp(string1);
end

%****************************
% Plot
%****************************

T = 0:10:600;			% Temperaturwerte
[n,imax] = size(T);
for i = 1:imax
      E_g(i,:) = [Eg_Ge(T(i)) Eg_Si(T(i)) Eg_GaAs(T(i))];
end
plot(T, E_g); grid; hold on;
plot(300, [Eg_Ge(300) Eg_Si(300) Eg_GaAs(300)], 'o'); hold off;

str1 = ['Ge']; text(310, Eg_Ge(300),str1); 
str2 = ['Si']; text(310, Eg_Si(300)+.05,str2);
str3 = ['GaAs']; text(310, Eg_GaAs(300)+.05,str3);
title('Temperaturabhängigkeit des Bandgaps');
xlabel('T/K'); ylabel('E_G/eV'); 

