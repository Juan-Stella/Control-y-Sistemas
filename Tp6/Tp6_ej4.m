clc;
clear;
close all;

%% ── Parámetros ───────────────────────────────────────────────────────────
fs    = 9600;       % frecuencia de muestreo [Hz]
dt    = 1/fs;
fc1   = 300;        % frecuencia de corte inferior [Hz]
fc2   = 3400;       % frecuencia de corte superior [Hz]
orden = 4;          % orden del filtro Chebyshev Tipo I (por banda → orden total = 2*orden)
ripple = 3;         % ripple en banda pasante [dB]

%% ── a) Diseño del filtro analógico con pre-warping ───────────────────────

% Normalizar frecuencias digitales a radianes
wc1_n = 2*pi*fc1/fs;
wc2_n = 2*pi*fc2/fs;

% Pre-warping: mapear frecuencias digitales a analógicas
wc1_p = (2/dt) * tan(wc1_n/2);
wc2_p = (2/dt) * tan(wc2_n/2);

fprintf('=== Pre-warping ===\n');
fprintf('Digital:   wc1 = %.2f rad/s,  wc2 = %.2f rad/s\n', wc1_n/dt, wc2_n/dt);
fprintf('Analógico: wc1 = %.2f rad/s,  wc2 = %.2f rad/s\n', wc1_p, wc2_p);

% Diseño del prototipo pasa-bajos Chebyshev Tipo I normalizado
[Z, P, K] = cheb1ap(orden, ripple);
[B, A]    = zp2tf(Z, P, K);

% Transformar pasa-bajos normalizado → pasa-banda analógico
w_central  = sqrt(wc1_p * wc2_p);   % frecuencia central geométrica
bw         = wc2_p - wc1_p;         % ancho de banda

[num_a, den_a] = lp2bp(B, A, w_central, bw);

fprintf('\n=== Filtro analógico ===\n');
fprintf('Orden del filtro analógico: %d\n', length(den_a)-1);

%% ── b) Respuesta en frecuencia y fase del filtro analógico — freqs() ─────
w_vec = logspace(2, 5, 2000);           % vector de frecuencias [rad/s]
[h_a, w_a] = freqs(num_a, den_a, w_vec);

f_a   = w_a / (2*pi);
mag_a = 20*log10(abs(h_a));
phi_a = angle(h_a) * 180/pi;

figure('Name', 'b) Filtro analógico');

subplot(2,1,1);
semilogx(f_a, mag_a, 'b', 'LineWidth', 1.3);
xlabel('Frecuencia [Hz]'); ylabel('Magnitud [dB]');
title('b) Filtro analógico — Magnitud');
xline(fc1, 'k--', '300 Hz'); xline(fc2, 'k--', '3400 Hz');
xlim([1e2 fs/2]); grid on;

subplot(2,1,2);
semilogx(f_a, phi_a, 'b', 'LineWidth', 1.3);
xlabel('Frecuencia [Hz]'); ylabel('Fase [°]');
title('b) Filtro analógico — Fase');
xline(fc1, 'k--', '300 Hz'); xline(fc2, 'k--', '3400 Hz');
xlim([1e2 fs/2]); grid on;

sgtitle('b) Respuesta del filtro analógico Chebyshev Tipo I pasa-banda');

%% ── c) Discretizar con método de Tustin (transformada bilineal) ──────────
H_analog  = tf(num_a, den_a);
H_digital = c2d(H_analog, dt, 'tustin');

num_d = H_digital.numerator{1,1};
den_d = H_digital.denominator{1,1};

fprintf('\n=== Filtro digital ===\n');
fprintf('Orden del filtro digital: %d\n', length(den_d)-1);

%% ── d) Respuesta en frecuencia y fase del filtro digital — freqz() ───────
[h_d, w_d] = freqz(num_d, den_d, 2000, fs);

f_d   = w_d;
mag_d = 20*log10(abs(h_d));
phi_d = angle(h_d) * 180/pi;

figure('Name', 'd) Filtro digital');

subplot(2,1,1);
plot(f_d, mag_d, 'r', 'LineWidth', 1.3);
xlabel('Frecuencia [Hz]'); ylabel('Magnitud [dB]');
title('d) Filtro digital — Magnitud');
xline(fc1, 'k--', '300 Hz'); xline(fc2, 'k--', '3400 Hz');
xlim([0 fs/2]); grid on;

subplot(2,1,2);
plot(f_d, phi_d, 'r', 'LineWidth', 1.3);
xlabel('Frecuencia [Hz]'); ylabel('Fase [°]');
title('d) Filtro digital — Fase');
xline(fc1, 'k--', '300 Hz'); xline(fc2, 'k--', '3400 Hz');
xlim([0 fs/2]); grid on;

sgtitle('d) Respuesta del filtro digital (Tustin)');

%% ── Diagrama de polos y ceros del filtro digital ─────────────────────────
figure('Name', 'd) Polos y ceros — digital');
zplane(num_d, den_d);
title('Polos y ceros — Filtro digital');
grid on;

%% ── e) Comparación analógico vs digital ──────────────────────────────────
figure('Name', 'e) Comparación');

subplot(2,1,1);
semilogx(f_a, mag_a, 'b', 'LineWidth', 1.3, 'DisplayName', 'Analógico'); hold on;
plot(f_d, mag_d,     'r', 'LineWidth', 1.3, 'DisplayName', 'Digital (Tustin)');
xlabel('Frecuencia [Hz]'); ylabel('Magnitud [dB]');
title('e) Comparación — Magnitud');
xline(fc1, 'k--', '300 Hz'); xline(fc2, 'k--', '3400 Hz');
xlim([0 fs/2]); legend; grid on;

subplot(2,1,2);
semilogx(f_a, phi_a, 'b', 'LineWidth', 1.3, 'DisplayName', 'Analógico'); hold on;
plot(f_d, phi_d,     'r', 'LineWidth', 1.3, 'DisplayName', 'Digital (Tustin)');
xlabel('Frecuencia [Hz]'); ylabel('Fase [°]');
title('e) Comparación — Fase');
xline(fc1, 'k--', '300 Hz'); xline(fc2, 'k--', '3400 Hz');
xlim([0 fs/2]); legend; grid on;

sgtitle('e) Analógico vs Digital — Chebyshev Tipo I pasa-banda');