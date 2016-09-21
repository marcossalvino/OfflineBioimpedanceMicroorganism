Tempo = [0 1 2 3 4 5 7  9 11];
Viaveis = [42 156 61 171 130 170 196 167 203];
Nviaveis = [3 39 12 21 21 19 31 47 56];
Totais = Viaveis + Nviaveis;
Diluicao = [1 1 2 2 4 4 4 4 4];

CV=(Viaveis.*Diluicao.*1000)/(0.004*5*1000000);
CN=(Nviaveis.*Diluicao.*1000)/(0.004*5*1000000);
CT=(Totais.*Diluicao.*1000)/(0.004*5*1000000);

% pCT=polyfit(Tempo,CT,3);
% fCT=polyval(pCT,Tempo);
fCT=47.84*sigmf(Tempo,[0.8292 3.463]);

% pCV=polyfit(Tempo,CV,3);
% fCV=polyval(pCV,Tempo);
fCV=38.25*sigmf(Tempo,[0.9995 3.209]);

% pCN=polyfit(Tempo,CN,3);
% fCN=polyval(pCN,Tempo);
fCN=14.27*sigmf(Tempo,[0.3689 7.428]);

%[ax, h1, h2] = plotyy(Tempo, Corr, Tempo, Conc);
[ax, h1, h2] = plotyy(Tempo,fCT,[Tempo',Tempo'],[fCV',fCN']);
set(h1, 'LineWidth', 2);
set(h2, 'LineWidth', 2);
set(h1, 'LineStyle', '--');
set(h2, 'LineStyle', ':');
set(ax,'TickLength',[0.02 0.035]);
set(ax,'YTick',[0:10:300]);
grid(ax(1),'on');
xlabel('Tempo (h)');
set(get(ax(1), 'YLabel'), 'String', 'Nº de Células Totais \times10^6/mL');
set(get(ax(2), 'YLabel'), 'String', {'\color{black} Nº de Células Viáveis \times10^6/mL','\color{red} Nº de Células Não-viáveis \times10^6/mL'});
hold on;
plot(Tempo, CT, 'bs');
hold on;
plot(Tempo, CV, 'ko');
hold on;
plot(Tempo, CN, 'rv');
