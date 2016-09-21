Tempo = [1:1:26];
Conc = [0.157919111 0.209889884 0.241792734 0.317433364 0.398734177 0.484666049 ... 
        0.689410312 0.883914789 0.900380776 1.372645878 1.382937121 1.580528970 ...
        1.634043429 1.687557888 1.720489863 1.854276011 1.730781105 1.957188433 ...
        1.981887414 2.745291757 2.605330863 2.469486467 1.909642894 2.177215190 ...
        2.395389524 2.523000926];

                            %% ===========================================
                            %  ====== Carregando Tabelas =================    
TT = readtable('H:\Experimento\Dados\20160111\ExpPicoCorr.dat',...
    'Delimiter',' ','ReadVariableNames',true);
AA = TT{1:end,{'Tempo_h','Corrente_mA'}};

tempoA= AA(:,1);
Corrente= AA(:,2);

                            %% ============================================
                            %  ============= Ajuste de Curvas =============

                            %  Concentração
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
tempo=tempoA;
conc=Corrente;
coef_ini = [50 1 2]; 
coef=[];
OPTIONS = optimset('MaxIter',1000,'TolFun',0.001,'TolX',0.01);
coef = fminsearch(@funcaoerro_sigmoide,coef_ini,OPTIONS);
A=coef(1);
B=coef(2);
C=coef(3);
y = A*(sigmf(tempo, [B C]));
CorrA=y;                            
                            
                            
                            %% ============================================
                            %  ================ Graficos ==================
subplot(2,1,1);
plot(Tempo, Conc,'x');
xlabel('Tempo (h)');
ylabel('Concentração biomassa [X] (g/L)');
hold on;
% ConcA = 2.109*sigmf(Tempo,[0.8561 2.853]);
plot(Tempo, ConcA,'r');
subplot(2,1,2);
plot(tempoA, Corrente,'o');
xlabel('Tempo (h)');
ylabel('Pico de Corrente (mA)');
hold on;
% CorrA = 72.52*sigmf(Tempo1,[.3394 -9.013])-54.23;
% CorrB = 18.27*sigmf(Tempo1,[.3715 -4.183]);
plot(tempoA, CorrA,'r');
hold on;
% plot(Tempo1, CorrB,'g');
