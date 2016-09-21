close all;
clear all;

global tempo conc;

%% ==============================================
% ====== Ajustes sigmoidais das concentrações =====

Tempo = [0 1 2 3 4 5 7 9 11];
tempo=Tempo;
Viaveis = [42 156 61 171 130 170 196 167 203];
Nviaveis = [3 39 12 21 21 19 31 47 56];
Totais = Viaveis + Nviaveis;
Diluicao = [1 1 2 2 4 4 4 4 4];

CV=(Viaveis.*Diluicao.*1000)/(0.004*5*1000000);
CN=(Nviaveis.*Diluicao.*1000)/(0.004*5*1000000);
CT=(Totais.*Diluicao.*1000)/(0.004*5*1000000);

conc=CT;
coef_ini = [50 1 2]; 
coef=[];
OPTIONS = optimset('MaxIter',1000,'TolFun',0.001,'TolX',0.01);
coef = fminsearch(@funcaoerro_sigmoide,coef_ini,OPTIONS);
A=coef(1);
B=coef(2);
C=coef(3);
y = A*sigmf(tempo, [B C]);
fCT=y;

conc=CV;
coef=[];
OPTIONS = optimset('MaxIter',1000,'TolFun',0.001,'TolX',0.01);
coef = fminsearch(@funcaoerro_sigmoide,coef_ini,OPTIONS);
A=coef(1);
B=coef(2);
C=coef(3);
y = A*sigmf(tempo, [B C]);
fCV=y;

conc=CN;
coef=[];
OPTIONS = optimset('MaxIter',1000,'TolFun',0.001,'TolX',0.01);
coef = fminsearch(@funcaoerro_sigmoide,coef_ini,OPTIONS);
A=coef(1);
B=coef(2);
C=coef(3);
y = A*sigmf(tempo, [B C]);
fCN=y;


subplot(2,1,1);
[ax, h1, h2] = plotyy(Tempo,fCT,[Tempo',Tempo'],[fCV',fCN']);
set(h1, 'LineWidth', 2);
set(h2, 'LineWidth', 2);
set(h1, 'LineStyle', '--');
set(h2, 'LineStyle', ':');
set(ax,'TickLength',[0.02 0.035]);
set(ax,'YTick',[0:10:300]);
grid(ax(1),'on');
xlabel('Tempo (h)');
set(get(ax(1), 'YLabel'), 'String', 'Nº de Células Totais \times10^6/mL');
set(get(ax(2), 'YLabel'), 'String', {'\color{black} Nº de Células Viáveis \times10^6/mL','\color{red} Nº de Células Não-viáveis \times10^6/mL'});
hold on;
plot(Tempo, CT, 'bs');
hold on;
plot(Tempo, CV, 'ko');
hold on;
plot(Tempo, CN, 'rv');

subplot(2,1,2);
relacao_viavel_total=fCV./fCT;
plot(Tempo,relacao_viavel_total,'o-');
xlabel('Tempo (h)');
ylabel('Razão Viável/Total');
grid on;


%% ==============================================
% ====== Ajustes sigmoidais das capacitâncias =====

Cdl = [10.4002 13.1828 15.7406 16.9424 18.9966 22.3324 23.1034 24.3032 26.4651];
delta_Cdl=(Cdl-Cdl(1))/Cdl(1)*100;

Cm = [2.4184 2.9572 3.6289 3.9324 4.5116 4.6401 5.7243 6.0592 6.4873];
delta_Cm=(Cm-Cm(1))/Cm(1)*100;

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
plot(Tempo,fCdl,'r');
axis([0 12 0 200]);
title('\bf Variação da Capacitância Eletrodo x Tempo');
xlabel('Tempo (h)');
ylabel('% Cdl');

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
plot(Tempo,fCm,'r');
axis([0 12 0 200]);
title('\bf Variação da Capacitância Membrana x Tempo');
xlabel('Tempo (h)');
ylabel('% Cm');



%% ===================================================
% ====== Relação concentrações x capacitâncias =====

[P,S] = polyfit(delta_Cdl,CT,1);
CT_estimado=polyval(P,delta_Cdl);

figure;
subplot(2,1,1);
plot(delta_Cdl,CT,'*');
hold on;
plot(delta_Cdl,CT_estimado,'o-r');
% axis([0 12 0 200]);
title('\bf Variação da Capacitância Eletrodo x Concentração Total');
ylabel('Concentração Total');
xlabel('Variação da Capacitância Eletrodo');

[P,S] = polyfit(delta_Cm,CV,1);
CV_estimado=polyval(P,delta_Cm);

subplot(2,1,2);
plot(delta_Cm,CV,'*');
hold on;
plot(delta_Cm,CV_estimado,'o-r');
% axis([0 12 0 200]);
title('\bf Variação da Capacitância Membrana x Concentração Viáveis');
ylabel('Concentração Viáveis');
xlabel('Variação da Capacitância Membrana');


figure;
plot(Tempo, delta_Cdl,'*-b');
hold on;
plot(Tempo,delta_Cm,'o-r');
legend('Cdl','Cm');
xlabel('Tempo (h)');
ylabel('\DeltaCapacitância (%)');

%% ===================================================
% ====== Comportamento das resistências =====
Rs1 = [84.6984 89.4841 75.0470 70.9723 70.9353 69.8985 67.565 67.7668 65.9863];
Rcy1 = [59.3379 59.7414 53.6141 53.7486 54.384 55.8565 53.6668 53.8888 52.796];

conc=Rs1;
coef_ini = [30 10 2 60]; 
coef=[];
OPTIONS = optimset('MaxIter',1000,'TolFun',0.001,'TolX',0.01);
coef = fminsearch(@funcaoerro_sigmoide_R,coef_ini,OPTIONS);
A=coef(1);
B=coef(2);
C=coef(3);
D=coef(4);
y = A*(1-sigmf(tempo, [B C]))+D;
Rs=y;

conc=Rcy1;
coef_ini = [30 10 2 60]; 
coef=[];
OPTIONS = optimset('MaxIter',1000,'TolFun',0.001,'TolX',0.01);
coef = fminsearch(@funcaoerro_sigmoide_R,coef_ini,OPTIONS);
A=coef(1);
B=coef(2);
C=coef(3);
D=coef(4);
y = A*(1-sigmf(tempo, [B C]))+D;
Rcy=y;

figure;
subplot(2,1,1);
plot(Tempo,Rs1,'*');
hold on;
plot(Tempo,Rs,'r');
title('\bf Resistência Solução x Tempo');
xlabel('Tempo (h)');
ylabel('Resistência Solução (\Omega)');

subplot(2,1,2);
plot(Tempo,Rcy1,'*');
hold on;
plot(Tempo,Rcy,'r');
title('\bf Resistência Intracelular x Tempo');
xlabel('Tempo (h)');
ylabel('Resistência Intracelular (\Omega)');


%% ===================================================
% ====== Relação das resistências com células viáveis =====
figure;
subplot(2,1,1);
relacao_viavel_total=fCV./fCT;
plot(Tempo,relacao_viavel_total,'o--');
xlabel('Tempo (h)');
ylabel('Razão Viável/Total');
grid on;

subplot(2,1,2);
relacao_Rcy_Rs=Rcy./Rs;
plot(Tempo,relacao_Rcy_Rs,'o--');
xlabel('Tempo (h)');
ylabel('Razão Rcy/Rs1');
grid on;

                            %%  Curva de concentração de biomassa x Variação Capacitâncias x Razão Resistências
Tempo2=[0 1 2 3 4 5 7 8 9 11 12];
Conc=[0.224709 0.376814 0.786560 0.911495 1.563446 1.968920 2.019142 2.137697 2.053309 2.155604 2.000617];
tempo=Tempo2;
conc=Conc;
coef_ini=[2.0 0.71 2.5];
coef=[];
OPTIONS = optimset('MaxIter',1000,'TolFun',0.001,'TolX',0.01);
coef = fminsearch(@funcaoerro_sigmoide,coef_ini,OPTIONS);
A=coef(1);
B=coef(2);
C=coef(3);

y = A*sigmf(tempo, [B C]);
ConcA=y;

display(A);
display(B);
display(C);

%ConcA = 2.109*sigmf(Tempo2,[0.8561 2.853]);
delta_ConcA=(ConcA-ConcA(1))/ConcA(1)*100;

relacao_Cdl_Cm=fCdl./fCm;

figure;
[ax, h1, h2] = plotyy(Tempo2, ConcA,[Tempo',Tempo'],[relacao_viavel_total',relacao_Cdl_Cm']);
set(h1, 'LineWidth', 2);
set(h2, 'LineWidth', 2);
set(h1, 'LineStyle', '--');
set(h2, 'LineStyle', ':');
set(ax,'TickLength',[0.02 0.035]);
set(ax,'YTick',[0:0.25:2.5]);
grid(ax(1),'on');
xlabel('Tempo (h)');
set(get(ax(1), 'YLabel'), 'String', 'Concentração Biomassa X g/L');
set(get(ax(2), 'YLabel'), 'String', {'\color{black} Células Viáveis/Células Totais','\color{red} Cdl/Cm'});
hold on;
plot(Tempo2, ConcA, 'bs');
hold on;
