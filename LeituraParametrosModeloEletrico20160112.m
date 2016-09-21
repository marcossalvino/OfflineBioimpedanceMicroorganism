close all;
clear all;

global tempo conc;

                            %% ===========================================
                            %  ====== Carregando Tabelas =================
T = readtable('E:\Experimento\Dados\20160111\Exp20160112Model.dat',...
    'Delimiter',' ','ReadVariableNames',true);
Aa = T{1:end,{'Rs_Ohms','Rcy_Ohms','Cm_uF','Cdl_uF'}};

TT = readtable('E:\Experimento\Dados\20160111\ExpPicoCorr.dat',...
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
delta_Cdl=(Cdl(:)- Cdl1)./Cdl1*100;

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

delta_Cm=(Cm-Cm(1))./Cm(1)*100;
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
coef_ini = [30 3 10 200]; 
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
% coef_ini = [1 0.3 20 60]; 
coef_ini = [30 3 10 200];
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

figure;
relacao_Cdl_Cm=fCdl./fCm; 
plot(Tempo,relacao_Cdl_Cm,'s--');
xlabel('Tempo (h)');
ylabel('Razão Cdl/Cm');
grid on;

                            %% ===== Curva de Picos de Corrente =====
                            % ======================================
coef_ini = [20 1 2];

conc=Corrente;
coef=[];
OPTIONS = optimset('MaxIter',1000,'TolFun',0.001,'TolX',0.01);
coef = fminsearch(@funcaoerro_sigmoide,coef_ini,OPTIONS);
A=coef(1);
B=coef(2);
C=coef(3);
y = A*(sigmf(tempo, [B C]));
fCorrente=y;

figure;
plot(Tempo,Corrente,'-*');
hold on;
plot(Tempo,fCorrente,'r','LineWidth', 2);
% axis([0 12 0 200]);
title('\bf Variação do Pico de Corrente');
xlabel('Tempo (h)');
ylabel('i (\muA)');
                            
                                                      


