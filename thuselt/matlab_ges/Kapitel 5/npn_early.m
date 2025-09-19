% Unterprogramm npn_early.m 
% Berücksichtigung der Basisweitenmodulation (Early-Effekt) bei den
% Ebers-Moll-Parametern

arg1 = (2*epsrel*e0/q)*(NE/(NB*(NE+NB)))*(UbiE-UEB);
xnEB = sqrt(max(arg1,0));
   % Breite des Emitter-Basis-Übergangs
arg2 = (2*epsrel*e0/q)*(NC/(NB*(NC+NB)))*(UbiC-UCB);
xnCB = sqrt(max(arg2,0)); 
   % Breite des Kollektor-Basis-Übergangs

W = WB-xnEB-xnCB; 
a = W/LB;
rEB = DE*pE0*LB/(DB*nB0*LE);
rCB = DC*pC0*LB/(DB*nB0*LC);

if sb ==1
   % allgemeine Lösung
   fB = (DB/LB)*nB0*coth(a); 
   IES = q*A*((DE/LE)*pE0 + fB);    % Sperrstrom des Emitter-Basis-Übergangs bei UCB=0
   ICS = q*A*((DC/LC)*pC0 + fB);    % Sperrstrom des Kollektor-Basis-Übergangs bei UEB=0
   aV = 1 ./(cosh(a)+rEB*sinh(a)); 
   aR = 1 ./(cosh(a)+rCB*sinh(a)); 
 
else
   % Näherung schmaler Basis
   fB = (DB./W)*nB0;
   IES = q*A*((DE/LE)*pE0 + fB);    % Sperrstrom des Emitter-Basis-Übergangs bei UCB=0
   ICS = q*A*((DC/LC)*pC0 + fB);    % Sperrstrom des Kollektor-Basis-Übergangs bei UEB=0
   aV = 1 ./(1+a*rEB);
   aR = 1 ./(1+a*rCB);

end

