function signal_n = my_awgn(signal, snr)
    % signal: vector de entrada
    % snr: relación señal/ruido en dB

    % Varianza de la señal
    var_signal = var(signal);

    % Varianza del ruido a partir del SNR
    var_noise = var_signal / (10^(snr/10));

    % Generación del ruido blanco gaussiano
    noise = sqrt(var_noise) * randn(size(signal));

    % Señal con ruido
    signal_n = signal + noise;
end