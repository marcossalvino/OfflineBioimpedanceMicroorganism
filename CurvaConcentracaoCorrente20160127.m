close all;
clear all;

global tempo conc;


Conc=[13.039415457 14.603684265 23.477204899 25.650715241 26.869198312 ...
    27.000926212 25.057939693 26.737470413 26.408150664 27.033858187 ...
    25.584851292 26.078830915 27.231450036 25.947103015 25.749511166 ...
    25.914171040 26.210558814 24.794483894 25.189667593 24.893279819 ...
    24.531028095 22.620973552];
% Tempo=[1:length(Conc)];

                            %% ===========================================
                            %  ====== Carregando Tabelas =================    
TT = readtable('H:\Experimento\Dados\20160127\ExpPicoCorr.dat',...
    'Delimiter',' ','ReadVariableNames',true);
AA = TT{1:end,{'Tempo_h','Corrente_mA'}};
tempoA= AA(:,1);
Corrente= AA(:,2);

                            %% ============================================
                            %  ============= Ajuste de Curvas =============
                            %  ============= Concentração
                            
tempo=tempoA';
Tempo=tempo;
% tempo=Tempo;

conc=Conc;
coef_ini = [50 1 2]; 
coef=[];
OPTIONS = optimset('MaxIter',1000,'TolFun',0.001,'TolX',0.01);
coef = fminsearch(@funcaoerro_sigmoide,coef_ini,OPTIONS);
A=coef(1);
B=coef(2);
C=coef(3);
y = A*sigmf(tempo, [B C]);
ConcA=y;                     

                            %  Corrente
tempo=tempoA(2:end);
coef_ini = [-0.8675 0.4 9 4.605];
% coef_ini = [0.4387 0.3171 0.9502 0.0344];
Corrente=Corrente(2:end);

conc=Corrente;
coef=[];
OPTIONS = optimset('MaxIter',1000,'TolFun',0.001,'TolX',0.01);
coef = fminsearch(@funcaoerro_sigmoide_R,coef_ini,OPTIONS);
A=coef(1);
B=coef(2);
C=coef(3);
D=coef(4)
y = A*(1-sigmf(tempo, [B C]))+D;
CorrA=y;                            
                            
                            
                            %% ============================================
                            %  ================ Graficos ==================
subplot(2,1,1);
plot(Tempo, Conc,'x');
xlabel('Tempo (h)');
ylabel('Concentração biomassa [X] (g/L)');
hold on;
% ConcA = 2.109*sigmf(Tempo,[0.8561 2.853]);
plot(Tempo, ConcA,'r','LineWidth', 2);
subplot(2,1,2);
plot(tempo, Corrente,'o');
xlabel('Tempo (h)');
ylabel('Pico de Corrente (mA)');
hold on;
% CorrA = 72.52*sigmf(Tempo1,[.3394 -9.013])-54.23;
% CorrB = 18.27*sigmf(Tempo1,[.3715 -4.183]);
plot(tempo, CorrA,'r','LineWidth', 2);
% hold on;
% plot(Tempo1, CorrB,'g');
