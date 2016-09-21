close all;
clear all;

global tempo conc;

                            %% ===========================================
                            %  ====== Carregando Tabelas =================
T = readtable('I:\Experimento\Dados\20160127\Exp20160128Model.dat',...
    'Delimiter',' ','ReadVariableNames',true);
Aa = T{1:end,{'Rs_Ohms','Rcy_Ohms','Cm_uF','Cdl_uF'}};

TT = readtable('I:\Experimento\Dados\20160127\ExpPicoCorr.dat',...
    'Delimiter',' ','ReadVariableNames',true);
AA = TT{1:end,{'Tempo_h','Corrente_mA'}};

Rs = Aa(:,1); 
Rcy = Aa(:,2);
Cm = Aa(:,3);
Cdl = Aa(:,4);
tempo=[1:length(Rs)]';
Tempo=tempo;

Corrente= AA(:,2);

                            %% ============================================
                            %  === Ajustes sigmoidais das capacitâncias ===
Cdl1=Cdl(1);
delta_Cdl=100*((Cdl(:)- Cdl1)./Cdl1);

coef_ini = [50 1 2];

conc=delta_Cdl;
coef=[];
OPTIONS = optimset('MaxIter',1000,'TolFun',0.001,'TolX',0.01);
coef = fminsearch(@funcaoerro_sigmoide,coef_ini,OPTIONS);
A=coef(1);
B=coef(2);
C=coef(3);
y = A*sigmf(tempo, [B C]);
fCdl=y;

figure;
subplot(2,1,1);
plot(Tempo,delta_Cdl,'*');
hold on;
plot(Tempo,fCdl,'r','LineWidth', 2);
% axis([0 12 0 200]);
title('\bf Variação da Capacitância Eletrodo x Tempo');
xlabel('Tempo (h)');
ylabel('% Cdl');

delta_Cm=100*((Cm-Cm(1))./Cm(1));
conc=delta_Cm;
coef=[];
OPTIONS = optimset('MaxIter',1000,'TolFun',0.001,'TolX',0.01);
coef = fminsearch(@funcaoerro_sigmoide,coef_ini,OPTIONS);
A=coef(1);
B=coef(2);
C=coef(3);
y = A*sigmf(tempo, [B C]);
fCm=y;

subplot(2,1,2);
plot(Tempo,delta_Cm,'*');
hold on;
plot(Tempo,fCm,'r','LineWidth', 2);
% axis([0 12 0 200]);
title('\bf Variação da Capacitância Membrana x Tempo');
xlabel('Tempo (h)');
ylabel('% Cm');

                            %% ============================================
                            %  ====== Comportamento das resistências ======
conc=Rs;
coef_ini = [1 0.3 20 60]; 
coef=[];
OPTIONS = optimset('MaxIter',1000,'TolFun',0.001,'TolX',0.01);
coef = fminsearch(@funcaoerro_sigmoide_R,coef_ini,OPTIONS);
A=coef(1);
B=coef(2);
C=coef(3);
D=coef(4);
y = A*(1-sigmf(tempo, [B C]))+D;
Rs1=y;

conc=Rcy;
coef_ini = [1 0.3 20 60]; 
coef=[];
OPTIONS = optimset('MaxIter',1000,'TolFun',0.001,'TolX',0.01);
coef = fminsearch(@funcaoerro_sigmoide_R,coef_ini,OPTIONS);
A=coef(1);
B=coef(2);
C=coef(3);
D=coef(4);
y = A*(1-sigmf(tempo, [B C]))+D;
Rcy1=y;

figure;
subplot(2,1,1);
plot(Tempo,Rs,'*');
hold on;
plot(Tempo,Rs1,'r','LineWidth', 2);
title('\bf Resistência Solução x Tempo');
xlabel('Tempo (h)');
ylabel('Resistência Solução (\Omega)');

subplot(2,1,2);
plot(Tempo,Rcy,'*');
hold on;
plot(Tempo,Rcy1,'r','LineWidth', 2);
title('\bf Resistência Intracelular x Tempo');
xlabel('Tempo (h)');
ylabel('Resistência Intracelular (\Omega)');


                            %%  Curva de Variação Capacitâncias e Razão Resistências
figure;
% subplot(2,1,2);
relacao_Rcy_Rs=Rcy./Rs;
plot(Tempo,relacao_Rcy_Rs,'s--');
xlabel('Tempo (h)');
ylabel('Razão Rcy/Rs1');
grid on;
hold on;

conc=relacao_Rcy_Rs;
coef_ini = [.2769 .7060 .0318 .6555]; 
coef=[];
OPTIONS = optimset('MaxIter',1000,'TolFun',0.001,'TolX',0.01);
coef = fminsearch(@funcaoerro_sigmoide_R,coef_ini,OPTIONS);
A=coef(1);
B=coef(2);
C=coef(3);
D=coef(4);
y = A*(1-sigmf(tempo, [B C]))+D;
Rcy_Rs=y;

% Rcy_Rs=0.7945*(1-sigmf(tempo, [-0.3927 -2.821]));

plot(Tempo,Rcy_Rs,'-r','LineWidth', 2);


figure;
relacao_Cdl_Cm=(fCdl./fCm); 
plot(Tempo,relacao_Cdl_Cm,'s--','LineWidth', 2);
xlabel('Tempo (h)');
ylabel('Razão Cdl/Cm');
grid on;
hold on;
plot(Tempo, Cdl./Cm,'ko');

                            %%===== Curva de Picos de Corrente =====
                            % ======================================
coef_ini = [4.173 12.84 0.9315 4.605];
% coef_ini = [0.4387 0.3171 0.9502 0.0344];
conc=Corrente;
coef=[];
OPTIONS = optimset('MaxIter',1000,'TolFun',0.001,'TolX',0.01);
coef = fminsearch(@funcaoerro_sigmoide_R,coef_ini,OPTIONS);
A=coef(1);
B=coef(2);
C=coef(3);
D=coef(4)
y = A*(1-sigmf(tempo, [B C]))+D;
fCorrente=y;

% fCorrente=4.173*(1-sigmf(tempo, [12.84 0.9315]))+4.605;

figure;
plot(Tempo,Corrente,'-*');
hold on;
plot(Tempo,fCorrente,'r','LineWidth', 2);
% axis([0 12 0 200]);
title('\bf Variação do Pico de Corrente');
xlabel('Tempo (h)');
ylabel('i (mA)');
                            
                                                      


