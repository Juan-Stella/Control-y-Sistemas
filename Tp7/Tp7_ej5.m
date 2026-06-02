clear; clc;

% Nombre de tu modelo
mdl = "ej5_simscape";   % Cambiar si tu modelo tiene otro nombre

omega_obj = 3*pi/4;   % rad/s
tf = 2;

load_system(mdl);
set_param(mdl, "StopTime", num2str(tf));

% Valores de prueba
V_prueba = linspace(60, 90, 50);
errores = zeros(size(V_prueba));

for k = 1:length(V_prueba)

    Vmax = V_prueba(k);
    assignin("base","Vmax",Vmax);   % esto carga Vmax al Workspace

    out = sim(mdl);

    omega = out.get("omega");
    omega_final = omega.Data(end);

    errores(k) = omega_final - omega_obj;

    fprintf("Vmax = %8.3f V | omega final = %8.4f rad/s | error = %10.5f\n", ...
        Vmax, omega_final, errores(k));
end

% Buscar cambio de signo
idx = find(errores(1:end-1).*errores(2:end) <= 0, 1);

if isempty(idx)
    error("No se encontró cambio de signo. Probá ampliar el rango de V_prueba o revisar el signo del motor/torque.");
end

V1 = V_prueba(idx);
V2 = V_prueba(idx+1);

fprintf("\nIntervalo encontrado: [%.3f, %.3f]\n", V1, V2);

% Función para fzero
error_fun = @(Vmax) calcular_error(mdl, Vmax, omega_obj);

Vmax_sol = fzero(error_fun, [V1 V2]);

assignin("base","Vmax",Vmax_sol);

fprintf("\nVmax requerido = %.4f V\n", Vmax_sol);

% Simulación final
out = sim(mdl);

omega = out.get("omega");
omega_final = omega.Data(end);

fprintf("Velocidad final = %.4f rad/s\n", omega_final);
fprintf("Velocidad objetivo = %.4f rad/s\n", omega_obj);


function error_w = calcular_error(mdl, Vmax, omega_obj)

    assignin("base","Vmax",Vmax);

    out = sim(mdl);

    omega = out.get("omega");
    omega_final = omega.Data(end);

    error_w = omega_final - omega_obj;

end