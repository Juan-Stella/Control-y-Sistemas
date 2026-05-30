clear; clc; syms s K a b real

%% ── MODIFICAR AQUÍ ──────────────────────────────────────────────────────────
H1 = K*(a*s + 1)*(b*s + 1) / s;
H2 = 2*(s + 2) / ((s + 1)*(s + 10));

Mp      = 0.20;   % máximo overshoot (fracción)
Ts      = 2;      % tiempo de establecimiento [s]
p_extra = 10;     % polo extra rápido
%% ─────────────────────────────────────────────────────────────────────────────

%% Paso 1: zeta y wn desde specs (numérico)
f   = @(x) [exp(-pi*x(1)/sqrt(1-x(1)^2)) - Mp, ...
             4/(x(1)*x(2))                - Ts];
sol = fsolve(f, [0.5, 4], optimset('Display','off'));
zeta = sol(1);
wn   = sol(2);
fprintf('zeta = %.4f,  wn = %.4f rad/s\n', zeta, wn)

%% Paso 2: polinomio deseado
p_dom = [1, 2*zeta*wn, wn^2];
p_des = conv(p_dom, [1, p_extra]);
fprintf('Polinomio deseado: s^3 + %.4fs^2 + %.4fs + %.4f\n', ...
    p_des(2), p_des(3), p_des(4))

%% Paso 3: polinomio característico simbólico
loop     = simplify(1 + H1*H2);
[num, ~] = numden(loop);
num      = expand(num);
cp       = fliplr(coeffs(num, s));   % [s^3, s^2, s^1, s^0]
fprintf('\nCoeficientes CP:\n')
fprintf('  s^3: %s\n', cp(1))
fprintf('  s^2: %s\n', cp(2))
fprintf('  s^1: %s\n', cp(3))
fprintf('  s^0: %s\n', cp(4))

%% Paso 4: resolver igualando coeficientes
syms ab_aux

% K desde s^0
K_val = double(solve(cp(4) == p_des(4), K));
fprintf('K = %.4f\n', K_val)

% ab desde s^3 usando variable auxiliar
cp_sub  = subs(cp, K, K_val);
eq_s3   = subs(cp_sub(1), a*b, ab_aux) == p_des(1);
ab_val  = double(solve(eq_s3, ab_aux));
fprintf('ab = %.6f\n', ab_val)

% Elegir b=0 o a=0 según ab=0, sino resolver sistema
if abs(ab_val) < 1e-6
    fprintf('ab = 0  =>  tomamos b = 0\n')
    b_val = 0;
    a_val = double(solve(subs(cp_sub(2), b, 0) == p_des(2), a));
else
    sol_ab = solve([cp_sub(2) == p_des(2), cp_sub(3) == p_des(3)], [a b]);
    a_val  = double(sol_ab.a);
    b_val  = double(sol_ab.b);
end

fprintf('a = %.4f\n', a_val)
fprintf('b = %.4f\n', b_val)

%% Paso 5: controlador
Gc_num = K_val * conv([a_val 1], [b_val 1]);
fprintf('\nControlador Gc(s) = (%.4fs^2 + %.4fs + %.4f) / s\n', ...
    Gc_num(1), Gc_num(2), Gc_num(3))
