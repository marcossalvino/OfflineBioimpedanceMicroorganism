global tempo conc;


Tempo = [1 2 3 4 5 6 8 9 10 11 12];
Conc=[0.332870227 0.393073994 0.663682206 0.847895441 1.393228363 1.732839354 ...
    1.767829577 1.839868272 1.642276423 1.566121231 1.689616137];

Amostra=[1 2 3 4 5 6 8 9 10 11 12];
Glicose=[10.980 10.598 9.898 8.646 6.537 4.218 1.132 0.794 0.761 0.739 0.757];
Etanol=[0.000 0.000 0.318 0.774 1.655 2.675 3.882 3.912 3.875 3.816 3.801];

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







