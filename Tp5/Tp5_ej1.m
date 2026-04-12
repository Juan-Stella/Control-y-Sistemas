clc;
clear;
close all;

fs = 2000;      
f = 100;       
t = 0:1/fs:1; 
snr = 15;       % SNR en dB

signal = sin(2*pi*f*t);

% Señal con ruido usando awgn de MATLAB
signal_awgn = awgn(signal, snr, 'measured');

fco = 200;
Fco = fco/fs;
Omegaco = Fco*pi/0.5;
M = round(pi/Omegaco)
b = (1/M)*ones(1,M);
a = 1;

senal_filtrada = filter(b,a,signal_awgn);

% Punto e) Respuesta en frecuencia y fase del filtro MA
figure;
freqz(b,a,1024,fs);
title(['Respuesta en frecuencia y fase del filtro MA, M = ', num2str(M)]);

% =========================
% Punto f) Dominio del tiempo
% =========================

figure;
xlim([0 0.2]) 
subplot(3,1,1)
plot(t, signal,'b','LineWidth',1.5);
grid on;
title('Señal original');
xlabel('Tiempo [s]');
ylabel('Amplitud');
xlim([0 0.05]) 
subplot(3,1,2)
plot(t, signal_awgn,'r');
grid on;
title('Señal con ruido');
xlabel('Tiempo [s]');
ylabel('Amplitud');
xlim([0 0.05]) 
subplot(3,1,3)
plot(t, senal_filtrada,'k','LineWidth',1.2);
grid on;
title(['Señal filtrada (M = ', num2str(M), ')']);
xlabel('Tiempo [s]');
ylabel('Amplitud');
xlim([0 0.05]) 
% Comparación en un mismo gráfico 
figure;
plot(t, signal,'b','LineWidth',1.5); hold on;
plot(t, signal_awgn,'r');
plot(t, senal_filtrada,'k','LineWidth',1.2);
grid on;
legend('Original','Con ruido','Filtrada');
title(['Comparación de señales (M = ', num2str(M), ')']);
xlabel('Tiempo [s]');
ylabel('Amplitud');
xlim([0 0.05]) 

% =========================
% Punto g) Comparación en frecuencia
% =========================

[f_orig, mag_orig] = my_dft(signal, fs);
[f_ruido, mag_ruido] = my_dft(signal_awgn, fs);
[f_filt, mag_filt] = my_dft(senal_filtrada, fs);

figure;
plot(f_orig, mag_orig, 'b', 'LineWidth', 1.5); hold on;
plot(f_ruido, mag_ruido, 'r', 'LineWidth', 1);
plot(f_filt, mag_filt, 'k', 'LineWidth', 1.2);
grid on;
legend('Original','Con ruido','Filtrada');
title(['Comparación en frecuencia (M = ', num2str(M), ')']);
xlabel('Frecuencia [Hz]');
ylabel('Magnitud');
xlim([0 fs/10]);


%N = Nmax/2
M = round(pi/Omegaco)
M = round(M/2)
b = (1/M)*ones(1,M);
a = 1;

senal_filtrada = filter(b,a,signal_awgn);

% Punto e) Respuesta en frecuencia y fase del filtro MA
figure;
freqz(b,a,1024,fs);
title(['Respuesta en frecuencia y fase del filtro MA, M = ', num2str(M)]);

% =========================
% Punto f) Dominio del tiempo
% =========================

figure;
xlim([0 0.2]) 
subplot(3,1,1)
plot(t, signal,'b','LineWidth',1.5);
grid on;
title('Señal original');
xlabel('Tiempo [s]');
ylabel('Amplitud');
xlim([0 0.05]) 
subplot(3,1,2)
plot(t, signal_awgn,'r');
grid on;
title('Señal con ruido');
xlabel('Tiempo [s]');
ylabel('Amplitud');
xlim([0 0.05]) 
subplot(3,1,3)
plot(t, senal_filtrada,'k','LineWidth',1.2);
grid on;
title(['Señal filtrada (M = ', num2str(M), ')']);
xlabel('Tiempo [s]');
ylabel('Amplitud');
xlim([0 0.05]) 
% Comparación en un mismo gráfico 
figure;
plot(t, signal,'b','LineWidth',1.5); hold on;
plot(t, signal_awgn,'r');
plot(t, senal_filtrada,'k','LineWidth',1.2);
grid on;
legend('Original','Con ruido','Filtrada');
title(['Comparación de señales (M = ', num2str(M), ')']);
xlabel('Tiempo [s]');
ylabel('Amplitud');
xlim([0 0.05]) 

% =========================
% Punto g) Comparación en frecuencia
% =========================

[f_orig, mag_orig] = my_dft(signal, fs);
[f_ruido, mag_ruido] = my_dft(signal_awgn, fs);
[f_filt, mag_filt] = my_dft(senal_filtrada, fs);

figure;
plot(f_orig, mag_orig, 'b', 'LineWidth', 1.5); hold on;
plot(f_ruido, mag_ruido, 'r', 'LineWidth', 1);
plot(f_filt, mag_filt, 'k', 'LineWidth', 1.2);
grid on;
legend('Original','Con ruido','Filtrada');
title(['Comparación en frecuencia (M = ', num2str(M), ')']);
xlabel('Frecuencia [Hz]');
ylabel('Magnitud');
xlim([0 fs/10]);


%N = Nmax*10
M = round(pi/Omegaco)
M = M*10
b = (1/M)*ones(1,M);
a = 1;

senal_filtrada = filter(b,a,signal_awgn);

% Punto e) Respuesta en frecuencia y fase del filtro MA
figure;
freqz(b,a,1024,fs);
title(['Respuesta en frecuencia y fase del filtro MA, M = ', num2str(M)]);

% =========================
% Punto f) Dominio del tiempo
% =========================

figure;
xlim([0 0.2]) 
subplot(3,1,1)
plot(t, signal,'b','LineWidth',1.5);
grid on;
title('Señal original');
xlabel('Tiempo [s]');
ylabel('Amplitud');
xlim([0 0.05]) 
subplot(3,1,2)
plot(t, signal_awgn,'r');
grid on;
title('Señal con ruido');
xlabel('Tiempo [s]');
ylabel('Amplitud');
xlim([0 0.05]) 
subplot(3,1,3)
plot(t, senal_filtrada,'k','LineWidth',1.2);
grid on;
title(['Señal filtrada (M = ', num2str(M), ')']);
xlabel('Tiempo [s]');
ylabel('Amplitud');
xlim([0 0.05]) 
% Comparación en un mismo gráfico 
figure;
plot(t, signal,'b','LineWidth',1.5); hold on;
plot(t, signal_awgn,'r');
plot(t, senal_filtrada,'k','LineWidth',1.2);
grid on;
legend('Original','Con ruido','Filtrada');
title(['Comparación de señales (M = ', num2str(M), ')']);
xlabel('Tiempo [s]');
ylabel('Amplitud');
xlim([0 0.05]) 

% =========================
% Punto g) Comparación en frecuencia
% =========================

[f_orig, mag_orig] = my_dft(signal, fs);
[f_ruido, mag_ruido] = my_dft(signal_awgn, fs);
[f_filt, mag_filt] = my_dft(senal_filtrada, fs);

figure;
plot(f_orig, mag_orig, 'b', 'LineWidth', 1.5); hold on;
plot(f_ruido, mag_ruido, 'r', 'LineWidth', 1);
plot(f_filt, mag_filt, 'k', 'LineWidth', 1.2);
grid on;
legend('Original','Con ruido','Filtrada');
title(['Comparación en frecuencia (M = ', num2str(M), ')']);
xlabel('Frecuencia [Hz]');
ylabel('Magnitud');
xlim([0 fs/10]);