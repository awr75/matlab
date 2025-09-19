function rez_fermi = rez_fermi(x)
% reziproke Funktion zum Fermi-Integral fermi(x,k=1/2)
% (nach Blakemore, Solid State Electronics (1982), p. 1067, eq. (38))
% x muss > 0 sein

if min(x)<=0
   error('    x muss > 0 sein');
end

x = x(:)';
m = find(x);

m1 = find(x == 1);
if ~isempty(m1)
	A(m1) = -0.5;					          % Grenzwert des 1. Terms für x -> 1
end
m2 = find(x ~= 1);
if ~isempty(m2)
   A(m2) = log(x(m2))./(1-x(m2).^2);    % 1. Term sonst
end

num = 3 * sqrt (pi) * x(m)/4;
klamm1 = 3 * sqrt(pi) .* x(m)/4;
klamm = 0.24 + 1.08 .* klamm1.^(2/3);
den = 1 + 1./klamm.^2;
B = num.^(2/3)./den;      % 2. Term

eta = A + B;
rez_fermi = eta;