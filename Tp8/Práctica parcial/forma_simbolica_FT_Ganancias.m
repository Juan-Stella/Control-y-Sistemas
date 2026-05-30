clear; clc;
syms s a b m kp ki kd lambda real
%ej4
%% Planta: P(s) = b/(ms + a)  [tu notación]
Gp = b / (m*s + a);
C  = kp + ki/s + kd*s;

%% Polinomio característico
loop     = simplify(1 + C*Gp);
[num, ~] = numden(loop);
num      = expand(num);
cp       = fliplr(coeffs(num, s));   % [s^2, s^1, s^0]

fprintf('CP:\n')
fprintf('  s^2: %s\n', cp(1))
fprintf('  s^1: %s\n', cp(2))
fprintf('  s^0: %s\n', cp(3))

%% Polinomio deseado escalado al mismo coeficiente líder
% cp(1) = m + b*kd  =>  polinomio deseado = (m+b*kd)*(s+lambda)^2
lider = cp(1);
p_des = expand(lider * (s + lambda)^2);
pd    = fliplr(coeffs(p_des, s));

fprintf('\nPolinomio deseado:\n')
fprintf('  s^2: %s\n', pd(1))
fprintf('  s^1: %s\n', pd(2))
fprintf('  s^0: %s\n', pd(3))

%% Resolver kp, ki dejando kd libre
eqs = [cp(2) == pd(2), ...
       cp(3) == pd(3)];

sol = solve(eqs, [kp ki]);
fprintf('\nSolución simbólica (kd libre):\n')
fprintf('  kp = %s\n', simplify(sol.kp))
fprintf('  ki = %s\n', simplify(sol.ki))
fprintf('  kd = kd  (libre)\n')

%% Verificar que coincide con tu resultado a mano
fprintf('\nVerificación vs resolución manual:\n')
fprintf('  kp = (2*lambda*(m+b*kd) - a) / b\n')
fprintf('  ki = lambda^2*(m+b*kd) / b\n')

%% Valores numéricos
a_v=200; b_v=10000; m_v=1000; lambda_v=30; kd_v=0.1;
kp_n = double(subs(sol.kp, [a b m lambda kd], [a_v b_v m_v lambda_v kd_v]));
ki_n = double(subs(sol.ki, [a b m lambda kd], [a_v b_v m_v lambda_v kd_v]));
fprintf('\nValores numéricos (lambda=%.1f, kd=%.1f):\n', lambda_v, kd_v)
fprintf('  kp = %.4f\n  ki = %.4f\n  kd = %.4f\n', kp_n, ki_n, kd_v)