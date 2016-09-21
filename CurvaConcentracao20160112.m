global tempo conc;


Tempo = [1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 20 25 26];
Conc = [0.157919111 0.209889884 0.241792734 0.317433364 0.398734177 0.484666049 ... 
        0.689410312 0.883914789 0.900380776 1.372645878 1.382937121 1.580528970 ...
        1.634043429 1.687557888 1.720489863 1.854276011 1.730781105 2.745291757 ...
        2.395389524 2.523000926];

Amostra=[1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 20 25 26];
Glicose=[10.57476 10.60094 10.18730 10.14450 9.48022 8.87338 7.68833 6.48475 ...
    5.05780 3.68900 2.65286 1.44447 0.86637 0.62995 0.63087 0.61153 0.62104 ...
    0.57743 0.58957 0.56763];
Etanol=[0 0 0 0 0.40875 0.75730 1.20924 1.86244 2.35930 2.98791 3.29009 3.84900 ...
    3.94680 4.03375 3.89587 3.87918 3.68744 3.47790 2.71585 2.55113];

% ConcA = 2.109*sigmf(Tempo,[0.8561 2.853]);

tempo=Tempo;
conc=Conc;
coef_ini = [60 1 2]; 
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







