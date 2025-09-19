function tetraeder = tetraeder(R,col)
% R ist der Vektor zur linken unteren Ecke
% col ist die Linienfarbe
% ruft Funktion linie.m auf

u1 = .25*[1,1,1];
Ra = R + [.5,.5,0];		% Mitte untere Fl�che
Rb = R + [.5,0,.5];		% Mitte vordere Fl�che
Rc = R + [0,.5,.5];		% Mitte linke Fl�che
R11 = R + u1;


linie(R11,R,6,col); hold on;
linie(R11,Ra,6,col);
linie(R11,Rb,6,col);
linie(R11,Rc,6,col);
