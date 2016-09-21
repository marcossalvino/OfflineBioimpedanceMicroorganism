                            % ROTINA PARA LER ARQUIVOS DOS PACIENTES E ENCONTRAR MAGNITUDES E CTES DE
                            % DECAIMENTO DA CORRENTE

clear all;close all;clc
dir H:\Experimento\Dados\20160317;
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
    tempo=data(1,2:end);
    corrente=data(2,2:end);
    tempo= tempo';
    corrente= corrente';
                            %Corrigir o problema de casas decimais
    tempo2 = [1:length(tempo)]/1e5;
    tempo=tempo2;
    
                            %Filtrar o sinal com passa-baixa de 2a. ordem - Butterworth
%    [b,a]=butter(2,1e4/(1e6/2));
%    Corrente2=1e6*filtfilt(b,a,corrente);
    
                            %Filtrar o sinal com passa-baixa de 4a. ordem - Butterworth
%     [d,c]=butter(4,1e4/(1e6/2));
%     Corrente4=filtfilt(d,c,corrente);
    
    
    %corrente=corrente-mean(corrente(150:200));
                            %Fornece valor máximo de corrente
                            %Acredito que não seja importante a posição pois o pico ocorre no início
%    peak=max(Corrente2); 
    peak=max(corrente);
    disp(peak);
                            %Vetor de identificação dos pacientes
    vetor_ids{i}=[filename];    
                            %Vetor contendo todos os valores de pico de cada paciente
    vetor_picos(i)=[peak]*1000; 
    tempoA(i)=i;
                            %Gera opção de ajuste exponencial com dois termos
                            %Variável pesos criada para avaliar o ajuste da curva, principalmente no início do decaimento
%     pesos=ones(size(tempo));    
%     pesos(1:3)=700000;pesos(4:10)=1500;pesos(11:30)=5;pesos(31:90)=2;pesos(71:200)=1;
%     N=50;
%     
%     figure('Name', filename); 
    
                            % Fit: 'untitled fit 1'.
%     [xData, yData] = prepareCurveData(tempo, corrente);
%     h = plot(xData, yData,tempo, Corrente2, '-r');
%    h = plot(tempo, Corrente2, '-r');
%     h = plot(tempo, corrente, '-r');
%     xlabel('tempo (s)');
%     ylabel('corrente (uA)');
%     grid on
% %    legend(h, 'Dados Medidos', 'Filtro 2a.Ordem');
%     legend(h, 'Dados Medidos');
%     title(sprintf('Arquivo: %s', filename));
%     %title( 'Name', filename );
%     
                            
                            % Set up fittype and options.
%     ft = fittype( 'exp1' );
%     opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
%     opts.Algorithm = 'Levenberg-Marquardt';
%     opts.DiffMinChange = 1e-07;
%     opts.Display = 'Off';
%     opts.MaxFunEvals = 50000;
%     opts.MaxIter = 10000;
%     opts.StartPoint = [3.13825319368777e-05 -12.2948764265629];
%     opts.Weights = pesos;
%     
 
                            % Fit model to data.
%     [fitresult, gof] = fit( xData, yData, ft, opts );
%     CoefValores= coeffvalues(fitresult);
%     disp('    a        b          c        d');
%     disp(CoefValores);

                            % Plot fit with data.
    
%     figure( 'Name', filename );
%     h = plot(xData, yData );
%     legend( h, 'Dados Medidos', 'Ajuste', 'Location', 'NorthEast' );

                            % Label axes
%     xlabel( 'tempo (s)' );
%     ylabel( 'corrente (A)' );
%     grid on
    
    
%     title(sprintf('\n Equação f(X)= %7.4e.exp(-%7.4f.X) \n \n', CoefValores(1),  CoefValores(2)));
%     set(gcf,'Position',[250 116 713 455]);
%     NewName= strsplit(filename,'.txt');
%     saveas(gcf, strjoin(NewName,'.png'));
%     
%     title(disp(CoefValores));

                            %Constantes de cada termo da exponencial 
%     first_cte=curva.a; scnd_cte=curva.c; 
                            %Constantes de cada termo da exponencial
%     first_timecte=curva.b; scnd_timecte=curva.d; 
                            %Constantes de decaimento de cada termo da exponencial
%     y=first_cte*exp(first_timecte.*tempo)+scnd_cte*exp(scnd_timecte.*tempo);
                            % Lembrar de observar esse gráfico após as coletas para verificar a qualidade do ajuste
%     plot(tempo,y,'r');     
      
      
%     pause
                            %Vetor com os coeficientes dos termos de cada
                            %exponencial
%     ParamA(i)= CoefValores(1);
%     ParamB(i)= CoefValores(2);
%     ParamC(i)= CoefValores(3);
%     ParamD(i)= CoefValores(4);
%     ParamM(i)= CoefValores(6);
%     ParamF(i)= CoefValores(5);
%     vetor_cte1(i)=[first_cte];vetor_cte2(i)=[scnd_cte];  
                            %Vetor com as constantes de decaimento (1 e 2os termos) de cada paciente
%     vetor_frstimecte(i)=[first_timecte];vetor_scndtimecte(i)=[scnd_timecte];
end

%                           %Cria matriz com cada vetor linha do loop anterior transposto em coluna
all_data=[vetor_ids;...
    num2cell(vetor_picos)]';

                            %Cria planilha para salvar dados no formato .xls
filename1=[filename(1:end-24) '_1.xls'];
                            %Cria cabeçalho da planilha
col_header={'Arquivo','Pico','a','b'}; 
Equacao={'F(X) = a . exp(-b . X)'};
                            %Escreve cabeçalho na planilha do excel
xlswrite(filename1,Equacao,'Sheet1','A1'); 
                            %Escreve cabeçalho na planilha do excel
xlswrite(filename1,col_header,'Sheet1','A2'); 
                            %Escreve dados na planilha do excel
xlswrite(filename1,all_data,'Sheet1','A3');  


                            % Salva o novo vetor de SubAmostragem
NewName=[filename(1:end-24) 'PicoCorr.dat'];
% tempoA=[1:length(vetor_picos)];
% dados=[tempoA  vetor_picos];
% save (NewName, 'tempoA', 'vetor_picos', '-ascii');

T = table(tempoA', vetor_picos','VariableNames',{'Tempo_h'  'Corrente_mA'});

writetable(T,NewName,'Delimiter',' ');
   


                            % Eu acho que o vetor corrente é na 2a coluna e o tempo é na 1a. Confirmar
                            % com o professor Marcio

                            %Pesos originais: pesos(1:10)=10
                            %Tentativas
                            %1)pesos(1:7)=100; fica legal alguns mas parece que a reta no final desloca
                            %um pouco nos últimos
                            %2)pesos(1:7)=100;pesos(8:10)=10;pesos(11:30)=5; parece que ficou melhor
                            %que a anterior
                            % Tem algo errado... Eu mudo os pesos mas não muda na planilha de excel

