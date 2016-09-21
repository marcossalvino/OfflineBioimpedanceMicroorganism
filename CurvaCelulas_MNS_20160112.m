close all;
clear all;

global tempo conc;


                            %% ================================================
                            %  ====  Ler as capacit�ncias e as resist�ncias ===
T = readtable('H:\Experimento\Dados\20160111\Exp20160112Model.dat',...
    'Delimiter',' ','ReadVariableNames',true);
Aa = T{1:end,{'Rs_Ohms','Rcy_Ohms','Cm_uF','Cdl_uF'}};
Rs = Aa(:,1)'; 
Rcy = Aa(:,2)';
Cm = Aa(:,3)';
Cdl = Aa(:,4)';


                            %% =================================================
                            %  ====== Ajustes sigmoidais das concentra��es =====

Tempo = [1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 20 25 26];
tempo=Tempo;
Viaveis = [8 12 17 37 32 34 48 60 32 37 42 38 112 104 175 ...
    131 205 172 175 188];
Nviaveis = [2 5 5 5 2 5 2 2 0 7 13 12 31 41 44 36 37 36 37 67];
Totais = Viaveis + Nviaveis;
Diluicao = [4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4];

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
coef_ini = [50 1 2];
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
set(h1, 'LineWidth', 3);
set(h2, 'LineWidth', 3);
set(h1, 'LineStyle', '--');
set(h2, 'LineStyle', ':');
set(ax,'TickLength',[0.02 0.035]);
set(ax,'YTick',[0:10:300]);
grid(ax(1),'on');
xlabel('Tempo (h)');
set(get(ax(1), 'YLabel'), 'String', 'N� de C�lulas Totais \times10^6/mL');
set(get(ax(2), 'YLabel'), 'String', {'\color{black} N� de C�lulas Vi�veis \times10^6/mL','\color{red} N� de C�lulas N�o-vi�veis \times10^6/mL'});
hold on;
plot(Tempo, CT, 'bs','LineWidth', 1);
hold on;
plot(Tempo, CV, 'ko','LineWidth', 1);
hold on;
plot(Tempo, CN, 'rv','LineWidth', 1);

% subplot(2,1,2);
% figure;
% relacao_viavel_total=fCV./fCT;
% plot(Tempo,relacao_viavel_total,'o-');
% xlabel('Tempo (h)');
% ylabel('Raz�o Vi�vel/Total Ajustada');
% grid on;


                            %% =================================================
                            %  ====== Ajustes sigmoidais das capacit�ncias =====

% Cdl = [10.40422 13.23284 15.79719 17.00992 19.16751 19.30570 22.71374 23.55828 23.39961 26.21187 27.24870];
delta_Cdl=(Cdl-Cdl(1))/Cdl(1)*100;

% Cm = [2.42055 2.98823 3.67132 3.99139 4.68699 4.84339 5.98369 6.28048 6.25150 6.94518 7.42624];
delta_Cm=(Cm-Cm(1))/Cm(1)*100;



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
% subplot(2,1,1);
plot(Tempo,delta_Cdl,'*');
hold on;
plot(Tempo,fCdl,'r','LineWidth', 2);
axis([0 12 0 200]);
title('\bf Varia��o da Capacit�ncia x Tempo');
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
plot(Tempo,fCm,'r','LineWidth', 2);
axis([0 12 0 200]);
% title('\bf Varia��o da Capacit�ncia Membrana x Tempo');
xlabel('Tempo (h)');
ylabel('% Cm');

% subplot(2,1,3);
figure;
% plot(Tempo,Cdl./Cm,'*');
% hold on;
plot(Tempo,fCdl./fCm,'r');
% axis([0 12 0 200]);
title('\bf Varia��o da Cdl/Cm ajustada x Tempo');
xlabel('Tempo (h)');
ylabel('Cdl/Cm');

%% ===================================================
% ====== Rela��o concentra��es x capacit�ncias =====

[P,S] = polyfit(delta_Cdl,CT,1);
CT_estimado=polyval(P,delta_Cdl);

figure;
subplot(2,1,1);
plot(delta_Cdl,CT,'*');
hold on;
plot(delta_Cdl,CT_estimado,'o-r');
% axis([0 12 0 200]);
title('\bf Varia��o da Capacit�ncia Eletrodo x Concentra��o Total');
ylabel('Concentra��o Total');
xlabel('Varia��o da Capacit�ncia Eletrodo');

[P,S] = polyfit(delta_Cm,CV,1);
CV_estimado=polyval(P,delta_Cm);

subplot(2,1,2);
plot(delta_Cm,CV,'*');
hold on;
plot(delta_Cm,CV_estimado,'o-r');
% axis([0 12 0 200]);
title('\bf Varia��o da Capacit�ncia Membrana x Concentra��o Vi�veis');
ylabel('Concentra��o Vi�veis');
xlabel('Varia��o da Capacit�ncia Membrana');


figure;
plot(Tempo, delta_Cdl,'*-b');
hold on;
plot(Tempo,delta_Cm,'o-r');
legend('Cdl','Cm');
xlabel('Tempo (h)');
ylabel('\DeltaCapacit�ncia (%)');

%% ===================================================
% ====== Comportamento das resist�ncias =====
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
title('\bf Resist�ncia Solu��o x Tempo');
xlabel('Tempo (h)');
ylabel('Resist�ncia Solu��o (\Omega)');

subplot(2,1,2);
plot(Tempo,Rcy1,'*');
hold on;
plot(Tempo,Rcy,'r');
title('\bf Resist�ncia Intracelular x Tempo');
xlabel('Tempo (h)');
ylabel('Resist�ncia Intracelular (\Omega)');


%% ===================================================
% ====== Rela��o das resist�ncias com c�lulas vi�veis =====
figure;
subplot(2,1,1);
relacao_viavel_total=fCV./fCT;
plot(Tempo,relacao_viavel_total,'o--');
xlabel('Tempo (h)');
ylabel('Raz�o Vi�vel/Total');
grid on;

subplot(2,1,2);
relacao_Rcy_Rs=Rcy./Rs;
plot(Tempo,relacao_Rcy_Rs,'o--');
xlabel('Tempo (h)');
ylabel('Raz�o Rcy/Rs');
grid on;

                            %%  Curva de concentra��o de biomassa x Varia��o Capacit�ncias x Raz�o Resist�ncias
Tempo2=[1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 20 25 26];
Conc=[0.157919111 0.209889884 0.241792734 0.317433364 0.398734177 0.484666049 0.689410312 0.883914789 ...
    0.900380776 1.372645878 1.382937121 1.580528970 1.634043429 1.687557888 1.720489863 1.854276011 ...
    1.730781105 2.745291757 2.395389524 2.523000926];
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
set(get(ax(1), 'YLabel'), 'String', 'Concentra��o Biomassa X g/L');
set(get(ax(2), 'YLabel'), 'String', {'\color{black} C�lulas Vi�veis/C�lulas Totais','\color{red} Cdl/Cm'});
hold on;
plot(Tempo2, ConcA, 'bs');
hold on;
