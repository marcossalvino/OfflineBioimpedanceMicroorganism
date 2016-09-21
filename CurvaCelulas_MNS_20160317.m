close all;
clear all;

global tempo conc;


                            %% ================================================
                            % ====  Ler as capacitâncias e as resistências ===
T = readtable('H:\Experimento\Dados\20160317\Exp20160318Model.dat',...
    'Delimiter',' ','ReadVariableNames',true);
Aa = T{1:end,{'Rs_Ohms','Rcy_Ohms','Cm_uF','Cdl_uF'}};
Rs = Aa(2:end,1)'; 
Rcy = Aa(2:end,2)';
Cm = Aa(2:end,3)';
Cdl = Aa(2:end,4)';


%% ==============================================
% ====== Ajustes sigmoidais das concentrações =====

Tempo = [1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24];
Viaveis = [18 9 13 26 36 20 41 35 21 16 15 20 16 22 23 24 32 31 74 77 ...
    84 94 82 63];
Nviaveis = [2 2 0 4 5 0 5 3 11 24 10 15 17 23 27 20 29 30 43 31 57 46 ...
    45 36];
Diluicao = [4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4];

Tempo=Tempo([5:end]);
Viaveis=Viaveis([5:end]);
Nviaveis=Nviaveis([5:end]);
Diluicao=Diluicao([5:end]);


Totais = Viaveis + Nviaveis;
tempo=Tempo;
CV=(Viaveis.*Diluicao.*1000)/(0.004*5*1000000);
CN=(Nviaveis.*Diluicao.*1000)/(0.004*5*1000000);
CT=(Totais.*Diluicao.*1000)/(0.004*5*1000000);

conc=CT;
coef_ini = [10 0.3 15]; 
coef=[];
OPTIONS = optimset('MaxIter',1000,'TolFun',0.001,'TolX',0.01);
coef = fminsearch(@funcaoerro_sigmoide,coef_ini,OPTIONS);
A=coef(1);
B=coef(2);
C=coef(3);
y = A*sigmf(tempo, [B C]);
fCT=y;

conc=CV;
% coef_ini = [50 1 2]; 
coef=[];
OPTIONS = optimset('MaxIter',1000,'TolFun',0.001,'TolX',0.01);
coef = fminsearch(@funcaoerro_sigmoide,coef_ini,OPTIONS);
A=coef(1);
B=coef(2);
C=coef(3);
y = A*sigmf(tempo, [B C]);
fCV=y;

conc=CN;
coef_ini = [1 0.1 -7];
coef=[];
OPTIONS = optimset('MaxIter',1000,'TolFun',0.001,'TolX',0.01);
coef = fminsearch(@funcaoerro_sigmoide,coef_ini,OPTIONS);
A=coef(1);
B=coef(2);
C=coef(3);
y = A*sigmf(tempo, [B C]);
fCN=y;


% subplot(2,1,1);
figure;
[ax, h1, h2] = plotyy(Tempo,fCT,[Tempo',Tempo'],[fCV',fCN']);
set(h1, 'LineWidth', 2);
set(h2, 'LineWidth', 2);
set(h1, 'LineStyle', '--');
set(h2, 'LineStyle', ':');
% set(ax,'TickLength',[0.02 0.035]);
% set(ax,'YTick',[0:5:40]);
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

% subplot(2,1,2);
figure;
relacao_viavel_total=fCV./fCT;
plot(Tempo,relacao_viavel_total,'o-');
xlabel('Tempo (h)');
ylabel('Razão Viável/Total');
grid on;


%% ==============================================
% ====== Ajustes sigmoidais das capacitâncias =====

% Cdl = [10.40422 13.23284 15.79719 17.00992 19.16751 19.30570 22.71374 23.55828 23.39961 26.21187 27.24870];
% Cdl=Cdl(5:end);
delta_Cdl=(Cdl-Cdl(1))/Cdl(1)*100;

% Cm = [2.42055 2.98823 3.67132 3.99139 4.68699 4.84339 5.98369 6.28048 6.25150 6.94518 7.42624];
% Cm=Cm(5:end);
delta_Cm=(Cm-Cm(1))/Cm(1)*100;

Tempo1 = [1 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24];
Tempo1=Tempo1([2:end]);
tempo=Tempo1;


conc=delta_Cdl;
coef_ini = [50 1 2];
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
axis([5 25 0 100]);
title('\bf Variação da Capacitância x Tempo');
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
axis([5 25 0 100]);
% title('\bf Variação da Capacitância Membrana x Tempo');
xlabel('Tempo (h)');
ylabel('% Cm');

% subplot(2,1,3);
figure;
% plot(Tempo1,Cdl./Cm,'*');
% hold on;
plot(Tempo1,fCdl./fCm,'r');
axis([5 25 0.5 0.8]);
title('\bf Variação da Cdl/Cm x Tempo');
xlabel('Tempo (h)');
ylabel('Cdl/Cm');

%% ===================================================
% ====== Relação concentrações x capacitâncias =====

CT1=CT([2:end]);
CT=CT1;
delta_Cdl1=delta_Cdl([2:end]);
delta_Cdl=delta_Cdl1;

[P,S] = polyfit(delta_Cdl,CT,1);
CT_estimado=polyval(P,delta_Cdl);

figure;
subplot(2,1,1);
plot(delta_Cdl,CT,'*');
hold on;
plot(delta_Cdl,CT_estimado,'o-r');
% axis([0 12 0 200]);
title('\bf Variação da Capacitância x Células');
ylabel('Células Totais');
xlabel('Variação da Capacitância Eletrodo');

CV1=CV([2:end]);
CV=CV1;
delta_Cm1=delta_Cm([2:end]);
delta_Cm=delta_Cm1;

[P,S] = polyfit(delta_Cm,CV,1);
CV_estimado=polyval(P,delta_Cm);

subplot(2,1,2);
plot(delta_Cm,CV,'*');
hold on;
plot(delta_Cm,CV_estimado,'o-r');
% axis([0 12 0 200]);
% title('\bf Variação da Capacitância Membrana x Células Viáveis');
ylabel('Células Viáveis');
xlabel('Variação da Capacitância Membrana');

Tempo1=Tempo1([2:end]);
figure;
plot(Tempo1, delta_Cdl,'*-b');
hold on;
plot(Tempo1,delta_Cm,'o-r');
legend('Cdl','Cm');
xlabel('Tempo (h)');
ylabel('\DeltaCapacitância (%)');

%% ===================================================
% ====== Comportamento das resistências =====
% Rs1 = [84.75132 90.09705 75.57809 71.57031 72.44695 71.51712 70.73705 71.15287 71.43180 67.65040 71.32168];
% Rcy1 = [59.31785 59.53338 53.40392 53.48145 53.69928 55.05234 52.10445 51.94227 53.21279 50.70061 50.26209];

Rs1 = Rs;
Rcy1 = Rcy;

Tempo1 = [1 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24];
Tempo1=Tempo1([2:end]);

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
plot(Tempo1,Rs1,'*');
hold on;
plot(Tempo1,Rs,'r');
title('\bf Resistência x Tempo');
xlabel('Tempo (h)');
ylabel('Resistência Solução (\Omega)');

subplot(2,1,2);
plot(Tempo1,Rcy1,'*');
hold on;
plot(Tempo1,Rcy,'r');
% title('\bf Resistência Intracelular x Tempo');
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
plot(Tempo1,relacao_Rcy_Rs,'o--');
xlabel('Tempo (h)');
ylabel('Razão Rcy/Rs1');
grid on;

                            %%  Curva de concentração de biomassa x Variação Capacitâncias x Razão Resistências
Tempo2=[1 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24];
Conc=[0.2300 0.6688 0.7717 0.7810 0.8942 0.8119 ...
    0.8572 0.9086 0.9354 0.8325 0.9879 0.9832 1.4951 1.5888 1.6958 ...
    1.5085 1.9366 1.8584 1.9942 1.9860 2.7576];

Tempo2=Tempo2([2:end]);
Conc=Conc([2:end]);
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

relacao_Cdl_Cm =fCdl./fCm;
relacao_viavel_total=relacao_viavel_total([1,2:end]);

figure;
[ax, h1, h2] = plotyy(Tempo2, ConcA,[Tempo2',Tempo2'],[relacao_viavel_total',relacao_Cdl_Cm']);
set(h1, 'LineWidth', 2);
set(h2, 'LineWidth', 2);
set(h1, 'LineStyle', '--');
set(h2, 'LineStyle', ':');
set(ax,'TickLength',[0.02 0.035]);
set(ax,'YTick',[0:0.3:3]);
grid(ax(1),'on');
xlabel('Tempo (h)');
set(get(ax(1), 'YLabel'), 'String', 'Concentração Biomassa X g/L');
set(get(ax(2), 'YLabel'), 'String', {'\color{black} Células Viáveis/Células Totais','\color{red} Cdl/Cm'});
hold on;
plot(Tempo2, ConcA, 'bs');
hold on;



