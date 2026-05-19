s = tf('s');

Gp = 2*(s+1)/(s*(s+3)*(s+5));

C1 = (33*s^3 + 924*s^2 + 6880*s + 32000)/(2*s*(s+1));
C2 = s*(12*s - 15)/(2*(s+1));

C = C1 + C2;

Tyr = minreal(C1*Gp/(1 + C*Gp));
Tyd = minreal(Gp/(1 + C*Gp));

figure;
step(Tyr)
grid on
title('Respuesta a referencia escalón')

figure;
step(Tyd)
grid on
title('Respuesta a perturbación escalón')

stepinfo(Tyr)