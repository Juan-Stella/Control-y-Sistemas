clc;
clear;
close all;

fs = 1000;      
f = 100;       
t = 0:1/fs:1; 
snr = 10;       % SNR en dB

signal = sin(2*pi*f*t);

signal_n = my_awgn(signal, snr);

% Señal con ruido usando awgn de MATLAB
signal_awgn = awgn(signal, snr, 'measured');

% RMSE
r1 = rmse(signal, signal_n);
r2 = rmse(signal, signal_awgn);

fprintf('RMSE con my_awgn: %.6f\n', r1);
fprintf('RMSE con awgn: %.6f\n', r2);

% Gráficas
figure;
plot(t, signal, 'b', 'LineWidth', 1.5);
hold on;
plot(t, signal_n, 'r');
plot(t, signal_awgn, 'g');
grid on;
xlim([0 0.2]) 
legend('Señal original', 'Señal con my\_awgn', 'Señal con awgn');
xlabel('Tiempo [s]');
ylabel('Amplitud');
title('Comparación de señal original y señales con ruido');