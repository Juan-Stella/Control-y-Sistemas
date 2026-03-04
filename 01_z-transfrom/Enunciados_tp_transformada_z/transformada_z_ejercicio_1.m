%[text] # Trabajo Practico 1: Transformada Z - Ejercicio 1
%[text:tableOfContents]{"heading":"Table of Contents"}
%[text] ## Ejercicio 1:
%[text] %[text:anchor:TMP_48f9] Encuentre la transformada Z de las siguiente signales discretas e indique su ROC
%[text] "Para cada una de las signales analizadas, emplee la función **`zplane`** para graficar el diagrama de polos y ceros, lo cual le permitirá visualizar la Región de Convergencia (ROC). Posteriormente, utilice la función **`freqz`** para obtener y analizar la respuesta en frecuencia del sistema, detallando tanto el espectro de magnitud como el de fase."
%[text] 1. $&dollar&;x\[n\] = \[1/3\]^n u\[n\]&dollar&;$
%[text] 2. $&dollar&;x\[n\] = -\[1/2\]^n u\[-n-1\]&dollar&;$
%[text] 3. $&dollar&;x\[n\] = (1/2)^n u\[n\] - (2)^n u\[-n-1\]&dollar&;$
%[text] 4. $&dollar&;x\[n\] = -(1/2)^n u\[n\] - (1/2)^n u\[-n-1\]&dollar&;$ \

%% LIMPIEZA DEL ENTORNO Y CONFIGURACIÓN GLOBAL
clear; clc; close all;

% Aumentar el tamaño de la fuente para que sea legible en el documento
set(groot, 'defaultAxesFontSize', 12);
set(groot, 'defaultTextFontSize', 12);

% Hacer las líneas y los marcadores un poco más gruesos
set(groot, 'defaultLineLineWidth', 1.5);
set(groot, 'defaultStemLineWidth', 1.5); % Muy útil para señales discretas
set(groot, 'defaultLineMarkerSize', 8);





%%
%[text] ### Signal 1
%[text] $&dollar&;x\[n\] = \[1/3\]^n u\[n\]&dollar&;$



%%
%[text] ### Signal 2
%[text] $&dollar&;x\[n\] = -\[1/2\]^n u\[-n-1\]&dollar&;$


%%
%[text] ### Signal 3
%[text] $&dollar&;x\[n\] = (1/2)^n u\[n\] - (2)^n u\[-n-1\]&dollar&;$



%%
%[text] ### Signal 4
%[text] $&dollar&;x\[n\] = -(1/2)^n u\[n\] - (1/2)^n u\[-n-1\]&dollar&;$
%[text] 
%%
%[text] ## Conclusiones y Preguntas
%[text] 1. En este ejercicio concluimos que  \
%[text] 
%[text] 
%[text] 
%[text] 

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline","rightPanelPercent":54.3}
%---
