%---------------------------------------------------
% Exercises on 3.4.2 - Driveline control
% Vehicle parameters
%---------------------------------------------------

Jc=6250;                        % Chassis inertia [kgm^2]
Jf=0.625;                       % Flywheel inertia [kgm^2]
ds=1000;                        % Driveshaft damping coefficient [Nms/rad]
cs=75000;                       % Driveshaft spring coefficient [Nm/rad]
r=57;                           % Gear ratio [-]

%---------------------------------------------------
% Enter your A, B and H matrices here
%---------------------------------------------------
A = [-ds/(Jf*r^2),  ds/(Jf*r),  -cs/(Jf*r);
      ds/(Jc*r),   -ds/Jc,       cs/Jc;
      1/r,          -1,           0         ];

B = [1/Jf; 0; 0];          % entrada: torque motor Te

H = [0; -1/Jc; 0];         % perturbacion: torque de carga TL


%---------------------------------------------------
% Enter your control design here
% Hint: charpoly - could be a good  and useful function
%---------------------------------------------------
wn   = 6;
zeta = 1/sqrt(2);

s_dom = roots([1, 2*zeta*wn, wn^2]);   % dos polos dominantes
s3    = -2*zeta*wn;                     % tercer polo (2x mas rapido)

Wr       = poly([s_dom; s3]);           % polinomio deseado (coeficientes)
Wr_tilde = charpoly(A);                 % polinomio actual de A

K  = place(A, B, [s_dom; s3]);          % ganancia de realimentacion

%---------------------------------------------------
% For simulation purposes (do not modify)
%---------------------------------------------------
B1=[B H];                       % Put the B and H matrix together as one matrix B1 (for Simulink implementation purposes) 
C=eye(3);                       % Output all state variables from the model
D=zeros(3,2);                   % Corresponding D matrix
x0=[120 2 0]';                  % Initial conditions for the state variables

