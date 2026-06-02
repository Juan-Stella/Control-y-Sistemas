%% Ejercicio 2:
% Formule la planta en espacio de estados
% donde la salida sea la posición y
% donde el vector de estado sea
% x = [ p
%       v ]
% p = posición
% v = velocidad
% u = acción de control
% d = perturbaciones
% fg = fuerza de la gravedad
clc; clear; close all

%% Solución
% a = p_ddot = v_dot
% m*a = - v*c - fg + u + d

% p_dot = ...
% v_dot = ...
% 
% x1_dot = x2
% x2_dot = ...

g = 9.8;    %Ver datos de simulink
m = 1000;
c = 100;
fg = m*g;

% velocidad terminal
%  fg = v*c / (m)
v_term = -fg / c

A = [0 1;0 -(c/m)*(1+1/m)];
  
B = [0; 1/m];
    
C = [1 0];
  
D = [0];
  
Bu = B;
Bd = B;
Bfg = B;
%% simulación a lazo abierto
% debe verificarse que la velocidad terminal a 
% lazo abierto sea -98 m/s
sis_lazo_abierto = ss(A, B, C, D);

t = 0:.01:100;
fg_t = -fg*ones(1, length(t));
figure
lsim(sis_lazo_abierto, fg_t, t)
title('lazo abierto')

  
%% Entrega: PARCIAL_2_Apellido_E2.m

% m*a = -v*c - Fg + u + d
% 
%  ||
%  \/
% 
% x1 = x
% x2=x1_dot = v
% x2_dot=x1_dot_dot = a
% 
%  ||
%  \/
% 
% m*x2_dot = -x2*c - Fg + u + d;
% x2_dot = x2*(-c/m) - Fg/m + u/m + d/m;
% x1_dot = x2
% 
%  ||
%  \/
% 
% A,BFg,Bu,Bd,C,D (D=[0])
% 
% Factor comun B => B*(-Fg+C+D)
