% Programm early_symb.m
% Symbolische Rechnungen zum Early-Effekt
% benoetigt Symbolic Math Toolbox

syms x f0;
f0 = '1/(1-(0.001528*x)^(1/2))';
str = 'o Plot der Funktion f(x) = ';
disp(' '); disp([str f0]);
ezplot(f0, [0 700 0 20]); grid;

syms x f a;
disp(' '); disp('o Symbolische Funktion f(x):');
f ='1/(1-(a*x)^(1/2))'

% 1. Ableitung:
disp(' '); disp('o 1. Ableitung von f(x):');
d1f = diff(f, sym('x'))

%2. Ableitung: 
disp(' '); disp('2. Ableitung von f(x):');
d2f = diff(d1f, sym('x'))

% Wendepunkt:
disp(' '); disp('o Wendepunkt von f(x):');
solve (d2f,x)

% Taylorreihe um den Wendepunkt:
disp(' '); disp('o Taylor-Entwicklung von f(x) um den Wendepunkt bis 2. Ordnung:');
g = taylor(f,1/(9*a),2)

% Nullstelle der Wendetangente:
disp(' '); disp('o Berechnung der Nullstelle der Wendetangente:');
solve (g,x)
