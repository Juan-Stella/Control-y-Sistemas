clc; clear all;

fs = 1000;    
t = 0:1/fs:1;           
seno = sin(2*pi*100*t);


figure;

subplot(2,1,1)
plot(t, seno,'b','LineWidth',1.5);
xlim([0 0.2])  
grid on;
title('Señal continua');

subplot(2,1,2)
stem(t, seno,'r','filled');
xlim([0 0.2]) 
grid on;
title('Señal muestreada');