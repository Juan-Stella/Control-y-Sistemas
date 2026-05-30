clear; clc;
s = tf('s');

Gp = 1/(s*(s+1)*(s+5));

K = 39.42;
Ti = 3.077;
Td = 0.7692;

Gc = K*(1 + 1/(Ti*s) + Td*s);

% PID clásico
T_PID_R = (Gc*Gp)/(1 + Gc*Gp);  % C(s)/R(s)
T_PID_D = Gp/(1 + Gc*Gp);     % C(s)/D(s)

% I-PD
T_IPD_R = (Gp*K*(1/(Ti*s))) / (1 + Gp*Gc);
T_IPD_D = Gp / (1 + Gp*Gc);

T_IPD_R = minreal(T_IPD_R);
T_IPD_D = minreal(T_IPD_D);
T_PID_R = minreal(T_PID_R);
T_PID_D = minreal(T_PID_D);

disp('C/R PID:')
T_PID_R

disp('C/R I-PD:')
T_IPD_R

disp('C/D PID:')
T_PID_D

disp('C/D I-PD:')
T_IPD_D

figure;
step(T_PID_D, T_IPD_D)
grid on
legend('PID - perturbación', 'I-PD - perturbación')
title('Respuesta ante perturbación escalón')

figure;
step(T_PID_R, T_IPD_R)
grid on
legend('PID - referencia', 'I-PD - referencia')
title('Respuesta ante referencia escalón')