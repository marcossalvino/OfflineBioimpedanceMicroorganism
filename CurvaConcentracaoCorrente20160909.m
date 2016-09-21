close all;
clear all;

global tempo conc;


Conc=[0.332870227 0.393073994 0.663682206 0.847895441 1.393228363 1.732839354 ...
    1.689616137 1.767829577 1.839868272 1.642276423 1.566121231 1.689616137];

 Tempo=[1:length(Conc)];

                            %% ===========================================
                            %  ====== Carregando Tabelas =================    
TT = readtable('H:\Experimento\Dados\20160909\ExpPicoCorr.dat',...
    'Delimiter',' ','ReadVariableNames',true);
AA = TT{1:end,{'Tempo_h','Corrente_mA'}};
tempoA= AA(:,1);
Corrente= AA(:,2);

                            %% ============================================
                            %  ============= Ajuste de Curvas =============
                            %  ============= Concentração
                            
% tempo=tempoA';
% Tempo=tempo;
tempo=Tempo;

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
tempo=tempoA(1:end);
coef_ini = [-0.8675 0.4 9 4.605];
% coef_ini = [0.4387 0.3171 0.9502 0.0344];
Corrente=Corrente(1:end);

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
% CorrA = -0.3883*sigmf(Tempo,[1.732 5.742])-14.48;
                            
                            
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
