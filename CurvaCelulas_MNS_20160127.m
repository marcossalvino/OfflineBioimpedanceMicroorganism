close all;
clear all;

global tempo conc;

                            %% ================================================
                            %  ====  Ler as capacitâncias e as resistências ===
T = readtable('H:\Experimento\Dados\20160127\Exp20160128Model.dat',...
    'Delimiter',' ','ReadVariableNames',true);
Aa = T{1:end,{'Rs_Ohms','Rcy_Ohms','Cm_uF','Cdl_uF'}};
Rs = Aa(:,1); 
Rcy = Aa(:,2);
Cm = Aa(:,3);
Cdl = Aa(:,4);


                            %% =================================================
                            %  ====== Ajustes sigmoidais das concentrações =====

Tempo = [1 2 4 5 6 7 8 9 10 12 13 14 15 16 18 19 20 21 22 23 25 26];
tempo=Tempo;
Viaveis = [53 43 19 21 44 66 70 47 44 91 99 28 29 29 37 20 39 40 47 36 31 25];
Nviaveis= [9 10 8 5 10 20 20 13 20 37 39 14 8 7 13 10 13 21 24 22 16 21]; 

Totais = Viaveis + Nviaveis;
Diluicao = [16 64 128 128 128 128 128 128 128 128 64 64 128 128 128 128 128 128 128 128 128 128];

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


% subplot(2,1,1);
[ax, h1, h2] = plotyy(Tempo,fCT,[Tempo',Tempo'],[fCV',fCN']);
set(h1, 'LineWidth', 3);
set(h2, 'LineWidth', 3);
set(h1, 'LineStyle', '--');
set(h2, 'LineStyle', ':');
set(ax,'TickLength',[0.02 0.035]);
set(ax,'YTick',[0:50:400]);
grid(ax(1),'on');
xlabel('Tempo (h)');
set(get(ax(1), 'YLabel'), 'String', 'Nº de Células Totais \times10^6/mL');
set(get(ax(2), 'YLabel'), 'String', {'\color{darkgreen} Nº de Células Viáveis \times10^6/mL','\color{red} Nº de Células Não-viáveis \times10^6/mL'});
hold on;
plot(Tempo, CT, 'bs','LineWidth', 1);
hold on;
plot(Tempo, CV, 'ko','LineWidth', 1);
hold on;
plot(Tempo, CN, 'rv','LineWidth', 1);

% subplot(2,1,2);
% figure;
% relacao_viavel_total=fCV./fCT;
% Tempo= [1:length(relacao_viavel_total)];
% plot(Tempo,relacao_viavel_total,'o-k','LineWidth', 2);
% xlabel('Tempo (h)');
% ylabel('Razão Viável/Total');
% grid on;


                            %% =================================================
                            %  ====== Ajustes sigmoidais das capacitâncias =====

% Cdl = [10.4002 13.1828 15.7406 16.9424 18.9966 22.3324 23.1034 24.3032 26.4651];
delta_Cdl=(Cdl-Cdl(1))/Cdl(1)*100;

% Cm = [2.4184 2.9572 3.6289 3.9324 4.5116 4.6401 5.7243 6.0592 6.4873];
delta_Cm=(Cm-Cm(1))/Cm(1)*100;

tempo=[1 2 4 5 6 7 8 9 10 12 13 14 15 16 18 19 20 21 22 23 25 26]';
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
plot(Tempo1,fCdl,'r','LineWidth', 2);
% axis([0 12 0 200]);
title('\bf Variação da Capacitância Eletrodo x Tempo');
% xlabel('Tempo (h)');
ylabel('% Cdl');

% delta=delta_Cm(2:end);
% delta_Cm=delta;
% Tempox=tempo(2:end);
% Tempo1=Tempox;
% tempo=Tempox;

conc=delta_Cm;
coef_ini = [150 10 2];
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
plot(Tempo1,fCm,'r','LineWidth', 2);
% axis([0 12 0 200]);
title('\bf Variação da Capacitância Membrana x Tempo');
xlabel('Tempo (h)');
ylabel('% Cm');



                            %% ==================================================
                            %  ====== Relação concentrações x capacitâncias =====

[P,S] = polyfit(delta_Cdl,CT',1);
CT_estimado=polyval(P,delta_Cdl);

figure;
subplot(2,1,1);
plot(delta_Cdl,CT,'*');
hold on;
plot(delta_Cdl,CT_estimado,'o-r','LineWidth', 2);
% axis([0 12 0 200]);
title('\bf Variação da Capacitância x Concentração');
ylabel('Concentração Total');
xlabel('Variação da Capacitância Eletrodo');

[P,S] = polyfit(delta_Cm,CV',1);
CV_estimado=polyval(P,delta_Cm);

subplot(2,1,2);
plot(delta_Cm,CV,'*');
hold on;
plot(delta_Cm,CV_estimado,'o-r','LineWidth', 2);
% axis([0 12 0 200]);
% title('\bf Variação da Capacitância Membrana x Concentração Viáveis');
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
plot(Tempo, DeltaCap, 'o-m');
hold on;

coef_ini = [-0.29 -19.5 9.5 1];
tempo=Tempo;
conc=DeltaCap';
coef=[];
OPTIONS = optimset('MaxIter',1000,'TolFun',0.001,'TolX',0.01);
coef = fminsearch(@funcaoerro_sigmoide_R,coef_ini,OPTIONS);
A=coef(1);
B=coef(2);
C=coef(3);
D=coef(4);
y = A*(1-sigmf(tempo, [B C]))+D;
Ajuste=y;

% Ajuste=0.6585*sigmf(Tempo, [0.4624 -2.589]);

plot(Tempo, Ajuste,'-b');
% legend('\DeltaCdl','Cm');
xlabel('Tempo (h)');
ylabel('\DeltaCm / (\DeltaCm + \DeltaCdl)');


                            %% ===========================================
                            %  ====== Comportamento das resistências =====
                            
Rs1 = Rs;
Rcy1 = Rcy;

tempo=[1 2 4 5 6 7 8 9 10 12 13 14 15 16 18 19 20 21 22 23 25 26]';
% tempo=[1:length(Rs1)]';
Tempo=tempo;

conc=Rs1;
coef_ini = [30 75 2 60]; 
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
plot(Tempo,Rs,'r','LineWidth', 2);
title('\bf Resistência x Tempo');
xlabel('Tempo (h)');
ylabel('Resistência Solução (\Omega)');

subplot(2,1,2);
plot(Tempo,Rcy1,'*');
hold on;
plot(Tempo,Rcy,'r','LineWidth', 2);
% title('\bf Resistência Intracelular x Tempo');
xlabel('Tempo (h)');
ylabel('Resistência Intracelular (\Omega)');


                            %% =========================================================
                            %  ====== Relação das resistências com células viáveis =====

relacao_viavel_total=fCV./fCT;
Tempo= [1 2 4 5 6 7 8 9 10 12 13 14 15 16 18 19 20 21 22 23 25 26];

figure;
subplot(2,1,1);
plot(Tempo,relacao_viavel_total,'o--','LineWidth', 2);
xlabel('Tempo (h)');
ylabel('Razão Viável/Total');
grid on;

% Tempo=[1:length(Rs)];
subplot(2,1,2);
relacao_Rs_Rcy=Rs1./Rcy1;
plot(Tempo,relacao_Rs_Rcy,'o--','LineWidth', 2);
xlabel('Tempo (h)');
ylabel('Razão Rs/Rcy');
grid on;

                            %%  Curva de concentração de biomassa x Variação Capacitâncias x Razão Resistências

Conc=[13.039415457 14.603684265 23.477204899 25.650715241 26.869198312 ...
    27.000926212 25.057939693 26.737470413 26.408150664 27.033858187 ...
    25.584851292 26.078830915 27.231450036 25.947103015 25.749511166 ...
    25.914171040 26.210558814 24.794483894 25.189667593 24.893279819 ...
    24.531028095 22.620973552];
Tempo2=[1 2 4 5 6 7 8 9 10 12 13 14 15 16 18 19 20 21 22 23 25 26];
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
ConcB=ConcA;
ConcA=(ConcB-24.5695)*1e7;

figure;
[ax, h1, h2] = plotyy(Tempo2, ConcA,[Tempo',Tempo'],[relacao_viavel_total',relacao_Cdl_Cm]);

set(h1, 'LineWidth', 2);
set(h2, 'LineWidth', 2);
set(h1, 'LineStyle', '--');
set(h2, 'LineStyle', ':');
set(ax,'TickLength',[0.02 0.035]);
% set(ax,'YTick',[0:0.2:7.5]);
grid(ax(1),'on');
xlabel('Tempo (h)');
set(get(ax(1), 'YLabel'), 'String', '(24.5695 + Concentração Biomassa)/10^7 g/L');
set(get(ax(2), 'YLabel'), 'String', {'\color{black} Células Viáveis/Células Totais','\color{red} Cdl/Cm'});
hold on;
plot(Tempo2, ConcA, 'bs');

figure;
subplot(2,1,1);
plot(Tempo2, Cdl./(Cm + Cdl), 'o-b','LineWidth', 2);
xlabel('Tempo (h)');
ylabel('Cdl / (Cm + Cdl)');


% figure;
subplot(2,1,2);
plot(Tempo2, (Rs1.*Rcy1)./(Rcy1 + Rs1)/max((Rs1.*Rcy1)./(Rcy1 + Rs1)), 'o-b','LineWidth', 2);
xlabel('Tempo (h)');
ylabel('(Rs1*Rcy1)/(Rcy1+Rs1) (\Omega)');
