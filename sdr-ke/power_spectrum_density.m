function [p,f,t]=power_spectrum_density(x,fs,len,m,window)
% [p,f,t] = power_spectrum_density(x,fs,len,m,window)
%
% Calculation of power spectrum density (PSD)
%
%     x      - input signal
%     fs     - sample rate
%     len    - length of the spectrum (= length of FFT)
%     m      - averaging factor (optional)
%     window - window function for FFT (optional)
%     p      - power spectrum density in dB
%     f      - frequency grid
%     t      - time grid
%
% If m is omitted or m <= 0, a single PSD is calculated which includes the
% whole signal. If m > 0, multiple PSDs are calculated by averaging m FFTs.
%
%------------------------------------------------
% (c) Eberhard Gamm (www.ibega.de),
%     LIKE (www.like.e-technik.uni-erlangen.de),
%     2013
%------------------------------------------------

if nargin < 2
    fs=1;
end
if nargin < 3
    len=256;
end
if nargin < 4
    m=0;
end
if nargin < 5
    window=blackman_window(len);
end

f=(-len/2:len/2-1)*fs/len;

if isempty(x)
    p=zeros(1,len);
    t=0;
    return;
end
if size(x,1) ~= 1
    error('input signal x must be a row vector');
end
if numel(window) ~= len
    error('length of window is invalid');
end
if size(window,1) ~= 1
    window = window.';
end

k=2*floor(length(x)/len)-1;
if (m < 1) || (m > k)
    m=k;
    n=1;
else
    n=floor(k/m);
end
ix=0;
p=zeros(n,len);
for i=1:n
    for k=1:m
        xi=x(ix+1:ix+len).*window;
        xf=fftshift(fft(xi));
        p(i,:)=p(i,:)+abs(xf).^2;
        ix=ix+len/2;
    end
end
p=p/(m*(sum(window))^2);
p_max=max(max(p));
if p_max > 0
    p_min=1e-12*10^ceil(log10(p_max));
    p=10*log10(p+p_min);
else
    error('signal is zero');
end
t=(m+1)*len/(4*fs);
if n > 1
    t=t+(0:n-1)*(m+1)*len/(2*fs);
else
    if nargout == 0
        figure;
        plot(f,p);
        grid;
    end
end
