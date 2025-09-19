function p = p(U,jph,js)
kT = 0.02585;  % Energie entsprechend 300 K in eV 
               % (oder "Temperaturspannung" entsprechend 300 K in Millivolt)

j =  jph + js .* (exp(U/kT) - 1);	 % Gesamtstrom
p = j .* U;