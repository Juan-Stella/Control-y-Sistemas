function Hd = irr_elliptic_200_800
%IRR_ELLIPTIC_200_800 Filtro IIR Eliptico Pasa-banda 200-800 Hz, fs=10000 Hz.
% Usa ellip() directamente, compatible con todas las versiones de MATLAB.

Fs = 10000;

% Diseño con ellip(): orden 8, 1dB ripple pasante, 60dB atenuacion suprimida
[z, p, k] = ellip(8, 1, 60, [200 800]/(Fs/2), 'bandpass');

% Convertir a secciones de segundo orden
[sos, g] = zp2sos(z, p, k);

% Construir estructura compatible con iir_online.m
% iir_online.m usa: Hd.sosMatrix y Hd.ScaleValues
Hd.sosMatrix   = sos;
Hd.ScaleValues = [g; ones(size(sos,1)-1, 1); 1];

% [EOF]