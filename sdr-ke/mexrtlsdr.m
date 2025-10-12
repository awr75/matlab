function [r1,r2,r3,r4,r5] = mexrtlsdr(func,p1,p2,p3,p4,p5,p6)
% [...] = mexrtlsdr(func,...)
%
%   Read complex baseband data from RTL-SDR USB stick
%
%   1) Open device: mexrtlsdr('open')
%
%   2) Get MGC values: mgc = mexrtlsdr('mgc')
%        mgc  = tuner gains in dB for manual gain control
%
%   3) Initialization: [len,tref,srad] = mexrtlsdr('init',sr,bw,freq,bps,buf,mgci)
%        sr   = sample rate in samples per second
%        bw   = bandwidth in Hz (bw <= 0.8 * sr)
%        freq = center frequency in Hz
%        bps  = data blocks per second (1...100)
%        buf  = number of internal buffers (2...100)
%        mgci = manual gain selection (1...length(mgc), 0 = AGC)
%        len  = length of a single data block; calculated
%               by rounding sr/bps to a multiple of 256
%        tref = reference time for TOA calculations
%        srad = sample rate of the A-to-D converters
%
%   4) Get data: [data,id,toa,wt] = mexrtlsdr('data',wait)
%        wait = 1: wait for data
%        wait = 0: return data=[], if no data are available
%        data = row vector with complex baseband data block
%        id   = sequence number; may be checked for consecutive
%               values to detect lost data blocks
%        freq = center frequency of the data block
%        toa  = time of arrival of the data block
%        wt   = waiting time for the data block
%
%   5) Change frequency: mexrtlsdr('freq',freq)
%      f  req = center frequency in Hz
%
%   6) Stop: mexrtlsdr('stop')
%
%   7) Close device: mexrtlsdr('close')
%
%   NOTE: There is no method 'start' to start the reception, because this
%         is done automatically when 'data' is called for the first time.
%         But there is a method 'stop' to stop the reception.
%
%------------------------------------------------
% (c) Eberhard Gamm (www.ibega.de),
%     LIKE (www.like.e-technik.uni-erlangen.de),
%     2013
%------------------------------------------------

persistent sys_id;

if isempty(sys_id)
    sys_id = check_system;
end
if ~exist('libusb-1.0.dll','file');
    stat = 0;
    if sys_id == 3
        stat = system('copy libusb-1.0-mingw32.dll libusb-1.0.dll > NUL');
        print_flush('LIBUSB fuer Octave 32-bit aktiviert.\n');
    end
    if sys_id == 4
        stat = system('copy libusb-1.0-mingw64.dll libusb-1.0.dll > NUL');
        print_flush('LIBUSB fuer Octave 64-bit aktiviert.\n');
    end
    if stat ~= 0
        error('LIBUSB konnte nicht kopiert werden');
    end
end

if nargin == 0
    switch sys_id,
        case 1,
            mexrtlsdr_matlab_32;
        case 2,
            mexrtlsdr_matlab_64;
        case 3,
            mexrtlsdr_octave_32;
        case 4,
            mexrtlsdr_octave_64;
        case 5,
            mexrtlsdr_octave_linux;
        otherwise,
            error('Nicht unterstuetzt');
    end
    return;
end

if nargin < 7
    p6 = 0;
end
if nargin < 6
    p5 = 0;
end
if nargin < 5
    p4 = 0;
end
if nargin < 4
    p3 = 0;
end
if nargin < 3
    p2 = 0;
end
if nargin < 2
    p1 = 0;
end

switch sys_id,
    case 1,
        [r1,r2,r3,r4,r5] = mexrtlsdr_matlab_32(func,p1,p2,p3,p4,p5,p6);
    case 2,
        [r1,r2,r3,r4,r5] = mexrtlsdr_matlab_64(func,p1,p2,p3,p4,p5,p6);
    case 3,
        [r1,r2,r3,r4,r5] = mexrtlsdr_octave_32(func,p1,p2,p3,p4,p5,p6);
    case 4,
        [r1,r2,r3,r4,r5] = mexrtlsdr_octave_64(func,p1,p2,p3,p4,p5,p6);
    case 5,
        [r1,r2,r3,r4,r5] = mexrtlsdr_octave_linux(func,p1,p2,p3,p4,p5,p6);
    otherwise,
        error('Nicht unterstuetzt');
end
