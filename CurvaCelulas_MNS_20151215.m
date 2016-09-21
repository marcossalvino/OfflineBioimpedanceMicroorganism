close all;
clear all;

global tempo conc;

                            %%================================================
                            % ====  Ler as capacitâncias e as resistências ===
T = readtable('E:\Experimento\Dados\20151214\Exp20151215Model.dat',...
    'Delimiter',' ','ReadVariableNames',true);
Aa = T{1:end,{'Rs_Ohms','Rcy_Ohms','Cm_uF','Cdl_uF'}};
Rs = Aa(:,1); 
Rcy = Aa(:,2);
Cm = Aa(:,3);
Cdl = Aa(:,4);


%% ==============================================
% ====== Ajustes sigmoidais das concentrações =====

Tempo = [1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 18 19 20 21 23 24 25 26 27 28 29 30 31 32 33];
tempo=Tempo;
Viaveis = [15 26 56 31 46 29 93 130 107 76 90 75 84 63 118 141 88 88 97 145 136 108 141 66 54 61 37 51 34 94 47];
Nviaveis= [1 0 2 5 4 14 16 24 27 18 15 12 29 24 40 35 27 25 39 39 41 48 66 37 29 29 29 23 45 53 23];

Totais = Viaveis + Nviaveis;
Diluicao = [4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 8 8 8 8 8 8 8 8];

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

% Cdl = [10.4002 13.1828 15.7406 16.9424 18.9966 22.3324 23.1034 24.3032 26.4651];
delta_Cdl=(Cdl-Cdl(1))/Cdl(1)*100;

% Cm = [2.4184 2.9572 3.6289 3.9324 4.5116 4.6401 5.7243 6.0592 6.4873];
delta_Cm=(Cm-Cm(1))/Cm(1)*100;

tempo=[1:length(Cm)]';
Tempo1=tempo;

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
plot(Tempo1,delta_Cdl,'*');
hold on;
plot(Tempo1,fCdl,'r');
% axis([0 12 0 200]);
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
plot(Tempo1,delta_Cm,'*');
hold on;
plot(Tempo1,fCm,'r');
% axis([0 12 0 200]);
title('\bf Variação da Capacitância Membrana x Tempo');
xlabel('Tempo (h)');
ylabel('% Cm');



%% ===================================================
% ====== Relação concentrações x capacitâncias =====

[P,S] = polyfit(delta_Cdl,CT',1);
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

[P,S] = polyfit(delta_Cm,CV',1);
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


figure;
DeltaCap=delta_Cm./(delta_Cm + delta_Cdl);
plot(Tempo, delta_Cm./(delta_Cm + delta_Cdl), 'o-m');
hold on;

% coef_ini = [.6 .4 -2];
% tempo=Tempo;
% conc=DeltaCap';
% coef=[];
% OPTIONS = optimset('MaxIter',1000,'TolFun',0.001,'TolX',0.01);
% coef = fminsearch(@funcaoerro_sigmoide,coef_ini,OPTIONS);
% A=coef(1);
% B=coef(2);
% C=coef(3);
% y = A*sigmf(tempo, [B C]);
% Ajuste=y;
% AA=A; BB=B; CC=C;
% display(AA); display(BB); display(CC);

Ajuste=0.6585*sigmf(Tempo, [0.4624 -2.589]);

plot(Tempo, Ajuste,'-b');
% legend('\DeltaCdl','Cm');
xlabel('Tempo (h)');
ylabel('\DeltaCm / (\DeltaCm + \DeltaCdl)');


%% ===================================================
% ====== Comportamento das resistências =====
Rs1 = Rs;
Rcy1 = Rcy;

tempo=[1:length(Rs)]';
Tempo=tempo;

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
Tempo= [1:length(relacao_viavel_total)];
figure;
subplot(2,1,1);
relacao_viavel_total=fCV./fCT;
plot(Tempo,relacao_viavel_total,'o--');
xlabel('Tempo (h)');
ylabel('Razão Viável/Total');
grid on;

Tempo=[1:length(Rs)];
subplot(2,1,2);
relacao_Rcy_Rs=Rcy1./Rs1;
plot(Tempo,relacao_Rcy_Rs,'o--');
xlabel('Tempo (h)');
ylabel('Razão Rcy/Rs1');
grid on;

                            %%  Curva de concentração de biomassa x Variação Capacitâncias x Razão Resistências

Conc=[0.448646702 0.447103015 0.871874035 1.025625193 1.409694350 1.849747865 1.863332304 1.913553566 1.980446640 ...
    2.112586189 2.786868375 2.576927035 2.837089637 2.821858598 2.845322630 3.118246372 2.987341772 3.172584131 ...
    3.053205722 3.282906247 3.233919934 3.259442215 3.448801070 3.454152516 3.309663476 3.904497273 ...
    3.026036843 3.594936709 3.447977771 3.491612638 3.542245549];
Tempo2=[1:length(Conc)];
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
[ax, h1, h2] = plotyy(Tempo2, ConcA,[Tempo',Tempo'],[relacao_viavel_total',relacao_Cdl_Cm]);
set(h1, 'LineWidth', 2);
set(h2, 'LineWidth', 2);
set(h1, 'LineStyle', '--');
set(h2, 'LineStyle', ':');
set(ax,'TickLength',[0.02 0.035]);
set(ax,'YTick',[0:0.25:4.25]);
grid(ax(1),'on');
xlabel('Tempo (h)');
set(get(ax(1), 'YLabel'), 'String', 'Concentração Biomassa X g/L');
set(get(ax(2), 'YLabel'), 'String', {'\color{black} Células Viáveis/Células Totais','\color{red} Cdl/Cm'});
hold on;
plot(Tempo2, ConcA, 'bs');
hold on;
