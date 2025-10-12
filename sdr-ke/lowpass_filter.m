function h = lowpass_filter(B_rel,beta,N)
% h = lowpass_filter(B_rel,beta,N)
%
% FIR lowpass filter with relative bandwidth bw
%
%   B_rel - relative bandwidth (0.01 ... 0.8)
%   beta  - parameter for Kaiser window (optional)
%   N     - number of coefficients (optional)
%
%------------------------------------------------
% (c) Eberhard Gamm (www.ibega.de),
%     LIKE (www.like.e-technik.uni-erlangen.de),
%     2013
%------------------------------------------------

if ( B_rel < 0.01 ) || ( B_rel > 0.8 )
    error('use 0.01 <= B_rel <= 0.8');
end
if nargin < 2
    beta = 9;
end
if nargin < 3
    N_h = ceil( 16 / B_rel );
else
    N_h = ( N - 1 ) / 2;
end

if mod( N_h, 1 ) == 0
    % number of coefficients is odd
    n = 1 : N_h;
    h = sin( 1.1 * pi * B_rel * n ) ./ ( pi * n ); 
    h = [ fliplr(h)  1.1 * B_rel  h ];
else
    % number of coefficients is even
    n = 0.5 : 1 : N_h;
    h = sin( 1.1 * pi * B_rel * n ) ./ ( pi * n ); 
    h = [ fliplr(h) h ];
end
% weighting with Kaiser window
h = h .* kaiser_window( 2 * N_h + 1, beta );

if nargout == 0
    [H,f] = freqz(h, 1, 2^ceil(10-log2(B_rel)), 1);
    H = 20 * log10(abs(H));
    close all;
    figure(1);
    subplot(2,1,1);
    plot(f,H);
    axis([0 0.5 -120 10]);
    grid;
    xlabel('f / f_a');
    ylabel('|H| [dB]');
    title('Frequency response');
    subplot(2,1,2);
    plot(f,H);
    axis([0 0.625 * B_rel -3 0.1]);
    grid;
    xlabel('f / f_a');
    ylabel('|H| [dB]');
    title('Passband response');
    fprintf(1,'Number of coefficients: %d\n',length(h));
    clear h;
end
