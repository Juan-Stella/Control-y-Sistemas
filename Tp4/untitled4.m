clc;
clear;
close all;

%% Datos del problema
fmax = 100;          % banda util maxima [Hz]
fs  = 2200;          % frecuencia de muestreo minima hallada [Hz]
fsf = 200;           % frecuencia final deseada luego de decimar [Hz]
M   = fs/fsf;        % factor de decimacion

if abs(M-round(M)) > 1e-12
    error('M no es entero. Cambia fs o fsf.');
end
M = round(M);

fprintf('fs = %.1f Hz\n', fs);
fprintf('fs final = %.1f Hz\n', fsf);
fprintf('M = %d\n', M);
fprintf('wc = pi/%d rad\n', M);

%% Eje de frecuencias
f = linspace(-3000,3000,12001);

%% 1) Espectro analogico "idealizado" de la señal util
% Triangulo centrado en 0 entre -fmax y fmax
Xsig = max(1 - abs(f)/fmax, 0);

%% 2) Filtro antialiasing analogico simple
% Queremos algo que aproxime:
% -3 dB en 500 Hz
% -60 dB en 2000 Hz
%
% Uso una magnitud tipo Butterworth y busco un orden que aproxime ambas.
fc_aa = 500;  % frecuencia de -3 dB
target_db_2000 = -60;

best_n = 1;
best_err = inf;

for n = 1:20
    Htest = 1 ./ sqrt(1 + (abs(2000)/fc_aa).^(2*n));
    dbtest = 20*log10(Htest);
    err = abs(dbtest - target_db_2000);
    if err < best_err
        best_err = err;
        best_n = n;
    end
end

n_aa = best_n;
Haa = 1 ./ sqrt(1 + (abs(f)/fc_aa).^(2*n_aa));

fprintf('Orden aproximado del filtro analogico para acercarse a -60 dB en 2000 Hz: n = %d\n', n_aa);

%% Espectro luego del filtro analogico
Xa = Xsig .* Haa;

%% 3) Espectro luego del muestreo a fs
% Replicas cada k*fs
Xs = zeros(size(f));
kvals = -2:2;
for k = kvals
    Xs = Xs + interp1(f, Xa, f - k*fs, 'linear', 0);
end

%% 4) Filtro digital abrupto antes de decimar
% Antes de decimar por M, hay que dejar solo hasta fs/(2M)=100 Hz
fd = fs/(2*M);   % corte en Hz
Hd = double(abs(f) <= fd);

Xf = Xs .* Hd;

%% 5) Espectro final luego de decimar
% Esquema ilustrativo: replico con la nueva fs final
Xd = zeros(size(f));
kvals2 = -6:6;
for k = kvals2
    Xd = Xd + interp1(f, Xf, f - k*fsf, 'linear', 0);
end

%% Graficos
figure('Color','w','Position',[100 80 1100 850]);

subplot(5,1,1)
plot(f, Xsig, 'LineWidth', 1.5)
grid on
xlim([-2500 2500])
ylim([0 1.2])
title('1) Espectro analogico original')
xlabel('Frecuencia [Hz]')
ylabel('|X_c(f)|')
xline(-fmax,'--r','-f_{max}');
xline(fmax,'--r','f_{max}');

subplot(5,1,2)
plot(f, Haa, 'LineWidth', 1.5)
grid on
xlim([0 2500])
ylim([0 1.1])
title(sprintf('2) Filtro antialiasing analogico simple (aprox. Butterworth, n=%d)', n_aa))
xlabel('Frecuencia [Hz]')
ylabel('|H_{aa}(f)|')
xline(500,'--r','500 Hz');
xline(2000,'--r','2000 Hz');

subplot(5,1,3)
plot(f, Xs, 'LineWidth', 1.5)
grid on
xlim([-2500 2500])
ylim([0 1.5])
title(sprintf('3) Espectro luego del muestreo a f_s = %g Hz', fs))
xlabel('Frecuencia [Hz]')
ylabel('|X_s(f)|')
for k = kvals
    xline(k*fs, ':k');
end

subplot(5,1,4)
plot(f, Xf, 'LineWidth', 1.5)
grid on
xlim([-500 500])
ylim([0 1.2])
title(sprintf('4) Luego del filtro digital antialiasing previo a decimar (corte = %g Hz)', fd))
xlabel('Frecuencia [Hz]')
ylabel('|X_f(f)|')
xline(-fd,'--r','-f_c');
xline(fd,'--r','f_c');

subplot(5,1,5)
plot(f, Xd, 'LineWidth', 1.5)
grid on
xlim([-600 600])
ylim([0 1.5])
title(sprintf('5) Espectro esquematico luego de decimar por M = %d (f_{s,final} = %g Hz)', M, fsf))
xlabel('Frecuencia [Hz]')
ylabel('|X_d(f)|')
for k = -3:3
    xline(k*fsf, ':k');
end

sgtitle('Esquema de oversampling y filtro antialiasing')