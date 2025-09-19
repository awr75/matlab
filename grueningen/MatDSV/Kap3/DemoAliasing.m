% M-File  DemoAliasing.m      
% Dieses M-File demonstriert Aliasing

% Quelle: http://www-mmdb.iai.uni-bonn.de/lehre/BIT/ss03_DSP_Vorlesung/matlab_demos/

home
disp('Aliasing-Demonstration')
disp('----------------------')
disp(' '),disp(' ')

clear all;
close all;
colordef black

fs = 2000;
tondauer_in_sek = 0.1;
nsamples = tondauer_in_sek*fs;
t = [0:nsamples-1] / fs;
fs_faktor_fuer_kontinuierlichen_plot = 10;
tkont= [0:nsamples*fs_faktor_fuer_kontinuierlichen_plot-1] / (fs*fs_faktor_fuer_kontinuierlichen_plot);

set(gcf,'Position',[300 90 1023*0.9 768*0.9]);
rect=get(gcf,'Position');
%rect(1:2)=[0 0];
my_movie = moviein(30,gcf,rect);

f1 = 200; a1 = 0.5;
f2 = 400; a2 = 0.3;
f3 = 800; a3 = 0.2;
num_plot_samples = 30;

gesamtsignal = []; gesamtsignalkont = [];
frame_number = 0;
for fshift = 0:10:2000
    y = a1 * sin(2*pi*(f1+fshift)*t) + a2 * sin(2*pi*(f2+fshift)*t) + a3 * sin(2*pi*(f3+fshift)*t);
    ykont = a1 * sin(2*pi*(f1+fshift)*tkont) + a2 * sin(2*pi*(f2+fshift)*tkont) + a3 * sin(2*pi*(f3+fshift)*tkont);
    gesamtsignal = [gesamtsignal y];
    gesamtsignalkont=[gesamtsignalkont ykont];
    
    subplot(2,2,1);
    stem(1000*t(1:num_plot_samples),y(1:num_plot_samples));
    hold on;
    plot(1000*tkont(1:num_plot_samples*fs_faktor_fuer_kontinuierlichen_plot),ykont(1:num_plot_samples*fs_faktor_fuer_kontinuierlichen_plot),'green');
    set(gca,'ylim',[-1 1]);
    hold off;
    %title(strcat('y(t) = a1*sin(2*pi*t*',num2str(f1+fshift),') + a2*sin(2*pi*t*',num2str(f2+fshift),') + a3*sin(2*pi*t*',num2str(f3+fshift),'), sampled at ',num2str(fs),' Hz'));
    title('Audiosignal,  fs=20 kHz')
    xlabel('t in ms'); 
    
    subplot(2,2,4);
    Y = abs(fft(y));
    plot(0.001*[1:ceil(nsamples/2)]/tondauer_in_sek,Y(1:ceil(nsamples/2)));
    set(gca,'ylim',[0 60]);
    %title(strcat('Spectrum of y, sampled at ',num2str(fs),' Hz'));
    title('Spektrum des unterabgetasteten Audiosignals')
    xlabel('f in kHz'); 
    
    interpolated_samples = sinc_interpolate(y(1:num_plot_samples),fs,fs*fs_faktor_fuer_kontinuierlichen_plot);
    subplot(2,2,2);
    stem(1000*t(1:num_plot_samples),y(1:num_plot_samples));
    hold on;    
    plot(1000*tkont(1:length(interpolated_samples)),interpolated_samples,'cyan');
    set(gca,'ylim',[-1 1]);
    hold off;
    %title('Reconstruction of y from its samples using Shannon''s theorem');
    title('Unterabgetastetes Audiosignal,  fs=2 kHz')
    xlabel('t in ms');
    
    subplot(2,2,3);
    Ykont = abs(fft(ykont));
    plot(0.001*[1:ceil(nsamples*fs_faktor_fuer_kontinuierlichen_plot/2)]/tondauer_in_sek,Ykont(1:ceil(nsamples*fs_faktor_fuer_kontinuierlichen_plot/2)));
    set(gca,'ylim',[0 400]);
    %title(strcat('Spectrum of y, sampled at ',num2str(fs*fs_faktor_fuer_kontinuierlichen_plot),' Hz'));
    title('Spektrum des Audiosignals')
    xlabel('f in kHz'); 
    
    %wavplay(y,fs);
    
    frame_number = frame_number + 1;
    my_movie(frame_number) = getframe(gcf,rect);
end;

fs_durch_M=fs; fs=10*fs;


disp(' '),disp('Weiter mit ENTER'), pause
disp(' '),disp(' ')
disp('Audiosignal')
disp(['fs= ',num2str(fs/1000),' kHz'])
sound(gesamtsignalkont,fs);
disp(' '),disp('Weiter mit ENTER'), pause
disp(' '),disp(' ')

disp(' '),disp(' ')
disp('Unterabgetastetes Audiosignal')
disp(['fs= ',num2str(fs_durch_M/1000),' kHz'])
sound(gesamtsignal,fs_durch_M);  
disp(' '),disp('Abschliessen mit ENTER'), pause, close

%movie2avi(my_movie,'sinus_aliasing.avi','compression','indeo5','fps',10);