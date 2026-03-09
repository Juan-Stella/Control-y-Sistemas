clc, clear;

polos = -1/2;
ceros = 0;

[num, den] = zp2tf(ceros, polos, 1)
centro = [0, 0]; % [h, k]
radio = abs(polos);
theta = linspace(0, 2*pi, 100); 

% Calcular puntos del borde
x = centro(1) + radio * cos(theta);
y = centro(2) + radio * sin(theta);
figure
zplane(ceros,abs(polos));
patch(x, y, 'red', 'FaceAlpha', 0.2); 
hold on;
plot(x, y, 'r', 'LineWidth', 1); 
figure
freqz(num, den);
