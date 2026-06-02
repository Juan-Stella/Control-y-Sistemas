
%% PARCIAL II: CONTROL Y SISTEMAS
%Parcial 2  - Stella Juan - 12552
%% Criterio de evaluaión
% _"Se evaluará la calidad del razonamiento 
% técnico y la justificación de las decisiones de diseño."_
%
% _"Priorizar en el análisis descripciones cuantitativas y objetivas." 
% 
% _"Cuide la presentación, escala, colores, títulos y leyendas de sus gráficos para hacerlos 
% lo más legible posible para la evaluación."_



%% Contexto
% Tenemos un sistema que deberá ser modelado, controlado y analizado. Se trata de un
% portón corredizo movido por un motor con su eje solidario a un mecanismo 
% de piñon y cremallera solidaria al portón que permite que este se
% desplace linealmente al girar el motor. La forma en la que el sistema
% disipa la energía se encuentra experimentalmente. 


%% Objetivo
% Modelar y analizar el sistema. 
clc
close all 

m = 200; %kg
c = 0; % Ns/m estimar c
magnitud_pulso_perturbacion = 100; % N
tiempo_pulso_perturbacion = 50; % s
R = 0.05; % m radio del piñón
tau_maximo_motor = 200; % Nm




%% 1. Modelado del Portón Corredizo
% Modele el portón corredizo. Estimar  el parámetro faltante (c) sabiendo que el portón pasa
% sin fuerzas externas (ni perturbación ni motor) de 1m/s a 0.1m/s en 1s. 
% Luego de obtener las ecuaciones físicas elabore un modelo en SIMULINK.
% Valide el modelo.


% [Ingresa tu modelado aquí]

% a(t) = x_ddot(t), v(t) = x_dot(t), m, c
%Modelo:
% Por 2° Ley de Newton: m*dv/dt = -c*v 
% O podemos escribir x_ddot(t) = -c/m*x_dot(t)
% Y tiene solución v(t)= x_dot(t) = v0*exp(-c*t/m),
% entonces:
fprintf('Verificación valor de c: \n');
c = -m * log(0.1) / 1;  
fprintf('c = %.2f Ns/m\n', c);
fprintf('\n');
% Se aceptan aproximaciones de c por prueba y error, si cumplen con        
% v(0 s) = 1.0 m/s    ^    v(1 s) = 0.1 m/s
% con un error menor al 5% en términos de velocidad.


%% 2. Integración con el Controlador de velocidad
% Integre su modelo al controlador PID dado y luego analice desempeño
% frente a r(t) como escalón de 1 m/s

% [SIMULINK]
%Vemos un crecimiento monotónico de la velocidad desde 0 m/s hasta 1 m/s,en
%y se establece en aproximadamente 20 segundos, sin error de estado
%estacionario y sin overshoot.El torque motor crece de igual manera desde 0
%hasta aproximadamente 23 Nm
%Como la consigna es de velocidad constante, la posición no se estabiliza.

%% Desempeño velocidad
fprintf('Verificación de mejoras\n');
t = out.velocidad.time;
v = out.velocidad.Data(:);

v_ref = 1;
tol = 0.02*v_ref;   

% tiempo de establecimiento
fuera = abs(v - v_ref) > tol;
Ts = t(find(fuera,1,'last'));

% error estacionario
v_final = v(end);
ess = v_ref - v_final;

% sobreimpulso
Mp = max(0,(max(v)-v_ref)/v_ref*100);

fprintf('Tiempo de establecimiento = %.2f s\n', Ts);
fprintf('Velocidad final = %.2f m/s\n', v_final);
fprintf('Error estacionario = %.2f m/s\n', ess);
fprintf('Sobreimpulso = %.2f %%\n', Mp);
fprintf('\n');
fprintf('\n');

%% 3. Análisis de Perturbaciones
% Modela el ingreso de una perturbación externa tipo pulso de fuerza de 100 N que va en sentido 
% contrario al de la apertura, justo en el instante de transcurridos
% 49 s de iniciada la maniobra. 
%
% Evalúa el rechazo a esta perturbación de forma objetiva proponga una métrica.

% [Ingresa tu análisis de perturbaciones aquí]

%Como métrica para medir  al comportamiento del sistema ante
%perturbaciones, podemos tomar el máximo desvío que genera la perturbación,
%además del tiempo de recuperación del mismo. Vemos que la caída en la
%velocidad en el momento de la perturbación es de 0.0386 m/s, con un tiempo
%de recuperación de 3.60s

%% Métrica de rechazo a perturbaciones

t = out.velocidad.Time;
v = out.velocidad.Data(:);

v_ref = 1;
t_pert = 49;      
tol = 0.02*v_ref;   

idx = t >= t_pert;
dv_max = max(abs(v(idx) - v_ref));

t_post = t(idx);
v_post = v(idx);

fuera = abs(v_post - v_ref) > tol;

if any(fuera)
    t_rec = t_post(find(fuera,1,'last')) - t_pert;
else
    t_rec = 0;
end
fprintf('Métricas ante perturbaciones: \n');
fprintf('Desvío máximo por perturbación = %.4f m/s\n', dv_max);
fprintf('Tiempo de recuperación = %.2f s\n', t_rec);
fprintf('\n');


%% 4. Rediseño del Controlador (Sintonía)
% Modifica la sintonía del control cumpliendo con los siguientes compromisos:
% 1. Hacer que el portón abra más rápido ante un escalón en la referencia de velocidad.
% 2. Que la respuesta ante la perturbación se mantenga idéntica a la del punto anterior.

% Copia y pega los bloques del sistema completo, de manera de ver el modelo
% antes y después de rediseñar el controlador, con idénticas r(t) y d(t).

% [SIMULINK]

%Lo que se nos pide es que el sistema se estabilice o llegue a la
%referencia en un tiempo más corto. Por lo tanto, proponemos hacer que la
%acción proporcional tenga efecto sobre la entrada de referencia,
%incorporándola a la rama directa.Luego de aplicar la mejora, vemos que el
%tiempo de establecimiento pasó de 20s a 11.53s aproximadamente (cuando no tenemos perturbación),
%reduciéndolo en casi la mitad, pero sin presentar condiciones irrealistas de funcionamiento 
%Aunque no es requerido, también podemos ver que no se genera un
%sobre-impulso.

%Con respecto a la perturbación, vemos que el desvío máximo con respecto a
%la referencia y el tiempo de recuperación siguen práctciamente iguales,
%debido a que seguimos teniendo que la respuesta a la perturbación es controlada por un
%PI, con las mismas ganancias anteriores.


%% Desempeño velocidad
fprintf('-------------------------\n');
fprintf('Verificación de mejoras propuestas:\n');
t = out.velocidad1.time;
v = out.velocidad1.Data(:);

v_ref = 1;
tol = 0.02*v_ref;  

% tiempo de establecimiento
fuera = abs(v - v_ref) > tol;
Ts = t(find(fuera,1,'last'));

% error estacionario
v_final = v(end);
ess = v_ref - v_final;

% sobreimpulso
Mp = max(0,(max(v)-v_ref)/v_ref*100);

fprintf('Tiempo de establecimiento = %.2f s\n', Ts);
fprintf('Velocidad final = %.2f m/s\n', v_final);
fprintf('Error estacionario = %.2f m/s\n', ess);
fprintf('Sobreimpulso = %.2f %%\n', Mp);

%% Métrica de rechazo a perturbaciones
fprintf('\n');
fprintf('\n');
t = out.velocidad2.Time;
v = out.velocidad2.Data(:);

v_ref = 1;
t_pert = 49;      
tol = 0.02*v_ref;   

idx = t >= t_pert;
dv_max = max(abs(v(idx) - v_ref));

t_post = t(idx);
v_post = v(idx);

fuera = abs(v_post - v_ref) > tol;

if any(fuera)
    t_rec = t_post(find(fuera,1,'last')) - t_pert;
else
    t_rec = 0;
end
fprintf('Métricas ante perturbaciones: \n');
fprintf('Desvío máximo por perturbación = %.4f m/s\n', dv_max);
fprintf('Tiempo de recuperación = %.2f s\n', t_rec);
fprintf('\n');


%% 5. Análisis del Actuador
% A partir de la nueva acción de control (torque del motor con el controlador rediseñado), 
% determina si esto requiere el reemplazo del motor por uno de mayor capacidad.

% [Ingresa tu análisis del actuador aquí]
fprintf('Análisis de elección motor:\n');
fprintf('Torque caso profesor: = %.2f Nm\n',max(out.torque.data))
fprintf('Torque con rediseño: = %.2f Nm\n',max(out.torque1.data))

% Vemos que el máximo torque del motor en el caso inicial dado, es de
%aproximadamente 28 Nm. Cuando nosotros implementamos la mejora de pasar la
%acción proporcional a la rama directa, entonces lo que tenemos es que ante
%escalones en la referencia, tendremos escalones en la acción de control,
%dando un máximo de aproximadamente 100 Nm. 
% Teniendo en cuenta ésta situación, no es necesario cambiar el motor, ya
% que aunque al principio teníamos situaciones menos exigentes, igualmente
% teníamos un motor que puede soportar los esfuerzos correspondientes a la
% solución propuesta.   
fprintf('-------------------------\n');
