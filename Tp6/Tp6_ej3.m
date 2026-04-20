clc;
clear;
close all;

%% ── Cargar ambos filtros ─────────────────────────────────────────────────
Hd_fir = fir_kaiser_3400_44100();      % FIR  — ventana Kaiser
Hd_iir = iir_elliptic_3400_44100();   % IIR  — Elliptic

%% ── b) Tipo de filtro de cada función ───────────────────────────────────
%
%   fir_kaiser_3400_44100:
%       FIR pasa-bajos, diseñado con ventana Kaiser mediante fir1().
%       Fs = 44100 Hz, Fpass = 3400 Hz, Fstop = 3500 Hz
%       Dpass = Dstop = 0.001  (ripple y atenuación)
%
%   iir_elliptic_3400_44100:
%       IIR pasa-bajos Elliptic de orden 10, diseñado con fdesign.lowpass.
%       Fs = 44100 Hz, Fpass = 3400 Hz, Apass = 0.5 dB, Astop = 60 dB
%
fprintf('=== b) Tipo de filtros ===\n');
fprintf('FIR: %s\n', class(Hd_fir));
fprintf('IIR: %s\n', class(Hd_iir));

%% ── Extraer coeficientes ─────────────────────────────────────────────────
% FIR
b_fir = Hd_fir.Numerator;
a_fir = 1;

% IIR — representado como SOS
SOS = Hd_iir.sosMatrix;
G   = Hd_iir.ScaleValues;

% Convertir SOS a polinomios para freqz
[b_iir, a_iir] = sos2tf(SOS, G);

Fs = 44100;

%% ── c) Respuesta en frecuencia (magnitud) ────────────────────────────────
[H_fir, f_fir] = freqz(b_fir, a_fir, 4096, Fs);
[H_iir, f_iir] = freqz(b_iir, a_iir, 4096, Fs);

figure('Name', 'c) Respuesta en frecuencia');

subplot(2,1,1);
plot(f_fir, 20*log10(abs(H_fir)), 'b', 'LineWidth', 1.2); hold on;
plot(f_iir, 20*log10(abs(H_iir)), 'r', 'LineWidth', 1.2);
xlabel('Frecuencia [Hz]'); ylabel('Magnitud [dB]');
title('c) Respuesta en frecuencia — Magnitud');
legend('FIR Kaiser', 'IIR Elliptic');
xlim([0 Fs/2]); ylim([-100 5]);
xline(3400, 'k--', 'Fpass = 3400 Hz', 'LabelVerticalAlignment','bottom');
grid on;

subplot(2,1,2);
plot(f_fir, 20*log10(abs(H_fir)), 'b', 'LineWidth', 1.2); hold on;
plot(f_iir, 20*log10(abs(H_iir)), 'r', 'LineWidth', 1.2);
xlabel('Frecuencia [Hz]'); ylabel('Magnitud [dB]');
title('Zona de transición (zoom)');
legend('FIR Kaiser', 'IIR Elliptic');
xlim([3000 5000]); ylim([-100 5]);
xline(3400, 'k--', 'Fpass'); xline(3500, 'k:', 'Fstop');
grid on;

%% ── d) Respuesta en fase ─────────────────────────────────────────────────
figure('Name', 'd) Respuesta en fase');

subplot(2,1,1);
plot(f_fir, angle(H_fir)*180/pi, 'b', 'LineWidth', 1.2);
xlabel('Frecuencia [Hz]'); ylabel('Fase [°]');
title('d) Fase — FIR Kaiser  (fase lineal)');
xlim([0 Fs/2]); grid on;

subplot(2,1,2);
plot(f_iir, angle(H_iir)*180/pi, 'r', 'LineWidth', 1.2);
xlabel('Frecuencia [Hz]'); ylabel('Fase [°]');
title('d) Fase — IIR Elliptic  (fase no lineal)');
xlim([0 Fs/2]); grid on;

%% ── e) Dimensión del numerador FIR y matriz SOS del IIR ─────────────────
N_fir = length(b_fir);
[n_sos, ~] = size(SOS);

fprintf('\n=== e) Dimensiones ===\n');
fprintf('Numerador FIR (nro. de coeficientes): %d\n', N_fir);
fprintf('Secciones SOS del IIR:                %d  (cada una con 6 coeficientes → %d total)\n', ...
    n_sos, n_sos*6);
fprintf('\nConclusión: el FIR necesita %d coeficientes para lograr especificaciones\n', N_fir);
fprintf('similares a las del IIR, que solo usa %d secciones de 2do orden.\n', n_sos);