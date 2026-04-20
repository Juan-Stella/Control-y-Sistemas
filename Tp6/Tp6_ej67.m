% iir_fixed_verify.m
% Verifica las funciones Q15 comparándolas contra la salida en punto
% flotante y contra filtfilt() de MATLAB.
%
% Compilar primero:
clc; clear; close all;

%% ── Señal de prueba (misma que iir_online.m) ────────────────────────────
Fn1 = 300;  Fn2 = 600;  Fn3 = 50;
Fs  = 10000;
dt  = 1/Fs;
t   = (0:dt:dt*1000)';

adc_signal   = sin(2*pi*Fn1*t) + sin(2*pi*Fn2*t) + 0.25*sin(2*pi*Fn3*t);
adc_signal_f = single(adc_signal);   % float obligatorio para el wrapper

%% ── Filtrado en MATLAB (referencia) ─────────────────────────────────────
Hd  = irr_elliptic_200_800();
SOS = Hd.sosMatrix;
G   = Hd.ScaleValues;
out_matlab = filtfilt(SOS, G, adc_signal);

%% ── Filtrado en C punto flotante (iir_online referencia) ────────────────
% (requiere tener compilado el wrapper flotante del punto 5)
% out_float = zeros(size(adc_signal_f));
% for j = 1:length(adc_signal_f)
%     out_float(j) = iir_wrapper(adc_signal_f(j));
% end

%% ── Filtrado en C punto fijo Q15 ────────────────────────────────────────
out_fixed = zeros(size(adc_signal_f), 'single');

for j = 1:length(adc_signal_f)
    out_fixed(j) = iir_wrapper_fixed( adc_signal_f(j) );
end

%% ── Gráficas en el tiempo ───────────────────────────────────────────────
figure('Name', 'Verificación Q15 — Tiempo');

subplot(3,1,1);
plot(t, adc_signal, 'k', 'LineWidth', 1);
title('Señal de entrada'); ylabel('Amplitud'); grid on;

subplot(3,1,2);
plot(t, out_matlab, 'b', 'LineWidth', 1.2);
title('Salida MATLAB (filtfilt)'); ylabel('Amplitud'); grid on;

subplot(3,1,3);
plot(t, out_fixed,  'r', 'LineWidth', 1.2); hold on;
plot(t, out_matlab, 'b--', 'LineWidth', 0.8);
title('Salida C Q15 vs MATLAB');
ylabel('Amplitud'); xlabel('Tiempo [s]');
legend('C Q15', 'MATLAB'); grid on;

sgtitle('Verificación IIR punto fijo Q15');

%% ── Espectro ────────────────────────────────────────────────────────────
[f1, mag_in]  = my_dft(adc_signal,        Fs);
[f2, mag_mat] = my_dft(out_matlab,         Fs);
[f3, mag_fix] = my_dft(double(out_fixed),  Fs);

figure('Name', 'Verificación Q15 — Espectro');
plot(f1, mag_in,  'k',  'LineWidth', 0.8, 'DisplayName', 'Entrada');   hold on;
plot(f2, mag_mat, 'b--','LineWidth', 1.2, 'DisplayName', 'MATLAB');
plot(f3, mag_fix, 'r',  'LineWidth', 1.2, 'DisplayName', 'C Q15');
xlabel('Frecuencia [Hz]'); ylabel('Magnitud');
title('Espectro — Q15 vs MATLAB'); legend; grid on;

%% ── Error cuadrático medio ──────────────────────────────────────────────
mse = mean((out_matlab - double(out_fixed)).^2);
fprintf('Error cuadrático medio (MATLAB vs Q15): %.6f\n', mse);