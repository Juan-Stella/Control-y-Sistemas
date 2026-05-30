%% Ejercicio 1. 
% Construya un modelo en simulink usando simscape (mecánica 
% traslacional) de la suspensión de un cuarto de vehículo (un colectivo).
% Los parámetros se dan abajo.
% Las perturbaciones del terreno aparecen a los 50 segundos y se modelan 
% como un ruido de 1 m/s^2 RMS (el bloque Band-Limited White Noise ya está configurado)
% SI EL MODELO ES CORRECTO, generan compresiones de la suspensión 
% de 3 a 4 cm pico.
% (1 puntos)

%% Respuesta ejercicio 1
%   Para la resolución de este ejercicio, se realiza un sistema
% simplificado el cual consiste en una masa que representa la rueda (m_u) con un
% resorte (k_u) y un amortiguador (c_u = 0 Ns/m) sujeta al suelo. Luego se
% coloca una segunda masa, que representa la masa del chasis (m_s), sujeta
% mediante un resorte (k_s) y un amortiguador a la rueda. Además, se le
% agregan dos fuerzas entre las masas las cuales representan la subida y
% bajada de un pasajero (esta fuerza esta referenciada al suelo) y la
% accion del chofer (referenciada a la masa de la rueda, ya que esta fuerza no se
% transmite al suelo). Ademas se agrega un bloque de velocidad debajo de la
% rueda, el cual representa el movimiento del colectivo luego de arrancar.

%% Ejercicio 2. 
% Considerando un sensor ideal de distancia para medir la compresión de
% la suspensión:
% Implemente un PID para que el colectivo descienda y permita el ingreso 
% de pasajeros. 
% Este controlador, cuando el chofer da un escalón a la referencia
% de -10 cm a los 10 s, debe hacer que la suspensión se comprima 10 cm, 
% sin error en estado estacionario, sin sobre-impulso y con un tiempo de 
% establecimiento de menos de 1.0 s.
% Por otra parte, cuando sube el pasajero, modelado como perturbación
% tipo escalón de 700 N a los 20 s, el controlador debe rechazar la 
% perturbación con un tiempo de establecimiento de menos de 1.0 s.
% Un pasajero baja a los 25 s, lo cual también se modela con un escalón.
% Para esto puede usar el comando 
% pidTuner(H, 'PID');
% y obtener las ganancias por tanteo observando la tabla mostrada al pulsar 
% el botón Show Parameters.
% (1 puntos)

%% Respuesta ejercicio 2
%   Gran parte de la resolución se llevó a cabo en papel. Allí se modeló el
% sistema masa-resorte-amortiguador donde se hizo el diagrama de cuerpo
% libre con sus respectivas fuerzas. Luego se realizó el sistema de
% ecuaciones correspondiente y se llevó a forma matricial, quedando asi de
% la siguiente forma:
%
%  x_dot = Ax+Bu
%  y = Cx
%
%   Una vez deducidas las matrices, se realiza la función de tranferencia la
% cual me ayudará a encontrar los K del PID a diseñar. Para esto se utiliza
% la función pidTuner y se modificaron los parámetros hasta tener las
% condiciones deseadas.
%
% Kp = 374837.2572
% Ki = 1166937.2604
% Kd = 30100.7976



%% Ejercicio 3
% Modifique el controlador de manera que la acción de control nunca 
% supere los 20000 N en valor absoluto. Se permite degradación del
% desempeño ante el escalón en la referencia, pero ante el escalón de la
% perturbación debe mantener la dinámica.
% (1 puntos)

%% Respuesta Ejercicio 3
%   Para realizarlo, no se modificaron los valores de Kp, Ki, Kd. Se realizó
% otra modifición la cual el PID del ejercicio 2 pasa a ser un I-PD. Esto
% pudo realizar una disminución del máximo valor en valor absoluto de la acción 
% de control y cumpliendo con la consigna de no superar los 20000N.

%% Ejercicio 4
% Agregue al modelo de simulink los componentes necesarios para modelar los
% siguientes detalles:
% La compresión de la suspensión se mide con tres sensores de distancia que
% tienen los siguientes ruidos (no correlacionados):
% Sensor A: 10 mm RMS (el bloque Band-Limited White Noise ya está configurado)
% Sensor B: 5 mm RMS (el bloque Band-Limited White Noise ya está configurado)
% Sensor C: 5 mm RMS (el bloque Band-Limited White Noise ya está configurado)
% (1 punto)

%% Respuesta ejercicio 4
%   Solamente se conectó la salida real a los sumadores. Esta señal limpia se
% suma con un ruido gaussiano, el cual simula un sensor de la vida real, ya
% que estos no devuelven una medición exacta debido al ruido.


%% Ejercicio 5
% Diseñe e implemente un observador de estado (posiblemente como filtro de 
% Kalman) de manera de tener una estimación de la altura del chasis con un
% ruido RMS menor a 5 mm.
% (4 puntos) Si lo diseña por ubicación de polos (usando place o aker)
% (6 puntos) Si lo diseña como filtro de Kalman-Bucy de tiempo continuo 
% (usando lqr), puede llegar a un ruido de 3.5 mm RMS en la primer intento
% correcto

%% Respuesta ejercicio 5
% Este ejercicio se realizó de las dos maneras las cuales se explicarán a continuación:
%
%           ~~~Resolución mediantes ubicación de polos~~~
%
%   Esta resolución no es la mejor para este caso, ya que se requiere de un
% proceso iterativo y el resultado final no llega a ser tan bueno como lo
% es aplicando filtros de Kalman.
%   Para la resolución se tuvo que realizar el polinomio caracteristico
% deseado. Este polinomio tiene la siguiente forma:
%
%                   (s^2) + 2*zeta*omega*s + w^2 = 0
%
%   Para buscar los valores de zeta y omega del polinomio antes nombrado, se
% utilizó la tabla que se encuentra en el libro Astrom y Murray, el cual
% relaciona el overshoot y el tiempo de establecimiento con el omega y el
% zeta que debería tener el sistema. Una vez calculados (utilizando Mp = 0
% y Ts = 1), se procede a calcular los polos de dicho polinomio.
%   Sin embargo, es un polinomio de grado dos, y el polinomio caracteristico
% del sistema es de grado 4. Por esta razón se agregan 2 polos más, los
% cuales son lo suficientemente grandes como para que los polos dominantes
% sean los del polinomio caracteristico deseado.
%   Luego, para calcular la ganancia del observador, se utilizó la función
% acker 3 veces (una para cada sensor), y luego se armó un "L" el cual
% contempla estas tres ganancias.
%   Finalmente, se realizaron las conexiones correspondientes en Simulink,
% utilizando un C_obs (matriz que contempla la salida  de los tres
% sensores), y B_ss_terreno (matriz de entrada el cual contempla
% aceleraciones producidas de las masas). Estas aceleraciones tendrán los
% mismos sentidos para las dos masas, ya que es la ejercida por el
% terreno.
%
%               ~~~Resolución mediantes filtro de Kalman~~~
%
%   Primero se realizaron, como se explicó anteriormente, las matrices
% C_obs y B_ss_terreno.
%   Luego se realizaron las matrices Q_proceso y R_sensores, los cuales
% representan las perturbaciones y los ruidos de los sensores
% respectivamente. Sin embargo, hay que tener en cuenta, que los valores
% introducidos a estas matrices son de señales estocásticas. Esto quiere
% decir que no se pueden determinar con exactitud. Por ejemplo, no
% sabemos como será la condición de la ruta con exactidud en cada instante, pero si
% podriamos saber por donde circula el colectivo y teniendo la
% informacion suficiente de dicho camino, utilizar la raiz cuadrática
% media de las imperfecciones y utilizar ese valor (q) para relizar el filtro de Kalman. Esta
% misma explicación se proyecta a los sensores, los cuales el ruido
% generado es de manera estocástica pero si podriamos tener la
% información de sus RMS.
%   Estos valores se introducen a las matrices Q_proceso (calculado como 
% B_ss_terreno * [q^2] * B_ss_terreno') y R_sensores (matriz diagonal)
% luego, utilizando la función "lqr" se calcula la ganancia del observador.
%
% Conclusión: Se puede observar que utilizando 3 sensores, se puede lograr
% una mejor observación de la posición.

%% Parameters (golden car)
clc
clear
close all

m_s = 3000;  % Sprung mass (masa del chasis por rueda) (kg)
k_s = 63.3*m_s;  % Spring stiffness (rigidez del resorte) (N/m)
c_s = 6*m_s;  % Damping coefficient (coeficiente de amortiguamiento del amortiguador) (Ns/m)
k_t = 653*m_s;  % Tire stiffness (rigidez del neumático) (N/m)
c_t = 0;  % Tire damping (Ns/m)
m_u = 0.15*m_s;  % (masa de la rueda) Unsprung mass (kg)


%% Diseño del PID
% x = [pos_u
%      pos_s
%      vel_u
%      vel_s]

M = [m_u 0
     0   m_s];
K = [k_s+k_t -k_s
     -k_s     k_s]
C = [c_s+c_t -c_s
     -c_s     c_s]
A_ss = [ 0 0 1 0 
         0 0 0 1
        -M\K -M\C] 

B_ss = [ 0
         0
         (M^-1) * [ 1
                    -1 ]]

C_ss = [ -1 1 0 0]
D_ss = [ 0 ]
     
H = tf(ss(A_ss, B_ss, C_ss, D_ss))
stepinfo(H)
%pidTuner(H, 'PID');


%% Diseño del filtro de Kalman
C_obs = [ 1 -1 0 0
          1 -1 0 0 
          1 -1 0 0 ]
B_ss_terreno = [ 0
                 0
                 -1
                 -1 ]
q = 0.8653;
Q_proceso = B_ss_terreno * [q^2] * B_ss_terreno';
r = [0.001;0.0005;0.0005];
R_sensores = [ r(1)^2 0       0 
               0       r(2)^2 0
               0       0       r(3)^2 ];

L = (lqr(A_ss', C_obs', Q_proceso, R_sensores))';

%% Diseño por ubicación de polos
Mp = 0;
Ts = 1;
zeta = sqrt(1/(pi^2/(log(Mp)^2)+1));
omega = 4/(zeta*Ts);
polos_deseados = (roots([1 2*zeta*omega omega^2]))';
polos_agregar = [polos_deseados(1)*3,polos_deseados(2)*3];
polos = [polos_deseados,polos_agregar];

rap = 4.5; %Representa la rapidez del observador con respecto a la planta
L1 = acker(A_ss',C_obs(1,:)',polos*rap)';
L2 = acker(A_ss',C_obs(2,:)',polos*rap)';
L3 = acker(A_ss',C_obs(3,:)',polos*rap)';
L = [L1,L2,L3];    %Descomentar si es que se quiere utilizar el método por ubicación de polos
