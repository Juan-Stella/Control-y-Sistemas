clc;
clear;
close all;

% Parámetros
fs = 1000;      % frecuencia de muestreo
f = 100;        % frecuencia de la senoide
t = 0:1/fs:0.5; % vector de tiempo
snr = 10;       % SNR en dB

% Señal original
signal = sin(2*pi*f*t);

% Señal con ruido usando tu función
signal_n = my_awgn(signal, snr);

% Señal con ruido usando awgn de MATLAB
signal_awgn = awgn(signal, snr, 'measured');

% RMSE
r1 = rmse(signal, signal_n);
r2 = rmse(signal, signal_awgn);

% Mostrar resultados
fprintf('RMSE con my_awgn: %.6f\n', r1);
fprintf('RMSE con awgn: %.6f\n', r2);

% Gráficas
figure;
plot(t, signal, 'b', 'LineWidth', 1.5);
hold on;
plot(t, signal_n, 'r');
plot(t, signal_awgn, 'g');
grid on;
legend('Señal original', 'Señal con my\_awgn', 'Señal con awgn');
xlabel('Tiempo [s]');
ylabel('Amplitud');
title('Comparación de señal original y señales con ruido');