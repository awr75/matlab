function diffp=diffp(U,jopt,js)
% Ableitung der Leistung bei der Solar-Strom-Spannungs-Kennlinie

konstanten; 
j =  jopt + js .* (exp(U/kT) - 1);	 % Gesamtstrom
diffp = j +  js .* exp(U/kT)*(U/kT);