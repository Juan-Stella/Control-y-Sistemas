%% Ejercicio 2 - Sistema de transmisión - Ubicación de polos por Ackermann
clear; clc; close all;

%% Parámetros del modelo
Jc = 6250;      % [kgm^2] Chassis inertia
Jf = 0.625;     % [kgm^2] Engine flywheel inertia
ds = 1000;      % [Nms/rad] Driveshaft damping coefficient
cs = 75000;     % [Nm/rad] Driveshaft spring coefficient
i_gear = 57;    % [-] Gear ratio

%% Matrices del sistema
% x = [x1; x2; x3] = [vel_motor; vel_ruedas; torque_transmision]
A = [-ds/(Jf*i_gear^2),  ds/(Jf*i_gear),  -cs/(Jf*i_gear);
      ds/(Jc*i_gear),   -ds/Jc,            cs/Jc;
      1/i_gear,          -1,                0];

Bu = [1/Jf; 0; 0];

Bd = [0; -1/Jc; 0];

Cp = [0, 1, 0];  % Salida: velocidad en las ruedas (x2)
Dp = 0;

fprintf('Matriz A:\n');
disp(A);
fprintf('Matriz Bu:\n');
disp(Bu);

%% a) Polos deseados
wn = 6;
zeta = 1/sqrt(2);

% Dos polos del polinomio de 2do orden
s12 = roots([1, 2*zeta*wn, wn^2]);
% Tercer polo: 2 veces más rápido
s3 = -2*zeta*wn;

polos_deseados = [s12(1); s12(2); s3];
fprintf('Polos deseados:\n');
fprintf('  s1 = %.4f + j%.4f\n', real(polos_deseados(1)), imag(polos_deseados(1)));
fprintf('  s2 = %.4f + j%.4f\n', real(polos_deseados(2)), imag(polos_deseados(2)));
fprintf('  s3 = %.4f\n', s3);

%% Verificar controlabilidad
Wr = ctrb(A, Bu);
rango = rank(Wr);
n = size(A, 1);
fprintf('\nRango de Wr = %d, n = %d\n', rango, n);
if rango == n
    fprintf('El sistema ES controlable.\n');
else
    fprintf('El sistema NO es controlable.\n');
end

%% b) Ganancia K por Ackermann (usando place)
K = place(A, Bu, polos_deseados);
% También se puede usar acker:
% K = acker(A, Bu, polos_deseados);

fprintf('\nb) Matriz K de realimentación:\n');
fprintf('  K = [%.6f, %.6f, %.6f]\n', K(1), K(2), K(3));

%% c) Ganancia de referencia kr
% kr = -(Cp * (A - Bu*K)^(-1) * Bu)^(-1)
Acl = A - Bu*K;
%kr = -(Cp * (Acl \ Bu))^(-1);
kr = -inv(Cp * inv(A - Bu*K) * Bu);

fprintf('\nc) Ganancia de referencia:\n');
fprintf('  kr = %.6f\n', kr);

%% d) Autovalores a lazo cerrado
eig_cl = eig(Acl);
fprintf('\nd) Autovalores del sistema a lazo cerrado:\n');
for ii = 1:length(eig_cl)
    if imag(eig_cl(ii)) ~= 0
        fprintf('  s%d = %.4f + j%.4f\n', ii, real(eig_cl(ii)), imag(eig_cl(ii)));
    else
        fprintf('  s%d = %.4f\n', ii, real(eig_cl(ii)));
    end
end

%% Verificación: respuesta al escalón del sistema a lazo cerrado
sys_cl = ss(Acl, Bu*kr, Cp, Dp);

figure('Color','w');
step(sys_cl, 5);
title('Ej. 2 - Respuesta al escalón del sistema a lazo cerrado');
xlabel('Tiempo [s]'); ylabel('Velocidad ruedas [rad/s]');
grid on;

%% Mapa de polos
figure('Color','w');
hold on; grid on;
plot(real(eig(A)), imag(eig(A)), 'rx', 'MarkerSize', 12, 'LineWidth', 2);
plot(real(eig_cl), imag(eig_cl), 'bo', 'MarkerSize', 12, 'LineWidth', 2);
xline(0, 'k--'); yline(0, 'k--');
xlabel('Real'); ylabel('Imaginario');
title('Polos: lazo abierto (x) vs lazo cerrado (o)');
legend('Lazo abierto', 'Lazo cerrado');