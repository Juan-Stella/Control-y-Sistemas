clc;
clear;
close all;

load('Tchaikovsky.mat');

fs = Fs;
x = signal(:,1);   % canal 1

Hd = filtro_pto4;  % crear el filtro

x_filtered = filter(Hd, x);   % aplicar el filtro a la señal

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

sound(x, fs)
sound(x_filtered, fs)