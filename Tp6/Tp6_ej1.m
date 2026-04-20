clc;
clear;
close all;

%% ── Señal base (dado por la consigna) ───────────────────────────────────
fs = 2000;
f  = 100;
t  = 0:1/fs:1;
snr = 15;       % SNR en dB

signal       = sin(2*pi*f*t);
signal_awgn  = awgn(signal, snr, 'measured');

%% ── Parámetros del filtro ───────────────────────────────────────────────
lambdas = [0.7, 0.9, 0.98];    % inciso i): repetir c) a h) para los tres valores
%lambdas = [0.98];
for lambda = lambdas

    b = [1 - lambda];
    a = [1,  -lambda];

    fprintf('\n════════════════════════════════════════\n');
    fprintf('  lambda = %.2f\n', lambda);
    fprintf('════════════════════════════════════════\n');

    %% ── d) Respuesta en frecuencia y fase — freqz() ─────────────────────
    fco = -log(lambda) * fs / pi;
    fprintf('Frecuencia de corte: fco = %.2f Hz\n', fco);

    figure('Name', sprintf('d) Respuesta en frec. — lambda=%.2f', lambda));
    freqz(b, a, 1024, fs);
    sgtitle(sprintf('d) Respuesta en frecuencia y fase — \\lambda = %.2f  (f_{co} = %.1f Hz)', ...
        lambda, fco));

    %% ── e) Polos y ceros — zplane() ─────────────────────────────────────
    ceros = roots(b);
    polos = roots(a);

    fprintf('Ceros: %s\n', mat2str(ceros, 4));
    fprintf('Polos: %s\n', mat2str(polos, 4));

    figure('Name', sprintf('e) Polos y ceros — lambda=%.2f', lambda));
    zplane(b, a);
    grid on;
    title(sprintf('e) Polos y ceros — \\lambda = %.2f', lambda));

    % Estabilidad: el filtro es estable si todos los polos están dentro del círculo unitario
    if all(abs(polos) < 1)
        fprintf('Todos los polos dentro del círculo unitario  →  Filtro ESTABLE\n');
    else
        fprintf('Hay polos fuera del círculo unitario  →  Filtro INESTABLE\n');
    end

    %% ── f) Aplicar el filtro LI ──────────────────────────────────────────
    signal_filtrada = leaking_integrator(signal_awgn, lambda);

    %% ── g) Respuesta en el tiempo ────────────────────────────────────────
    figure('Name', sprintf('g) Tiempo — lambda=%.2f', lambda));

    subplot(2,1,1);
    plot(t, signal_awgn, 'r', 'LineWidth', 0.8); hold on;
    plot(t, signal,      'b', 'LineWidth', 1.2);
    legend('Con ruido', 'Original');
    xlabel('Tiempo [s]'); ylabel('Amplitud');
    title('Señal original y señal con ruido');
    grid on;

    subplot(2,1,2);
    plot(t, signal_filtrada, 'g',  'LineWidth', 1.5); hold on;
    plot(t, signal,          'b--','LineWidth', 1.0);
    legend('Filtrada', 'Original');
    xlabel('Tiempo [s]'); ylabel('Amplitud');
    title(sprintf('Señal filtrada — \\lambda = %.2f  (f_{co} = %.1f Hz)', lambda, fco));
    grid on;
    xlim([0 0.2]) 

    sgtitle(sprintf('g) Respuesta en el tiempo — \\lambda = %.2f', lambda));

    %% ── h) Espectro de frecuencia — my_dft() ────────────────────────────
    [freq_s, mag_s] = my_dft(signal,          fs);
    [freq_n, mag_n] = my_dft(signal_awgn,     fs);
    [freq_f, mag_f] = my_dft(signal_filtrada, fs);

    figure('Name', sprintf('h) Espectro — lambda=%.2f', lambda));
    plot(freq_n, mag_n, 'r',  'LineWidth', 0.8, 'DisplayName', 'Con ruido');  hold on;
    plot(freq_s, mag_s, 'b--','LineWidth', 1.2, 'DisplayName', 'Original');
    plot(freq_f, mag_f, 'g',  'LineWidth', 1.5, ...
        'DisplayName', sprintf('Filtrada (\\lambda=%.2f)', lambda));
    xlabel('Frecuencia [Hz]'); ylabel('Magnitud');
    title(sprintf('h) Espectro — \\lambda = %.2f  (f_{co} = %.1f Hz)', lambda, fco));
    legend; grid on;
    xlim([0 fs/10]);

end