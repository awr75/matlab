% Programm ni_temp.m
% Temperaturabhängigkeit
% der intrinsischen Ladungsträgerkonzentration in Silizium

clear;
Silizium;

%----------------------------
% Berechnung für Tabelle ni_T(T)
%----------------------------
T0 = [100 200 300 400 500 600];
disp(' ');
disp(' **********************************************');
disp('  T        ni(T)');
disp(' **********************************************');
for i = 1:length(T0)
   Nc_T = Nc_0 * (T0(i)/300).^1.5;    % eff. Zustandsdichte des Leitungsbands in cm-3
   Nv_T = Nv_0 * (T0(i)/300).^1.5;    % eff. Zustandsdichte des Valenzbands in cm-3
   ni_square_T = Nc_T * Nv_T * exp(-EG./(kB*T0(i)));
   ni_T = sqrt(ni_square_T);         % intrinsische Ladungsträgerkonzentration in cm-3
   string1 = sprintf(' %3.1f   %4.4e ', T0(i), ni_T);
   disp(string1);
end
disp(' ');

%----------------------------
% Berechnung für Plot
%----------------------------
T = 100:10:600;			% Temperaturwerte
[n,imax] = size(T);
for i = 1:imax
   Trez(i) = 1/T(i);
   Nc_T = Nc_0 * (T(i)/300)^1.5;    % eff. Zustandsdichte des Leitungsbands in cm-3
   Nv_T = Nv_0 * (T(i)/300)^1.5;    % eff. Zustandsdichte des Valenzbands in cm-3
   ni_square_T = Nc_T * Nv_T * exp(-EG/(kB*T(i)));
   ni_T(i) = sqrt(ni_square_T);     % intrinsische Ladungsträgerkonzentration in cm-3
end

%****************************
% Plot
%****************************

semilogy(T, ni_T); grid on; xlabel('T/K'); ylabel('n_i /cm^-^3'); 
   % halblog. Darstellung über T
% Alternativ:
   % plot(T, ni_T); grid on; xlabel('T/K'); ylabel('n_i /cm^-^3');     
   % normale Darstellung über T
% Alternativ:
   % semilogy(Trez, ni_T); grid on; xlabel('1/T in K^-^1'); ylabel('n_i /cm^-^3'); 
   % halblog. Darstellung über 1/T 

title('n_i(T) in Silizium');

