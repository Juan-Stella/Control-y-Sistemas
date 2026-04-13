clc;
clear;
close all;

%% Parámetros
fs = 10000;
t = (0:1/fs:1)';

% Señal de entrada
x = sin(2*pi*50*t) + sin(2*pi*300*t) + sin(2*pi*600*t);

%% Filtrado en MATLAB (double precisión)
Hd = filtro_pto5;
b = Hd.Numerator;
a = 1;

y_matlab = filter(b, a, x);

%% Filtrado en C (MEX, muestra a muestra)
x_f = single(x);          % la entrada al wrapper debe ser float
s = size(x_f);
M = max(s);

y_c = zeros(s);

for j = 1:M
    y_c(j) = fir_wrapper(x_f(j));
end

%% =========================
%% d) Gráficas en tiempo
%% =========================

figure;

subplot(3,1,1)
plot(t, x, 'k')
grid on
title('Señal sin filtrar')
xlabel('Tiempo [s]')
ylabel('Amplitud')
xlim([0 0.05])

subplot(3,1,2)
plot(t, y_matlab, 'b')
grid on
title('Señal filtrada en MATLAB')
xlabel('Tiempo [s]')
ylabel('Amplitud')
xlim([0 0.05])

subplot(3,1,3)
plot(t, y_c, 'r--')
grid on
title('Señal filtrada en C')
xlabel('Tiempo [s]')
ylabel('Amplitud')
xlim([0 0.05])

figure;
plot(t, x, 'k')
hold on
plot(t, y_matlab, 'b')
plot(t, y_c, 'r--')
legend('INPUT SIGNAL', 'FIR OUTPUT MATLAB', 'FIR OUTPUT C')
grid on
title('Comparación en el dominio del tiempo')
xlabel('Tiempo [s]')
ylabel('Amplitud')
xlim([0 0.05])

%% =========================
%% e) Espectros con my_dft
%% =========================

[f1, mag_x] = my_dft(x, fs);
[f2, mag_c] = my_dft(y_c, fs);
[f3, mag_m] = my_dft(y_matlab, fs);

figure;
plot(f1, mag_x, '-k', 'LineWidth', 1.2)
hold on
plot(f2, mag_m, '--b', 'LineWidth', 1.2)
plot(f3, mag_c, '--r', 'LineWidth', 1.2)
legend('INPUT SIGNAL', 'FIR OUTPUT MATLAB', 'FIR OUTPUT C')
grid on
title('Espectros de la señal original y filtradas')
xlabel('Frecuencia [Hz]')
ylabel('Magnitud')
xlim([0 1000])

%% Opcional: error entre MATLAB y C
error_mc = rmse(y_matlab, y_c)