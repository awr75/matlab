% Programm "E_ueber_k.m"
% Energie ueber Impulskomponenten zweidimensional
% E(p) = a*p^2

clear
clear axis
% ************************
% Constants and parameters
% ************************
a=10;
midpoints=361;
phi = linspace(0,2*pi,midpoints);

% **************************
% Plot
% **************************
close
p=1;
for p = 0 : 0.1: 5; 				% Abstand vom Zentrum
   z=p.^2*ones(midpoints,1);	% z wird Matrix der Dimension (midpoints x 1)
   									% also midpoints Zeilen und 1 Spalte
   plot3 (p*sin(phi),p*cos(phi),z); hold on
end
view(-23,24); 
grid on;



