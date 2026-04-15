clc;
clear;
close all;

load('Tchaikovsky.mat');

fs = Fs;
x = signal(:,1);   % canal 1

Hd = filtro_pto4;  % crear el filtro

b = Hd.Numerator;
x_filtered = filter(b, 1, x);

[f_orig, mag_orig] = my_dft(x, fs);
[f_filt, mag_filt] = my_dft(x_filtered, fs);

figure;
plot(f_orig, mag_orig, 'b'); hold on;
plot(f_filt, mag_filt, 'r');
grid on;
legend('Original','Filtrada');
xlabel('Frecuencia [Hz]');
ylabel('Magnitud');
title('Espectros de la señal original y filtrada');
xlim([0 4000])

%sound(x_filtered, fs)

% Comparación N=10, N=100 y N=1000
Hd10 = Copy_of_filtro_pto4;  % crear el filtro
hd1000 = Copy_2_of_filtro_pto4;
b10   = Hd10.Numerator;
b100  = Hd.Numerator;
b1000 = hd1000.Numerator;

[H10,   f] = freqz(b10,   1, 1024, 44100);
[H100,  ~] = freqz(b100,  1, 1024, 44100);
[H1000, ~] = freqz(b1000, 1, 1024, 44100);

figure;
plot(f, 20*log10(abs(H10)),   'r'); hold on;
plot(f, 20*log10(abs(H100)),  'b');
plot(f, 20*log10(abs(H1000)), 'g');
legend('N=10', 'N=100', 'N=1000');
grid on;
xlabel('Frecuencia [Hz]');
ylabel('Magnitud [dB]');
title('Respuesta en frecuencia: N=10 vs N=100 vs N=1000');

