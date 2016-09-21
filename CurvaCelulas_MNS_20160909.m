close all;
clear all;

global tempo conc;


                            %% ================================================
                            % ====  Ler as capacitâncias e as resistências ===
T = readtable('H:\Experimento\Dados\20160909\Exp20160909Model.dat',...
    'Delimiter',' ','ReadVariableNames',true);
Aa = T{1:end,{'Rs_Ohms','Rcy_Ohms','Cm_uF','Cdl_uF'}};
Rs = Aa(:,1)'; 
Rcy = Aa(:,2)';
Cm = Aa(:,3)';
Cdl = Aa(:,4)';


%% ==============================================
% ====== Ajustes sigmoidais das concentrações =====

Tempo = [1 2 3 4 5 6 7 8 9 10 11 12];
tempo=Tempo;
Viaveis = [23 16 44 101 86 86 60 79 75 62 46 41];
Nviaveis = [3 2 15 15 6 7 12 30 47 65 61 80];
Totais = Viaveis + Nviaveis;
Diluicao = [2 2 2 2 4 4 4 4 4 4 4 4];

CV=(Viaveis.*Diluicao.*1000)/(0.004*5*1000000);
CN=(Nviaveis.*Diluicao.*1000)/(0.004*5*1000000);
CT=(Totais.*Diluicao.*1000)/(0.004*5*1000000);

conc=CT;
coef_ini = [500 1 2]; 
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
figure;
[ax, h1, h2] = plotyy(Tempo,fCT,[Tempo',Tempo'],[fCV',fCN']);
set(h1, 'LineWidth', 2);
set(h2, 'LineWidth', 3);
set(h1, 'LineStyle', '--');
set(h2, 'LineStyle', ':');
set(ax,'TickLength',[0.02 0.035]);
set(ax,'YTick',[0:10:300]);
grid(ax(1),'on');
xlabel('Tempo (h)');
set(get(ax(1), 'ylabel'), 'String', 'Nº de Células Totais \times10^6/mL');
set(get(ax(2), 'ylabel'), 'String', {'\color{black} Nº de Células Viáveis \times10^6/mL','\color{red} Nº de Células Não-viáveis \times10^6/mL'});
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
delta_Cdl=(Cdl-Cdl(1))/Cdl(1)*100;

% Cm = [2.42055 2.98823 3.67132 3.99139 4.68699 4.84339 5.98369 6.28048 6.25150 6.94518 7.42624];
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
subplot(3,1,1);
plot(Tempo,delta_Cdl,'s');
hold on;
plot(Tempo,fCdl,'r','LineWidth', 2);
axis([0 12 0 200]);
title('\bf Variação da Capacitância x Tempo');
% xlabel('Tempo (h)');
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

subplot(3,1,2);
plot(Tempo,delta_Cm,'o');
hold on;
plot(Tempo,fCm,'r','LineWidth', 2);
axis([0 12 0 200]);
% title('\bf Variação da Capacitância Membrana x Tempo');
% xlabel('Tempo (h)');
ylabel('% Cm');

Tempo2=Tempo;
Conc=[0.332870227 0.393073994 0.663682206 0.847895441 1.393228363 1.732839354 ...
    1.689616137 1.767829577 1.839868272 1.642276423 1.566121231 1.689616137];

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
delta_ConcA=100.*(ConcA-ConcA(1))/ConcA(1);

subplot(3,1,3);
plot(Tempo2,Conc,'*');
hold on;
plot(Tempo2,ConcA,'r','LineWidth', 2);
% axis([0 12 0 200]);
title('\bf Concentração de Biomassa x Tempo');
xlabel('Tempo (h)');
ylabel('[X] g/L');

figure;
% plot(Tempo,Cdl./Cm,'*');
% hold on;
plot(Tempo,fCdl./fCm,'r');
% axis([0 12 0 200]);
title('\bf Variação da Cdl/Cm x Tempo');
xlabel('Tempo (h)');
ylabel('Cdl/Cm');

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
% Rs1 = [84.75132 90.09705 75.57809 71.57031 72.44695 71.51712 70.73705 71.15287 71.43180 67.65040 71.32168];
% Rcy1 = [59.31785 59.53338 53.40392 53.48145 53.69928 55.05234 52.10445 51.94227 53.21279 50.70061 50.26209];

Rs1 = Rs;
Rcy1 = Rcy;

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
% ====== Relação das resistências e capacitâncias com células viáveis =====
figure;
subplot(3,1,1);
relacao_viavel_total=fCV./fCT;
plot(Tempo,relacao_viavel_total,'o--','LineWidth',2);
title('\bf Razão x Tempo');
% xlabel('Tempo (h)');
ylabel('Viável/Total');
grid on;

subplot(3,1,2);
relacao_Rcy_Rs=Rcy./Rs;
plot(Tempo,relacao_Rcy_Rs,'o--','LineWidth',2);
% xlabel('Tempo (h)');
ylabel('Rcy/Rs');
grid on;

subplot(3,1,3);
plot(Tempo,fCdl./fCm,'o--','LineWidth',2);
ylim([0.6,1.2]);
xlabel('Tempo (h)');
ylabel('Cdl/Cm');
grid on;

% relacao_Rs_Rcy=Rcy1./Rs1;
% plot(Tempo,relacao_Rs_Rcy,'o--');
% xlabel('Tempo (h)');
% ylabel('Razão Rcy_1/Rs_1');
% grid on;


                            %%  Curva de concentração de biomassa x Variação Capacitâncias x Razão Resistências
Tempo2=Tempo;

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

figure;
[ax, h1, h2] = plotyy(Tempo2, ConcA,[Tempo',Tempo'],[relacao_viavel_total',relacao_Cdl_Cm']);
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



figure;
DeltaCap=delta_Cm./(delta_Cm + delta_Cdl);
DeltaCap=DeltaCap([2:end]);
Tempo=Tempo([2:end]);
plot(Tempo, DeltaCap, 'om');
hold on;

coef_ini = [0.5 0.4 -2];
tempo=Tempo;
conc=DeltaCap;
coef=[];
OPTIONS = optimset('MaxIter',1000,'TolFun',0.001,'TolX',0.01);
coef = fminsearch(@funcaoerro_sigmoide,coef_ini,OPTIONS);
A=coef(1);
B=coef(2);
C=coef(3);
% D=coef(4);
y = A*(sigmf(tempo, [B C]));
Ajuste=y;

% Ajuste=0.6585*sigmf(Tempo, [0.4624 -2.589]);

plot(Tempo, Ajuste,'-b','LineWidth', 2);
% legend('\DeltaCdl','Cm');
xlabel('Tempo (h)');
ylabel('\DeltaCm / (\DeltaCm + \DeltaCdl)');


                            %% Correlação CT x %Cm
                            
disp('[R, P]=corrcoef(CT, delta_Cdl)');
[R, P]=corrcoef(CT, delta_Cdl)  

disp('[R, P]=corrcoef(relacao_viavel_total, relacao_Rcy_Rs)');
[R, P]=corrcoef(relacao_viavel_total, relacao_Rcy_Rs)

