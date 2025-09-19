function a = sphere_1(R,r,col)
% Darstellung einer Kugel mit Mittelpunkt R=[X,Y,Z] und Radius r
% col - Face color

if nargin == 0; 
   R = [0,0,0]; r = 1;
end

X = R(1); Y = R(2); Z = R(3);
n=100;
[xx,yy,zz]= sphere(n);
surf(r*(xx+X),r*(yy+Y),r*(zz+Z),...
    'EdgeColor','none',...
    'FaceColor',col,...
    'FaceLighting','phong')


