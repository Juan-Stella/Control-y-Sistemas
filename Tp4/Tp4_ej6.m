clc, clear all

q1 = quantizer('fixed','floor','saturate',[32 0]);
q2 = quantizer('fixed','floor','saturate',[32 8]);
q3 = quantizer('fixed','floor','saturate',[32 16]);

u = linspace(-15,15,1000);

y1 = quantize(q1,u);
y2 = quantize(q2,u);
y3 = quantize(q3,u);

r1 = rmse(u , y1)
r2 = rmse(u , y2)
r3 = rmse(u , y3)


%A mayor cantidad de bits fraccionales, menor error de cuantización y menor RMSE,
% ya que el cuantizador puede representar con mayor precisión los valores de entrada.

figure;

subplot(3,1,1)
plot(u,u,'k','LineWidth',1.2); hold on;
plot(u,y1,'r');
grid on;
title('Q31.0: u vs y');
legend('u (original)','y1 (cuantizada)');

subplot(3,1,2)
plot(u,u,'k','LineWidth',1.2); hold on;
plot(u,y2,'b');
grid on;
title('Q23.8: u vs y');
legend('u (original)','y2 (cuantizada)');

subplot(3,1,3)
plot(u,u,'k','LineWidth',1.2); hold on;
plot(u,y3,'g');
grid on;
title('Q15.16: u vs y');
legend('u (original)','y3 (cuantizada)');