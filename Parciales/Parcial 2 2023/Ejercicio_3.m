%% Ejercicio 3: Verifique la observabilidad y 
% diseñe de un observador de estado que se alimente de:
%  - sensor de posición
%  - el valor constante de la fuerza de gravedad
%  - la perturbación excepcional
%  - la acción de control
% Las perturbaciones permanentes, el valor real de 
% la posición y el valor real de la velocidad no están
% disponibles para el observador.


% PARCIAL_2_E2_script

obsv(A, C)

%% 
q = 3160^2; %sacado de las perturbaciones (RMS)
r = 31.6^2;   %sacado de la posicion (RMS) --> Acordarse de elevar al cuadrado el q y r
Q = B * q * B';
R = [ r ];

[L,P,E] = lqr(A',C',Q, R);
L = L';




%% Entrega: PARCIAL_2_Apellido_E3.m
