function sdr_crc_beispiel
% Beispiel zur Berechnung einer CRC
%
%------------------------------------------------
% (c) Eberhard Gamm (www.ibega.de),
%     LIKE (www.like.e-technik.uni-erlangen.de),
%     2013
%------------------------------------------------

% CRC-Polynom 0xC86C = 1100 1000 0110 1100 (Darstellung nach Koopman)
% - OHNE die fuehrende Eins und MIT nachfolgender Eins
poly = [ 1 0 0  1 0 0 0  0 1 1 0  1 1 0 0  1 ];

% Anzahl CRC-Bits
l_crc = length(poly);

% Nutzdaten
b_u = [ 1 0 1 0 0 0 1 1 0 1 1 1 0 1 1 0 0 1 0 1 ];
l_u = length(b_u);

% CRC-Berechnung
fprintf(1,'CRC-Berechnung:\n');
reg = b_u( 1 : l_crc );
for i = 1 + l_crc : l_u
    reg = mod( [ reg(2:end) b_u(i) ] + reg(1) * poly, 2 );
    print_reg(reg);
end
for i = 1 : l_crc
    reg = mod( [ reg(2:end) 0 ] + reg(1) * poly, 2 );
    print_reg(reg);
end
b_crc = reg;

% CRC-geschuetzte Daten bilden
b_p = [ b_u b_crc ];
l_p = length(b_p);

% ggf. Erzeugung von Bitfehlern durch Invertierung
% b_p(9) = 1 - b_p(9);

% CRC-Pruefung
fprintf(1,'CRC-Pruefung:\n');
reg = b_p( 1 : l_crc );
for i = 1 + l_crc : l_p
    reg = mod( [ reg(2:end) b_p(i) ] + reg(1) * poly, 2 );
    print_reg(reg);
end
crc_ok = ( sum(reg) == 0 );
if crc_ok == 1
    fprintf(1,'CRC_OK\n');
else
    fprintf(1,'CRC_NOK\n');
end

function print_reg(reg)
fprintf(1,' reg = ');
for i = 1:length(reg)
    fprintf(1,'%d',reg(i));
end
fprintf(1,'\n');
