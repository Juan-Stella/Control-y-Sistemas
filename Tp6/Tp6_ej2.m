clc;
clear;
close all;

%% ── Cargar señal de audio ───────────────────────────────────────────────
load('Tchaikovsky.mat');    % carga: signal (Nx2), Fs

% Elegir canal 1
x = signal(:, 1);

%% ── b) Agregar ruido (SNR = 60 dB) ─────────────────────────────────────
snr = 60;
x_ruidosa = awgn(x, snr, 'measured');

%% ── Reproducir señales (opcional, descomentar para escuchar) ────────────
% sound(x,          Fs);  pause(length(x)/Fs + 1);   % original
% sound(x_ruidosa,  Fs);  pause(length(x)/Fs + 1);   % con ruido
% sound(x_filtrada, Fs);                              % filtrada (ver abajo)

%% ── c) a h) para cada lambda ────────────────────────────────────────────
%lambdas = [0.7, 0.9, 0.98];
lambdas = [0.98];

for lambda = lambdas

    b = [1 - lambda];
    a = [1,  -lambda];

    fprintf('\n════════════════════════════════════════\n');
    fprintf('  lambda = %.2f\n', lambda);
    fprintf('════════════════════════════════════════\n');

    %% ── d) Respuesta en frecuencia y fco ────────────────────────────────
    fco = -log(lambda) * Fs / pi;
    fprintf('Frecuencia de corte: fco = %.2f Hz\n', fco);

    figure('Name', sprintf('d) Frec. — lambda=%.2f', lambda));
    freqz(b, a, 1024, Fs);
    sgtitle(sprintf('d) Respuesta en frecuencia y fase — \\lambda = %.2f  (f_{co} = %.1f Hz)', ...
        lambda, fco));

    %% ── e) Polos y ceros ────────────────────────────────────────────────
    ceros = roots(b);
    polos = roots(a);

    fprintf('Ceros: %s\n', mat2str(ceros, 4));
    fprintf('Polos: %s\n', mat2str(polos, 4));

    figure('Name', sprintf('e) Polos y ceros — lambda=%.2f', lambda));
    zplane(b, a);
    grid on;
    title(sprintf('e) Polos y ceros — \\lambda = %.2f', lambda));

    if all(abs(polos) < 1)
        fprintf('Todos los polos dentro del círculo unitario  →  Filtro ESTABLE\n');
    else
        fprintf('Hay polos fuera del círculo unitario  →  Filtro INESTABLE\n');
    end

    %% ── f) Filtrar ──────────────────────────────────────────────────────
    x_filtrada = leaking_integrator(x_ruidosa, lambda);

    % Reproducir filtrada (descomentar para escuchar)
    sound(x_filtrada, Fs);

    %% ── g) Respuesta en el tiempo ───────────────────────────────────────
    t = (0 : length(x)-1)' / Fs;

    figure('Name', sprintf('g) Tiempo — lambda=%.2f', lambda));

    subplot(2,1,1);
    plot(t, x_ruidosa, 'r', 'LineWidth', 0.6); hold on;
    plot(t, x,         'b', 'LineWidth', 0.8);
    legend('Con ruido', 'Original');
    xlabel('Tiempo [s]'); ylabel('Amplitud');
    title('Señal original y con ruido');
    grid on;
     xlim([0 0.6]) 

    subplot(2,1,2);
    plot(t, x_filtrada, 'g',  'LineWidth', 0.8); hold on;
    plot(t, x,          'b--','LineWidth', 0.6);
    legend('Filtrada', 'Original');
    xlabel('Tiempo [s]'); ylabel('Amplitud');
    title(sprintf('Señal filtrada — \\lambda = %.2f  (f_{co} = %.1f Hz)', lambda, fco));
    grid on;
    xlim([0 0.6]) 
    sgtitle(sprintf('g) Respuesta en el tiempo — \\lambda = %.2f', lambda));

    %% ── h) Espectro de frecuencia — my_dft() ────────────────────────────
    [freq_o, mag_o] = my_dft(x,          Fs);
    [freq_n, mag_n] = my_dft(x_ruidosa,  Fs);
    [freq_f, mag_f] = my_dft(x_filtrada, Fs);

    figure('Name', sprintf('h) Espectro — lambda=%.2f', lambda));
    plot(freq_n, mag_n, 'r',  'LineWidth', 0.6, 'DisplayName', 'Con ruido');  hold on;
    plot(freq_o, mag_o, 'b--','LineWidth', 0.8, 'DisplayName', 'Original');
    plot(freq_f, mag_f, 'g',  'LineWidth', 1.2, ...
        'DisplayName', sprintf('Filtrada (\\lambda=%.2f)', lambda));
    xlabel('Frecuencia [Hz]'); ylabel('Magnitud');
    title(sprintf('h) Espectro — \\lambda = %.2f  (f_{co} = %.1f Hz)', lambda, fco));
    legend; grid on;
    xlim([0 Fs/50]);

end