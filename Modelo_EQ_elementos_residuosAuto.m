clear all;
close all;
clc;

                 %% defini��o de vari�veis globais que ser�o tamb�m usadas na rotina de ajuste
global t_exp i_exp vd;

                 %% Diret�rio de entrada
                 % leitura do dados
% [arquivo, caminho, filtro]=uigetfile('G:\EQ\AquisicaoParada','Selecione arquivo *.txt','*.txt');
% arquivo=fullfile(caminho, arquivo);
file_list=dir('I:\EQ\ExperimentoNutrientes\*.txt');

                 %% In�cio da leitura dos arquivos *.txt
for ii=1:length(file_list)
    filename=file_list(ii).name; 
        
                 %% Troca as v�rgulas por pontos (separador decimal)
                 % Para dar certo tudo precisa estar na mesma pasta
                 
    dados=myparsefile(filename);

                %% arquivo=input('Digite o nome do arquivo: ', 's');
    % taxa=input('Digite a taxa de amostragem (100000): ');
    % if isempty(taxa) taxa = 100000; end;
    disp(filename);
    taxa = 100000;
    disp(taxa);

                %% Vetor de dados amostrados 
    final=200000; 
    i_exp=dados(2,2:final);
    vd=mean(dados(3,2:final));
    t_exp=(1/taxa)*(0:length(i_exp)-1);

                    %% Gr�fico do Experimento
%     figure('Name', filename);
%     title(sprintf('Arquivo: %s', filename));
%     plot(t_exp*1e3,i_exp*1e3,'g.');
%     hold on;
%     xlabel('Tempo (ms) ');
%     ylabel('i(t) (mA)');
    
                   %% inicializa��o de vari�veis para a fun��o de ajuste (fminsearch) e chamada da rotina
                   % coef_ini = [Rs Rcy Cm   Cdl  t0]; 
                   % coef_ini = [50 50  4e-6 1e-5 1e-8]; 
                   
    coef_ini = [50 50 4e-6 1e-5 1e-8]; 
    coef=[];
    OPTIONS = optimset('MaxIter',1000,'TolFun',0.001,'TolX',0.01);
    coef = fminsearch(@funcaoerro3_residuosEQ,coef_ini,OPTIONS);

                   %% aplica��o dos par�metros ajustados (coef) na equa��o te�rica para gera��o
                   % do gr�fico da fun��o ajustada
    Rs= coef(1);
    Rcy=coef(2);
    Cm= coef(3);
    Cdl=coef(4);
    t0= coef(5);

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


                    %% cria��o do gr�fico de ajuste
%     plot(t_exp*1e3,i_teo*1e3,'b');

                    %% Apresenta��o dos Resultados do Modelo
    disp('[s1   s2]');
    disp([s1    s2]);

    disp('[Rs   Rcy] - Ohms');
    disp(coef(1:2));

    disp('[Cm   Cdl] - uF');
    disp(coef(3:4)*1e6);

   Vetor_Rs(ii) =[Rs];
   Vetor_Rcy(ii)=[Rcy];
   Vetor_Cm(ii) =[Cm]*1e6;
   Vetor_Cdl(ii)=[Cdl]*1e6;
   hold off
   k(ii)=ii;
end

                        %%Grava��o dos Dados da Modelagem
alldata=[k Vetor_Rs Vetor_Rcy Vetor_Cm Vetor_Cdl];
NewName=[filename(1:11) '.txt'];
dados=(alldata);
save (NewName, 'k', 'Vetor_Rs', 'Vetor_Rcy', 'Vetor_Cm', 'Vetor_Cdl', '-ascii');
       
