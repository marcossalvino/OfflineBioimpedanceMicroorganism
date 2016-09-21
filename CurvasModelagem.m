clear all;
close all;
clc;

                            %% leitura do dados
dados=load('H:\EQ\AquisicaoParada\Exp20151022.txt');

                            %% In�cio da leitura dos arquivos *.txt
Hora=dados(1,:)-1;
Rs=dados(2,:);
Rcy=dados(3,:);
Cm=dados(4,:);
Cdl=dados(5,:);

                            %% Dados do Experimento anteriormente medidos
Conc = [0.224709 0.376814 0.786560 0.911495 1.563446 1.968920 2.019142 2.137697 2.053309 2.155604 2.000617];
Tempo = [0 1 2 3 4 5 7 8 9 11 12];

                            %% Gr�ficos individuais Rs, Rcy, Cm e Cdl em fun��o da hora
figure; 
subplot(2,2,1);
plot(Hora, Rs,'x-');
title('\bf Rs');
xlabel('Tempo (h)');
ylabel('Resist�ncia (\Omega)');
hold on;

subplot(2,2,2);
plot(Hora, Rcy,'o-');
title('\bf Rcy');
xlabel('Tempo (h)');
ylabel('Resist�ncia (\Omega)');
hold on;

subplot(2,2,3);
plot(Hora, Cm,'*-');
title('\bf Cm');
xlabel('Tempo (h)');
ylabel('Capacit�ncia Intracelular (\muF)');
hold on;

subplot(2,2,4);
plot(Hora, Cdl,'*-');
title('\bf Cdl');
xlabel('Tempo (h)');
ylabel('Capacit�ncia Eletrodo (\muF)');
hold off;

%                             %% Gr�ficos em fun��o da concentra��o
% Cdl1 = [10.4002 13.1828 15.7406 16.9424 18.9966 22.3324 23.1034 22.9367 24.3032 26.4651 26.898];
% figure;
% plot(Conc,Cdl1,'*');
% title('\bf Capacit�ncia Eletrodo x Concentra��o');
% xlabel('Concentra��o (g/L)');
% ylabel('Capacit�ncia Eletrodo (\muF)');
% 
% Cm1 = [2.4184 2.9572 3.6289 3.9324 4.5116 4.6401 5.7243 5.6663 6.0592 6.4873 6.6006];
% figure;
% plot(Conc,Cm1,'*');
% title('\bf Capacit�ncia Membrana x Concentra��o');
% xlabel('Concentra��o (g/L)');
% ylabel('Capacit�ncia Membrana (\muF)');
% 
% Rs1 = [84.6984 89.4841 75.0470 70.9723 70.9353 69.8985 67.565 67.7004 67.7668 65.9863 66.1447];
% figure;
% plot(Conc,Rs1,'*');
% title('\bf Resist�ncia Solu��o x Concentra��o');
% xlabel('Concentra��o (g/L)');
% ylabel('Resist�ncia Solu��o (\Omega)');
% 
% Rcy1 = [59.3379 59.7414 53.6141 53.7486 54.384 55.8565 53.6668 55.0946 53.8888 52.7967 52.9875];
% figure;
% plot(Conc,Rcy1,'*');
% title('\bf Resist�ncia Intracelular x Concentra��o');
% xlabel('Concentra��o (g/L)');
% ylabel('Resist�ncia Intracelular (\Omega)');
% 
% %% Ajustes das Capacit�ncias por Sigm�ide + Gr�ficos
% CdlA=27.91*sigmf(Hora,[0.2454 1.456]);
% CmA=6.801*sigmf(Hora, [0.2696 1.866]);
% 
% figure;
% plot(Hora, Cdl, 'r*', Hora, CdlA, 'r-');
% title('\bf Ajuste da Capacit�ncia Eletrodo');
% xlabel('Tempo');
% ylabel('Capacit�ncia Eletrodo (\muF)');
% 
% figure;
% plot(Hora, Cm, 'r*', Hora, CmA, 'r-');
% title('\bf Ajuste da Capacit�ncia Intracelular');
% xlabel('Tempo');
% ylabel('Capacit�ncia Intracelular (\muF)');
% 
%                             %% Reat�ncias capacitivas
% figure;
% plot(Hora, 1./Cdl, 'r*', Hora, 1./CdlA, 'r-');
% hold on
% 
% plot(Hora, 1./Cm, 'bo', Hora, 1./CmA, 'b:');
% xlabel('Tempo');
% ylabel('Reat�ncia (\Omega)');
% legend('X_Cdl Medido (\Omega)','X_Cdl Ajustado (\Omega)','X_Cm Medido (\Omega)','X_Cm Ajustado (\Omega)');
% 
% 
% 
%                         %% Gr�fico de C�lulas Vi�veis em fun��o das Capacit�ncias
% Tempo1 = [0 1 2 3 4 5 7 9 11];
% Viaveis = [42 156 61 171 130 170 196 167 203];
% Diluicao = [1 1 2 2 4 4 4 4 4];
% CV=(Viaveis.*Diluicao.*1000)/(0.004*5*1000000);
% 
% Cdl2 = [10.4002 13.1828 15.7406 16.9424 18.9966 22.3324 23.1034 24.3032 26.4651];
% figure;
% plot(CV,Cdl2,'*');
% title('\bf Capacit�ncia Eletrodo x C�lulas Vi�veis');
% xlabel('N� de C�lulas Vi�veis \times10^6/mL');
% ylabel('Capacit�ncia Eletrodo (\muF)');
% 
% Cm2 = [2.4184 2.9572 3.6289 3.9324 4.5116 4.6401 5.7243 6.0592 6.4873];
% figure;
% plot(CV,Cm2,'*');
% title('\bf Capacit�ncia Membrana x C�lulas Vi�veis');
% xlabel('N� de C�lulas Vi�veis \times10^6/mL');
% ylabel('Capacit�ncia Membrana (\muF)');
% 
%                         %% Gr�fico da varia��o das Capacit�ncias
% DeltaCdl=100*(Cdl - Cdl(1))./Cdl(1);
% figure;
% %subplot(2,1,1);
% plot(Hora, DeltaCdl,'bx-');
% hold on;
% 
% DeltaCm=100*(Cm - Cm(1))./Cm(1);
% %subplot(2,1,1);
% plot(Hora, DeltaCm,'ro-');
% xlabel('Tempo (h)');
% ylabel('\DeltaCapacit�ncia (%)');
% legend('\DeltaCdl (%)','\DeltaCm (%)');
% 
% 
%                             %% Gr�fico da raz�o entre Rcy e Rs
% Razao=Rcy./Rs;
% figure;
% plot(Hora, Razao,'bx-');
% xlabel('Tempo (h)');
% ylabel('Rcy/Rs');
% title('\bf Raz�o entre Rcy e Rs');
% 
% 
% 
%                             %% Gr�fico da raz�o dos ajustes de C�lulas Vi�veis por C�lulas Totais
% fCT=47.84*sigmf(Tempo1,[0.8292 3.463]);
% fCV=38.25*sigmf(Tempo1,[0.9995 3.209]);
% Razaof=fCV./fCT;
% figure;
% plot(Tempo1, Razaof,'ms-');
% xlabel('Tempo (h)');
% ylabel('CV/CT');
% title('\bf Raz�o dos ajustes entre CV e CT');
% 
% 
% %% Correla��o entre Rcy/Rs e CV/CT
% figure;
% plot(Hora, Razao,'bx-');
% hold on;
% plot(Tempo1, Razaof,'ms-');
% xlabel('Tempo (h)');
% ylabel('Admensional');
% title('\bf Compara��o entre Rcy/Rs  e CV/CT');
% legend('Rcy/Rs','CV/CT');