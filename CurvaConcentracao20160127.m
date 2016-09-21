global tempo conc;


Conc=[13.039415457 14.603684265 23.477204899 25.650715241 26.869198312 ...
    27.000926212 25.057939693 26.737470413 26.408150664 27.033858187 ...
    25.584851292 26.078830915 27.231450036 25.947103015 25.749511166 ...
    25.914171040 26.210558814 24.794483894 25.189667593 24.893279819 ...
    24.531028095 22.620973552];
Tempo=[1 2 4 5 6 7 8 9 10 12 13 14 15 16 18 19 20 21 22 23 25 26];

Amostra=[1 2 4 5 6 7 8 9 10 12 13 14 15 16 18 19 20 21 22 23 25 26];
Glicose=[48.68312 42.75186 16.04103 1.21285 0.59156 0.54765 0.55314 0.55543 ...
    0.60782 0.63636 0.63806 0.51502 0.54076 0.57539 0.54236 0.49376 0.6216 ...
    0.58248 0.48558 0.53448 0.57829 0.53807];
Etanol=[0 4.41684 14.85714 21.59589 21.66093 21.41057 21.36228 20.70925 ...
    21.99588 20.15834 20.97706 20.3392 19.8699 19.65444 18.41996 18.68619 ...
    19.31077 18.78584 18.15036 17.69385 17.67422 17.42405];

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






