global tempo conc;


Tempo = [0 1 2 3 4 5 7 8 9 11 12];
Conc = [0.224709 0.376814 0.786560 0.911495 1.563446 1.968920 2.019142 2.137697 2.053309 2.155604 2.000617];

Amostra=[0 1 2 3 4 5 6 7 8 9 10 11 12 13];
Glicose=[5.42877 3.542964 3.255578 1.540547 1.761507 2.002988 0.47776 1.58469 1.50074 1.02966 1.47762 1.53542 1.41073 1.49571];
Etanol=[0 0 0.158654 0.168898 0.478338 1.393858 0.940471 8.12520 8.41956 4.6948 7.9076 7.33578 7.25469 6.87198];

% ConcA = 2.109*sigmf(Tempo,[0.8561 2.853]);

tempo=Tempo;
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

plot(Amostra,Glicose,Amostra,Etanol);
hold on;
plot(Tempo, Conc,'s');
% axis([0 12 0 2.5]);
xlabel('Tempo (h)');
ylabel('Concentração biomassa [X] (g/L)');
hold on
plot(Tempo, ConcA,'r-','LineWidth',2);
hold on;







