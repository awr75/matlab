function [h,h_hb,h_hb_iter] = halfband_filter(k,a)
% [h,h_hb] = halfband_filter(k,a)
%
% FIR halfband filter for downsampling
%
%   k - number of minor halfband coefficients (k >= 1)
%   a - stopband attenuation in dB
%
%------------------------------------------------
% (c) Eberhard Gamm (www.ibega.de),
%     LIKE (www.like.e-technik.uni-erlangen.de),
%     2013
%------------------------------------------------

alpha = 10^(-a/20);

if k > 1
    % Startwerte berechnen (idealer Tiefpass = sin(x)/x)
    n = 1 : 2 : 2 * k - 1;
    h_hb = [ 0.5  sin( 0.5 * pi * n ) ./ ( pi * n ) ];
    % Frequenzachse fuer Nullstellensuche (0.25 ... 0.49)
    f = 0.25 + ( 0 : 2400 ) / 10000;
    % Sollwerte fuer die Verstaerkung bilden
    H_s = zeros( 1 , k+1 );
    if mod( k , 2 ) == 0
        H_s(1) = 1 - alpha;
    else
        H_s(1) = 1 + alpha;
    end
    for i = 1 : k
        H_s(i+1) = (-1)^i * alpha;
    end
    % Jacobi-Matrix vorbelegen
    J = ones( k+1 , k+1 );
    % iterative Berechnung
    iter = 0;
    h_hb_iter = zeros( 200, k + 1 );
    while 1
        
        % Werte speichern
        if iter < 200
            iter = iter + 1;
            h_hb_iter( iter, : ) = h_hb;
        end
        % Ableitung des Frequenzgangs berechnen
        s = zeros( 1, length(f) );
        for i = 1 : k
            s = s + h_hb(i+1) * ( 2 * i - 1 ) * ...
                      sin( 2 * pi * ( 2 * i - 1 ) * f );
        end
        % Null-Werte ersetzen
        s( s == 0 ) = 1e-12;
        % Nulldurchgaenge der Ableitung ermitteln
        f_t = f( ( s( 1 : end - 1 ) .* s( 2 : end ) < 0 ) > 0 );
        % Frequenzen fuer die k+1 Bedingungen bilden
        f_x = [ 0 f_t 0.5 ];
        % Verstaerkungen fuer die k+1 Bedingungen berechnen
        H_x = h_hb(1) * ones( 1, length(f_x) );
        for i = 1 : k
            H_x = H_x + 2 * h_hb(i+1) * cos( 2 * pi * ( 2 * i - 1 ) * f_x );
        end
        % Verstaerkungsfehler berechnen
        dH = H_s - H_x;
        if max( abs( dH ) ) < alpha / 100
            break;
        end
        % Jacobi-Matrix berechnen
        for i = 1 : k
            J( i+1 , : ) = 2 * cos( 2 * pi * ( 2 * i - 1 ) * f_x );
        end
        % Gradientenschritt
        h_hb = h_hb + 0.1 * dH * inv(J);
    end
    h_hb_iter = h_hb_iter( 1 : iter, : );
    % FIR-Koeffizientensatz berechnen
    h = kron( h_hb( 2 : end ), [ 1 0 ] );
    h = h( 1 : end - 1 );
    h = [ fliplr(h) h_hb(1) h ];
else
    % Spezialfall k=1
    h = 0.25 * [ 1+alpha 2-2*alpha 1+alpha ];
    h_hb = h( 2 : end );
    h_hb_iter = h_hb;
end

if nargout == 0
    [H,f] = freqz(h, 1, 10000, 1);
    H = 20 * log10(abs(H));
    close all;
    figure(1);
    subplot(2,1,1);
    plot(f,H);
    hold on;
    plot(0.5-f,H,'r-');
    hold off;
    axis([0 0.25 -120 10]);
    grid;
    xlabel('f / f_a');
    ylabel('|H| [dB]');
    title('Frequency response (blue) and alias response (red)');
    subplot(2,1,2);
    plot(f,H);
    axis([0 0.25 -3 0.1]);
    grid;
    xlabel('f / f_a');
    ylabel('|H| [dB]');
    title('Passband response');
    fprintf('Bandwidth: B / f_a = %g\n',2*(0.5-f(find(H < -a,1,'first'))));
    clear h h_hb;
end
