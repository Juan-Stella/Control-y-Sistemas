%% Ejercicio 1 - Ubicación de polos por respuesta en el tiempo
% p(s) = s^2 + 2*zeta*wn*s + wn^2
clear; clc; close all;

%% Caso A: Ts = 2.0 s, Mp = 0%
% Mp = 0% => zeta >= 1 (criticamente amortiguado => zeta = 1)
% Ts = 4/(zeta*wn) => wn = 4/(zeta*Ts)

zeta_A = 1;
Ts_A = 2.0;
%wn_A = 4 / (zeta_A * Ts_A)  % = 2 rad/s
wn_A = 5.8/Ts_A

fprintf('=== Caso A ===\n');
fprintf('zeta = %.4f\n', zeta_A);
fprintf('wn   = %.4f rad/s\n', wn_A);

% Polos: polo doble real en s = -zeta*wn
polos_A = roots([1, 2*zeta_A*wn_A, wn_A^2]);
fprintf('Polos: s = %.4f, s = %.4f\n', polos_A(1), polos_A(2));

% Sistema de segundo orden
sys_A = tf(wn_A^2, [1, 2*zeta_A*wn_A, wn_A^2]);

%% Caso B: Ts = 4.0 s, Mp = 10%
% Mp = exp(-pi*zeta/sqrt(1-zeta^2))
% ln(0.1) = -pi*zeta/sqrt(1-zeta^2)
% Resolviendo: zeta = -ln(Mp)/sqrt(pi^2 + ln(Mp)^2)

Mp_B = 0.10;
Ts_B = 4.0;
zeta_B = -log(Mp_B) / sqrt(pi^2 + log(Mp_B)^2);
wn_B = 4 / (zeta_B * Ts_B);

fprintf('\n=== Caso B ===\n');
fprintf('zeta = %.4f\n', zeta_B);
fprintf('wn   = %.4f rad/s\n', wn_B);

polos_B = roots([1, 2*zeta_B*wn_B, wn_B^2]);
fprintf('Polos: s = %.4f + j%.4f\n', real(polos_B(1)), imag(polos_B(1)));
fprintf('       s = %.4f - j%.4f\n', real(polos_B(2)), abs(imag(polos_B(2))));

sys_B = tf(wn_B^2, [1, 2*zeta_B*wn_B, wn_B^2]);

%% Graficas
figure('Color','w');

% Respuesta al escalon
subplot(1,2,1);
step(sys_A, 10);
title('Caso A: T_s=2s, M_p=0%');
grid on;

subplot(1,2,2);
step(sys_B, 10);
title('Caso B: T_s=4s, M_p=10%');
grid on;

sgtitle('Ejercicio 1 - Respuesta al escalón');

% Ubicacion de polos
figure('Color','w');
hold on; grid on; axis equal;
plot(real(polos_A), imag(polos_A), 'rx', 'MarkerSize', 12, 'LineWidth', 2);
plot(real(polos_B), imag(polos_B), 'bo', 'MarkerSize', 12, 'LineWidth', 2);
xline(0, 'k--');
yline(0, 'k--');
xlabel('Real'); ylabel('Imaginario');
title('Ubicación de polos');
legend('Caso A', 'Caso B');