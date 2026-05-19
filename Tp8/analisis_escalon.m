%% analisis_control_P.m

%% Parámetros
b = 10000; a = 200; m1 = 1000; m2 = 1500; Kp = 1;
g = 9.82;  alpha = 2*pi/180; d = g*sin(alpha);
r2 = 30;

%% Extraer datos
t_esc  = out.v_escalon.Time;               v_esc  = out.v_escalon.Data;
t_pert = out.v_escalon_perturbacion.Time;  v_pert = out.v_escalon_perturbacion.Data;
t_m15  = out.v_m1500.Time;                v_m15  = out.v_m1500.Data;

%% SS analíticos para ylim zooms
vss_30     = (b*Kp*r2)        / (a + b*Kp);
vss_pert   = (b*Kp*r2 - m1*d) / (a + b*Kp);
vss_m1500p = (b*Kp*r2 - m2*d) / (a + b*Kp);
zoom_min   = min(vss_pert, vss_m1500p) - 0.05;
zoom_max   = vss_30 + 0.05;

%% ── Figura 1: Escalón ────────────────────────────────────────────────────────
figure('Name','b) Escalón','Position',[100 100 700 450])
plot(t_esc, v_esc, 'r', 'LineWidth', 1.5)
xlabel('Tiempo [s]'); ylabel('v [m/s]')
title('b) Escalón 25→30 m/s — Lazo Cerrado')
grid on

%% ── Figura 2: Perturbación — completa + zoom ─────────────────────────────────
figure('Name','c) Perturbación','Position',[100 100 1200 450])

subplot(1,2,1)
plot(t_esc,  v_esc,  'b', 'LineWidth', 1.5); hold on
plot(t_pert, v_pert, 'r', 'LineWidth', 1.5)
xlabel('Tiempo [s]'); ylabel('v [m/s]')
title('c) Perturbación \alpha=2° a t=20 s')
legend('Sin perturbación','Con perturbación','Location','southeast')
grid on

subplot(1,2,2)
plot(t_esc,  v_esc,  'b', 'LineWidth', 1.5); hold on
plot(t_pert, v_pert, 'r', 'LineWidth', 1.5)
xlim([18, t_pert(end)])
ylim([zoom_min, zoom_max])
xlabel('Tiempo [s]'); ylabel('v [m/s]')
title('c) Zoom — efecto de la perturbación en SS')
legend('Sin perturbación','Con perturbación','Location','northeast')
grid on

%% ── Figura 3: Cambio de masa — completa + zoom ───────────────────────────────
figure('Name','d) Masa','Position',[100 100 1200 450])

subplot(1,2,1)
plot(t_pert, v_pert, 'b', 'LineWidth', 1.5); hold on
plot(t_m15,  v_m15,  'r', 'LineWidth', 1.5)
xlabel('Tiempo [s]'); ylabel('v [m/s]')
title('d) m=1000 vs m=1500 kg (con perturbación)')
legend('m = 1000 kg','m = 1500 kg','Location','southeast')
grid on

subplot(1,2,2)
plot(t_pert, v_pert, 'b', 'LineWidth', 1.5); hold on
plot(t_m15,  v_m15,  'r', 'LineWidth', 1.5)
xlim([18, t_pert(end)])
ylim([zoom_min, zoom_max])
xlabel('Tiempo [s]'); ylabel('v [m/s]')
title('d) Zoom SS — m=1000 vs m=1500 kg')
legend('m = 1000 kg','m = 1500 kg','Location','northeast')
grid on