clc;
clear;
close all;

load('Tchaikovsky.mat');   % <-- esto faltaba

fs = Fs;      
snr = 50;       % SNR en dB

x = signal(:,1);   % elegir un canal (izquierdo)

% Señal con ruido
x_ruido = awgn(x, snr, 'measured');