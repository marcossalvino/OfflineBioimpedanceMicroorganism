clear all;
close all;
global t_exp i_exp vd;

% leitura do dados


                 %% Parâmetros de entrada
[arquivo, caminho, filtro]=uigetfile('E:\Experimento\Dados\20151214','Selecione arquivo *.tyt','*.tyt');
arquivo=fullfile(caminho, arquivo);
                 %% Troca as vírgulas por pontos (separador decimal)
                 % Para dar certo tudo precisa estar na mesma pasta
                 
dados=myparsefile(arquivo);

                %% arquivo=input('Digite o nome do arquivo: ', 's');
disp(arquivo);
% taxa=input('Digite a taxa de amostragem (100000): ');
% if isempty(taxa) taxa = 100000; end;
taxa = 100000;
disp(taxa);

                %% Vetor de dados amostrados 
                
               final=1000; 

i_exp=dados(2,2:final);
vd=mean(dados(3,2:final));



            
                 %% definição de variáveis globais que serão também usadas na rotina de ajuste

t_exp=(1/taxa)*(0:length(i_exp)-1);

plot(t_exp*1e3,i_exp*1e3,'g.');
hold on;
xlabel('Tempo (ms) ');
ylabel('i(t) (mA)');
                   %% inicialização de variáveis para a função de ajuste (fminsearch) e chamada da rotina
                   % coef_ini = [Rs Rcy Cm Cdl t0]; 
                   % coef_ini = [0.1609 0.0442 45.8224e-6 139.6206e-6 1e-8]; 
                   %[250 500 200e-6 50e-6 1e-8
coef_ini = [50 50 4e-6 1e-5 1e-8]; 
coef=[];
OPTIONS = optimset('MaxIter',1000,'TolFun',0.001,'TolX',0.01);
coef = fminsearch(@funcaoerro3_residuosEQ,coef_ini,OPTIONS);

                   %% aplicação dos parâmetros ajustados (coef) na equação teórica para geração
                   % do gráfico da função ajustada
Rs=coef(1);
Rcy=coef(2);
Cm=coef(3);
Cdl=coef(4);
t0=coef(5);



Ip=vd*((Rs+Rcy)/(Rs*Rcy));

A = 1/((Rs+Rcy)*Cm);
B = ((Rs*Cdl/Cm)+Rs+Rcy)*(1/(Rs*Rcy*Cdl));
C = 1/(Rs*Rcy*Cdl*Cm);

BB=[1 A];
AA=[1 B C];
[R,P,K] = residue(BB,AA);
k1=R(1);
k2=R(2);

s1=P(1);
s2=P(2);



i_teo = Ip .*(k1.* exp(s1.*(t_exp-t0)) + k2.* exp(s2.*(t_exp-t0)));


                   %% criação do gráfico de ajuste

plot(t_exp*1e3,i_teo*1e3,'b');

% axis([0.8*min_x 1.1*max_x 2 18]);


disp('[s1 s2]');
disp([s1 s2]);


disp(['[Rs Rcy] - ','\Omega']);
disp(coef(1:2));

disp('[Cm Cdl] - uF');
disp(coef(3:4)*1e6);

% % Rinf=(1/(1/R1+1/R2+1/R3))+Rb;
% % Rinf_teo=vd/(Ip *(k1* exp(s1*(t_exp(1)-t0)) + k2* exp(s2*(t_exp(1)-t0)) + k3* exp(s3*(t_exp(1)-t0))));
% % Rinf_estrela=vd/i_exp(1);
% % disp('[Rinf Rinf_teo Rinf*]');
% % disp([Rinf Rinf_teo Rinf_estrela]);
