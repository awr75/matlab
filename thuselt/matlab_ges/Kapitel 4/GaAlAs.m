function [Egx, n] = GaAlAs(x)
% Funktion GaAlAs(x).m
%*******************************************************
% m-File zur Berechnung der Gapenergie Egx
% und des Brechungsindex n von Ga(1-x)Al(x)As
% 
% nach Shur M (1990) Physics of Semiconductor Devices. Prentice Hall, Englewood Cliffs, p.523
% Berechnung für 300 K
% [Egx, n] = GaAlAs(x)
% wobei  Egx = Gapenergie in eV
%			n = Brechungsindex


% Gapenergie
if x < 0 | x > 1
   error('0 <= x <=1')
elseif x < 0.45
	Egx = 1.424 + 1.247*x;   % gilt für x < 0.45
else
   Egx = 1.900 + 0.125*x + 0.143 * x^2;   % gilt für x >= 0.45
end

% Brechungsindex
n = 3.590 - 0.710*x + 0.091*x^2; 
