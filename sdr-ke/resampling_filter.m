function h = resampling_filter(M)
% h = resampling_filter(M)
%
% FIR lowpass filter for resampling
%
%   M - ratio of sampling rates (M >= 1)
%
%------------------------------------------------
% (c) Eberhard Gamm (www.ibega.de),
%     LIKE (www.like.e-technik.uni-erlangen.de),
%     2013
%------------------------------------------------

N_h = floor( 16 * M );
n = 1 : N_h;
K = 1.11;
h = sin( pi * n / ( K * M ) ) ./ ( pi * n ) ;
h = [ fliplr(h)  1/(K * M)  h ] .* kaiser_window( 2 * N_h + 1, 6 );

if nargout == 0
    [H,f] = freqz(h, 1, 2^ceil(10+log2(M)), 1);
    H = 20 * log10(abs(H));
    close all;
    figure(1);
    subplot(2,1,1);
    plot(f,H);
    hold on;
    plot(1/M-f,H,'r-');
    hold off;
    axis([0 0.5/M -120 10]);
    grid;
    xlabel('f / f_a');
    ylabel('|H| [dB]');
    title('Frequency response (blue) and alias response (red)');
    subplot(2,1,2);
    plot(f,H);
    axis([0 0.5/M -3 0.1]);
    grid;
    xlabel('f / f_a');
    ylabel('|H| [dB]');
    title('Passband response');
    fprintf(1,'Number of coefficients: %d\n',length(h));
    clear h;
end
