global tempo conc;


Tempo = [0 1 2 3 4 5 7 8 9 11 12];
Conc = [0.224709 0.376814 0.786560 0.911495 1.563446 1.968920 2.019142 2.137697 2.053309 2.155604 2.000617];

Amostra=[1 2 3 4 5 6 8 9 10 12 13];
Glicose=[5.42877 3.542964 3.255578 1.540547 1.761507 2.002988 0.792343 0.750369 0.73881 0.767712 0.705367];
Etanol=[0 0 0.158654 0.168898 0.478338 1.393858 4.062599 4.209781 3.953798 3.667891 3.627344];

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

conc=Etanol;
coef_ini = [50 1 2]; 
coef=[];
OPTIONS = optimset('MaxIter',1000,'TolFun',0.001,'TolX',0.01);
coef = fminsearch(@funcaoerro_sigmoide,coef_ini,OPTIONS);
A=coef(1);
B=coef(2);
C=coef(3);
y = A*sigmf(tempo, [B C]);
EtanolA=y;

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

% plot(Amostra,Glicose,Amostra,Etanol);
% hold on;
plot(Tempo, Conc,'rs', Tempo, Etanol, 'bv', Tempo, Glicose, 'ko');
% axis([0 12 0 2.5]);
xlabel('Tempo (h)');
title('\bf Concentração (g/L)');
ylabel({'\color{red} Biomassa [X]','\color{blue}      Etanol [P]','\color{black}    Glicose [S]'});
hold on
plot(Tempo, ConcA,'r-','LineWidth',2);
hold on
plot(Tempo, EtanolA,'b-','LineWidth',2);
hold on;
plot(Tempo, GlicoseA,'k:','LineWidth',3);







