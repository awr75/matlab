function ueb_groundplane_anpassung
% Simulation der Anpassung einer Groundplane-Antenne
%
%------------------------------------------------
% (c) Eberhard Gamm (www.ibega.de),
%     LIKE (www.like.e-technik.uni-erlangen.de),
%     2014
%------------------------------------------------

close all;

% Leitungswellenwiderstand
Z_L = 50;
% Frequenzbereich in MHz
f = 425 : 0.1 : 445;
% Elemente des Ersatzschaltbilds der Antenne
R_S = 8;
R_V = 0;
L_A = 30e-9;
C_A = 1.046e-12;
% Elemente der Anpassung
C_1 = 16.8e-12;
L_2 = 105e-9;
% komplexe Kreisfrequenz
w = 2i * pi * f * 1e6;
% Impedanz
Z = 1 ./ ( w * C_1 + 1 ./ ( R_S + R_V + w * ( L_2 + L_A ) + ...
                            1 ./ ( w * C_A ) ) );
% Reflexionsfaktor
r = ( Z - Z_L ) ./ ( Z + Z_L );

% Anzeige des Betrags des Reflexionsfaktors
figure(1);
plot(f,abs(r),'b-','LineWidth',1);
grid on;
xlabel('f [MHz]');
ylabel('|r|');
title('Betrag des Reflexionsfaktors');
