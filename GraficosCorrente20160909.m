                            % ROTINA PARA LER ARQUIVOS DOS PACIENTES E ENCONTRAR MAGNITUDES E CTES DE
                            % DECAIMENTO DA CORRENTE

clear all;close all;clc
dir H:\Experimento\Dados\20160909;
                            %O QUE EU PODERIA USAR
file_list=dir('*.txt');     %Lista os arquivos no diretório corrente (dados coletados)
                            %arquivos(i).name  possibilidade de indexar a estrutura de acordo com o nome para acessar um item
                            %Loop para repetir a conversão de arquivos
for i=1:length(file_list)
                            %Pega o nome de cada arquivo
    filename=file_list(i).name; 
    disp(filename);
                            %Troca as vírgulas por pontos (separador decimal)
                            %Para dar certo tudo precisa estar na mesma pasta
    data=myparsefile(filename);  
                            %Vetor de corrente elétrica 
    tempo=data(1,2:50000);
    corrente=data(2,2:50000);
    tempo= tempo';
    corrente= corrente';
                            %Corrigir o problema de casas decimais
    tempo2 = [1:length(tempo)]/1e5;
    tempo=tempo2;
    

    figure('Name', filename); 
    
                            % Fit: 'untitled fit 1'.
%     [xData, yData] = prepareCurveData(tempo, corrente);
%     h = plot(xData, yData,tempo, Corrente2, '-r');
%    h = plot(tempo, Corrente2, '-r');
    h = plot(tempo, corrente*1000, '-r', 'LineWidth', 4);
    xlabel('tempo (s)');
    ylabel('corrente (mA)');
    grid on
%   legend(h, 'Dados Medidos', 'Filtro 2a.Ordem');
    legend(h, 'Dados Medidos');
%   title(sprintf('Arquivo: %s', filename));
    %title( 'Name', filename );
    

end
%                           %Cria matriz com cada vetor linha do loop anterior transposto em coluna
