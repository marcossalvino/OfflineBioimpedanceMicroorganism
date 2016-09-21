close all;
clear all;

global tempo conc;



% Tempo=[1:length(Conc)];

                            %% ===========================================
                            %  ====== Carregando Tabelas =================    
TT = readtable('H:\Experimento\Dados\20151022\ExpPicoCorr.dat',...
    'Delimiter',' ','ReadVariableNames',true);
AA = TT{1:end,{'Tempo_h','Corrente_mA'}};
tempoA= AA(:,1);
Corrente= AA(:,2);

                            %% ================================================
                            % ====  Ler as capacitâncias e as resistências ===
T = readtable('H:\Experimento\Dados\20151022\Exp20151022Model.dat',...
    'Delimiter',' ','ReadVariableNames',true);
Aa = T{1:end,{'Rs_Ohms','Rcy_Ohms','Cm_uF','Cdl_uF'}};
Rs = Aa(:,1)'; 
Rcy = Aa(:,2)';
Cm = Aa(:,3)';
Cdl = Aa(:,4)';


                             %% ==================================================
                             
tempoA=[1 2 3 4 5 6 8 9 10 12 13];
Conc=[0.224709 0.376814 0.786560 0.911495 1.563446 1.968920 2.019142 ...
    2.137697 2.053309 2.155604 2.000617];
Corrente=[15.27741 14.99590 17.14555 17.52088 17.45504 17.28402 ...
    17.97651 17.99250 17.71357 18.66508 18.38865];
Etoh=[0 0 0.158654 0.168898 0.478338 1.393858 4.062599 4.209781 ...
    3.953798 3.667891 3.627344];


                             %% ===================================================
                              % ====== Comportamento das resistências =====
% Rs1 = [84.75132 90.09705 75.57809 71.57031 72.44695 71.51712 70.73705 71.15287 71.43180 67.65040 71.32168];
% Rcy1 = [59.31785 59.53338 53.40392 53.48145 53.69928 55.05234 52.10445 51.94227 53.21279 50.70061 50.26209];


Rs1 = Rs;
Rcy1 = Rcy;
tempo=tempoA([1:end-1]);
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




Rs1 = Rs;
Rcy1 = Rcy;
delta_Rs1=100.*(Rs1-(Rs1(1)+eps))/(Rs1(1)+eps);
delta_Rcy1=100.*(Rcy1-(Rcy1(1)+eps))/(Rcy1(1)+eps);



conc=delta_Rs1;
coef_ini = [30 1 3 0]; 
% coef_ini = [18.87 12.93 2.928 -18.87];
coef=[];
OPTIONS = optimset('MaxIter',1000,'TolFun',0.001,'TolX',0.01);
coef = fminsearch(@funcaoerro_sigmoide_RR,coef_ini,OPTIONS);
A=coef(1);
B=coef(2);
C=coef(3);
D=coef(4);
y = A*(sigmf(tempo, [B C]))+D;
delta_Rs=y;



conc=delta_Rcy1;
coef_ini = [11.01 15.81 2.846 -11.01]; 
% coef_ini = [18.87 12.93 2.928 -18.87];
coef=[];
OPTIONS = optimset('MaxIter',1000,'TolFun',0.001,'TolX',0.01);
coef = fminsearch(@funcaoerro_sigmoide_RR,coef_ini,OPTIONS);
A=coef(1);
B=coef(2);
C=coef(3);
D=coef(4);
y = A*(sigmf(tempo, [B C]))+D;
delta_Rcy=y;


                            %% ============================================
                            %  ============= Ajuste de Curvas =============
                            %  ============= Concentração
    
% tempoA=[1 2 3 4 5 6 8 9 10 12 13];
% Conc=[0.224709 0.376814 0.786560 0.911495 1.563446 1.968920 2.019142 ...
%     2.137697 2.053309 2.155604 2.000617];
% Corrente=[15.27741 14.99590 17.14555 17.52088 17.45504 17.28402 ...
%     17.97651 17.99250 17.71357 18.66508 18.38865];
% Etoh=[0 0 0.158654 0.168898 0.478338 1.393858 4.062599 4.209781 ...
%     3.953798 3.667891 3.627344];

                           
tempo=tempoA;
Tempo=tempo;
% tempo=Tempo;

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
coef_ini = [-0.8675 0.4 9 4.605];
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
CorrA=y;                            
                            
conc=Etoh;
coef=[];
OPTIONS = optimset('MaxIter',1000,'TolFun',0.001,'TolX',0.01);
coef = fminsearch(@funcaoerro_sigmoide,coef_ini,OPTIONS);
A=coef(1);
B=coef(2);
C=coef(3);
y = A*(sigmf(tempo, [B C]));
EtohA=y;


                            %% ============================================
                            %  ================ Graficos ==================
figure;
% subplot(2,1,1);
Tempo=Tempo([1:end-1]);
Conc=Conc([1:end-1]);
ConcA=ConcA([1:end-1]);
Etoh=Etoh([1:end-1]);
EtohA=EtohA([1:end-1]);
Corrente=Corrente([1:end-1]);
CorrA=CorrA([1:end-1]);


plot(Tempo, Etoh,'s','LineWidth', 2);
hold on;
plot(Tempo, Conc,'o','LineWidth', 2);
legend('[P] - Etanol','[X] - Biomassa');
ylim([0 4.5]);
xlabel('Tempo (h)');
ylabel('Concentração (g/L)');
% title('\bfConcentração biomassa [X] e Produto [P]')
grid;
hold on;
% ConcA = 2.109*sigmf(Tempo,[0.8561 2.853]);
plot(Tempo, ConcA,'r','LineWidth', 2);
hold on;
grid on;
plot(Tempo, EtohA,'r:','LineWidth', 2);

figure;
% subplot(2,1,2);
tempo=Tempo;

plot(tempo, Corrente,'o','LineWidth', 2);
xlabel('Tempo (h)');
ylabel('Pico de Corrente (mA)');
% title('\bfPico de Corrente');
grid;
hold on;
% CorrA = 72.52*sigmf(Tempo1,[.3394 -9.013])-54.23;
% CorrB = 18.27*sigmf(Tempo1,[.3715 -4.183]);
plot(tempo, CorrA,'r','LineWidth', 2);
% hold on;
% plot(Tempo1, CorrB,'g');

figure;
% subplot(3,1,3);
plot(tempo, Etoh,'o','LineWidth', 2);
xlabel('Tempo (h)');
ylabel('(g/L)');
title('\bfConcentração do Produto [P]');
grid;
hold on;
% CorrA = 72.52*sigmf(Tempo1,[.3394 -9.013])-54.23;
% CorrB = 18.27*sigmf(Tempo1,[.3715 -4.183]);
plot(tempo, EtohA,'r','LineWidth', 2);
% hold on;
% plot(Tempo1, CorrB,'g');

figure;
[ax, h1, h2] = plotyy(tempo,ConcA,[tempo',tempo'],[delta_Rcy',delta_Rs']);
set(h1, 'LineWidth', 2);
set(h2, 'LineWidth', 3);
set(h1, 'LineStyle', '-');
set(h2, 'LineStyle', ':');
% set(ax,'TickLength',[0.02 0.035]);
% set(ax,'YTick',[-17:3.5]);
grid(ax(1),'on');
xlabel('Tempo (h)');
set(get(ax(1), 'ylabel'), 'String', 'Biomassa [X]  (g/L)');
set(get(ax(2), 'ylabel'), 'String', {'\color{black} %Variação Rcy','\color{red} %Variação Rs'});


                            %% ============================================


disp('[CorrCruz Lags]=xcorr(Etoh, razao)')
razao=Rcy./Rs;
[CorrCruz Lags]=xcorr(Etoh, razao)
max(CorrCruz)


disp('[CorrCruz Lags]=xcorr(Etoh, razao,"coeff")')
razao=Rcy./Rs;
[CorrCruz1 Lags]=xcorr(Etoh, razao,'coeff')
max(CorrCruz)



                        %% ================================================
                        
Amostra=[1 2 3 4 5 6 8 9 10 12 13];
Glicose=[5.42877 3.542964 3.255578 1.540547 1.761507 2.002988 0.792343 0.750369 0.73881 0.767712];

conc=Glicose;
coef_ini = [50 1 2 1]; 
coef=[];
OPTIONS = optimset('MaxIter',1000,'TolFun',0.001,'TolX',0.01);
coef = fminsearch(@funcaoerro_sigmoide_R,coef_ini,OPTIONS);
A=coef(1);
B=coef(2);
C=coef(3);
D=coef(4);
y = A*(1-sigmf(tempo, [B C]))+D;
GlicoseA=y;



disp('[R P]=corrcoef(delta_Rs, Glicose)')
[R P]=corrcoef(delta_Rs, Glicose)



disp('[R P]=corrcoef(delta_Rcy, Glicose)')
[R P]=corrcoef(delta_Rcy, Glicose)




disp('[R P]=corrcoef(delta_Rs1, GlicoseA)')
[R P]=corrcoef(delta_Rs1, GlicoseA)



disp('[R P]=corrcoef(delta_Rcy1, GlicoseA)')
[R P]=corrcoef(delta_Rcy1, GlicoseA)


