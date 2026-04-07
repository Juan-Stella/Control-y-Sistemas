clc; clear all;

fs = 1000;          % frecuencia de muestreo
t = 0:1/fs:0.5;     % vector de tiempo

seno = sin(2*pi*100*t);

plot(t, seno)