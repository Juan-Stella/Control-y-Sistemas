function y = leaking_integrator(x, lambda)
% LEAKING_INTEGRATOR  Aplica un filtro Leaking Integrator (IIR 1er orden).
%
%   y = leaking_integrator(x, lambda)
%
%   Entradas:
%       x      - señal de entrada (vector)
%       lambda - parámetro del filtro (0 < lambda < 1)
%
%   Salida:
%       y      - señal filtrada
%
%   H(z) = (1 - lambda) / (1 - lambda·z^{-1})
%   Ecuación en diferencias: y[n] = lambda·y[n-1] + (1-lambda)·x[n]

b = [1 - lambda];
a = [1,  -lambda];

y = filter(b, a, x);

end