function sdr_gray_codes
% Berechnung der Gray-Codes bis m=4 bzw. M = 16

m_max = 4;
code  = 0;
for i = 1 : m_max
    % Code berechnen
    code = [ code fliplr(code) + 2^(i-1) ];
    % Code ausgeben
    fprintf( 1, 'Gray(%d) = [ ', i );
    for k = 1 : 2^i
        fprintf( 1, '%d ', code(k) );
    end
    fprintf( 1, ']\n' );
end
