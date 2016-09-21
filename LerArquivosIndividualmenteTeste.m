                            % ROTINA PARA LER ARQUIVOS DE DADOS AMOSTRADOS 
                            % E ENCONTRAR MAGNITUDES E CTES DE DECAIMENTO 
                            % DA CORRENTE

clear all;close all;clc

                            %Parâmetros de entrada
[arquivo caminho]=uigetfile;
arquivo=fullfile(caminho, arquivo);
%arquivo=input('Digite o nome do arquivo: ', 's');
disp(arquivo);
taxa=input('Digite a taxa de amostragem (100000): ');
if isempty(taxa) taxa = 100000; end;
disp(taxa);

                            %Troca as vírgulas por pontos (separador decimal)
                            %Para dar certo tudo precisa estar na mesma pasta
dados=myparsefile([arquivo]);

                            %Vetor de dados amostrados 
tempo=dados(1,2:end);
corrente=dados(2,2:end);
tempo= tempo(:);
corrente= corrente(:);
%disp(tempo);
%disp(corrente);
                            %Corrigir o problema de casas decimais
tempo2 = [1:length(tempo)]/taxa;
tempo=tempo2(:);

%[fitresult, gof] = createFit(tempo, corrente)

%CoefValores= coeffvalues(fitresult);
%disp('    a        b        ');
%aa=sprintf('%7.4f %7.4f',CoefValores(1),  CoefValores(2));
%disp(CoefValores);
%disp(aa);

                            % Plot fit with data.
% figure( 'Name', arquivo );
% h = plot( fitresult, xData, yData*1000 );
% legend( h, 'corrente vs. tempo', 'ExponencialSimples', 'Location', 'NorthEast' );
% 
                            % Label axes and Title
% title(sprintf('\n\n %s \n Equação f(X)= %7.4f.exp(-%7.4f.X) \n \n', arquivo, CoefValores(1),  CoefValores(2)));                         
% xlabel( 'tempo (s)' );
% ylabel( 'corrente (mA)' );
% grid on


