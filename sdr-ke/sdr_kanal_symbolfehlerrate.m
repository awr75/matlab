function sdr_kanal_symbolfehlerrate
% Symbolfehlerraten fuer verschiedene Modulationsalphabete
%
%------------------------------------------------
% (c) Eberhard Gamm (www.ibega.de),
%     LIKE (www.like.e-technik.uni-erlangen.de),
%     2013
%------------------------------------------------

close all;

snr = -2:0.2:28;
ser_2psk=mpsk_ber(snr,2);
ser_4psk=2*mpsk_ber(snr,4);
ser_8psk=3*mpsk_ber(snr,8);
ser_16qam=4*mqam_ber(snr,16);
ser_64qam=4*mqam_ber(snr,64);

figure(1);
semilogy(snr,ser_2psk,'b-','Linewidth',2);
hold on;
semilogy(snr,ser_4psk,'r-','Linewidth',2);
semilogy(snr,ser_8psk,'-','Color',[0 0.5 0],'Linewidth',2);
semilogy(snr,ser_16qam,'m-','Linewidth',2);
semilogy(snr,ser_64qam,'k-','Linewidth',2);
hold off;
grid;
axis([min(snr) max(snr) 1e-6 0.1]);
xlabel('SNR [dB]');
ylabel('SER');
title('Symbolfehlerraten (SER)');
legend('2PSK','4PSK','8PSK','16QAM','64QAM','Location','SouthWest');

function ber=mpsk_ber(snr,m)
% ber = mpsk_ber(snr,m)
%
% Theoretische BER fuer M-PSK
%   snr - E_s/N_0 in dB
%   m   - PSK-Wertigkeit M (m=2,4,8,...)
%   ber - Bitfehlerrate
%
% Quelle:
% Lu et al: M-PSK and M-QAM BER Computation Using Signal-Space Concepts,
%           IEEE Trans. Communications, Vol. 47, No. 2, Feb. 1999, 181pp.

if m < 2
    error('m ist ungueltig');
end
n=log2(m);
if n ~= floor(n)
    error('m ist ungueltig');
end

eb_n0=1/n*10.^(snr/10);
ber=zeros(1,length(eb_n0));
for i=1:max(m/4,1)
    ber=ber+erfc(sqrt(n*eb_n0)*sin((2*i-1)*pi/m));
end

ber=ber/max(n,2);

function ber=mqam_ber(snr,m)
% ber = mqam_ber(snr,m)
%
% Theoretische BER fuer M-QAM
%   snr - E_s/N_0 in dB
%   m   - QAM-Wertigkeit M (m=4,16,64,...)
%   ber - Bitfehlerrate
%
% Quelle:
% Lu et al: M-PSK and M-QAM BER Computation Using Signal-Space Concepts,
%           IEEE Trans. Communications, Vol. 47, No. 2, Feb. 1999, 181pp.

if m < 4
    error('m ist ungueltig');
end
n=log2(m);
if n/2 ~= floor(n/2)
    error('m ist ungueltig');
end

eb_n0=1/n*10.^(snr/10);
ber=zeros(1,length(eb_n0));
for i=1:sqrt(m)/2
    ber=ber+erfc((2*i-1)*sqrt(3/2*eb_n0*n/(m-1)));
end

ber=2/n*(1-1/sqrt(m))*ber;
