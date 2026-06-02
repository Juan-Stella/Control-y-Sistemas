clc, clear

m=20000;                % Vehicle mass [kg]
k=2000;                % Engine torque gain factor [Nm/rad]
r=4;                    % Gear ratio (for a specific gear) [-]
tau=0.8;                % Engine time constant [s]
g=9.82;                 % Gravity [m/s^2]
rho=1.2;                % Air density [kg/m^3]
CD=0.5;                 % Drag coefficient [-]
Af=4;                   % Front area [m^2]
rw=0.5;                 % Wheel radius [m]
f=0.015;                % Rolling resistance coefficient [-]\\

alpha = 2*pi/120;

x2e=20;                 
x1e=0.5*rho*CD*Af*x2e^2+m*g*f;
ue=rw*x1e/k/r;
de=0;

%% 
A=[[-1/tau 0];[1/m -rho*CD*Af*x2e/m]];
B=[k*r/tau/rw 0]';
H=[0 -g]';
C=[0 1];
D=[0];

%%  Sistema aumentado
A_aug = [A, [0;0]; C, 0];
B_aug = [B; 0];
F_aug = [0; 0; -1];

%%  Polos deseados (3 polos ahora)
wn   = 0.6;
zeta = 1/sqrt(2);
s12  = roots([1, 2*zeta*wn, wn^2]);
s3   = -3*zeta*wn;

polos_aug = [s12; s3];


%% Verificar controlabilidad
Wr_aug = ctrb(A_aug, B_aug);
rango = rank(Wr_aug);
n = size(A_aug, 1);
fprintf('\nRango de Wr = %d, n = %d\n', rango, n);
if rango == n
    fprintf('El sistema ES controlable.\n');
else
    fprintf('El sistema NO es controlable.\n');
end


%%  Ganancia por Ackermann
K_aug = acker(A_aug, B_aug, polos_aug);
fprintf('K_aug = [%.6f, %.6f, %.6f]\n', K_aug(1), K_aug(2), K_aug(3));


%% ---------------------------------------------------
% For simulation purposes (do not modify)
%---------------------------------------------------
B1=[B H];                   % Put the B and H matrix together as one matrix B1 (for Simulink implementation purposes) 
C1=eye(2);                  % Output all state variables from the model
D1=zeros(2);              % Corresponding D matrix
