function freq = freqest(x,fs)
% Estimates the dominant frequency of a signal.
% The dominant frequency is defined as the frequency where 
% the power of the power of the spectrum has its maximum.
%
% x:     Vector containing the signal
% fs:    Sampling frequency
%
% Example 
% -------
% n=0:200; f0=0.02; x=square(2*pi*f0*n); 
% freq=freqest(x,1)

% ---------------------  Jan. 4. 2000 /  Daniel von Grünigen  ---------------------------
%
%
% Part of software package for the book:  D.Ch. von Grünigen, "Digitale Signalverarbeitung"
%                                         Leipzig Verlag, 2000
% ---------------------------------------------------------------------------------------


% If a row, turn into column vector
[m,n] = size(x);
if m == 1		x = x(:);
end

% Determine the frequency bin kmax, where the DFT of x has its maximum
x=detrend(x,'constant'); Xabs=abs(fft(x)); 
N=ceil(length(x)/2);
Xabs=Xabs(1:N);
[Xmax,kmax]=max(Xabs);

% Window Xabs with a 7-point rectangular window
if kmax-3<1
   error('length of signal to small')
end
w=zeros(N,1); w(kmax-3:kmax+3)=ones(1,7); Xabs=w.*Xabs;

% Normalize Xabs
Xabs=Xabs/sum(Xabs);

% Determine the center of gravity (first moment)
k=[0:N-1]'; freq=fs/length(x)*sum(k.*Xabs);