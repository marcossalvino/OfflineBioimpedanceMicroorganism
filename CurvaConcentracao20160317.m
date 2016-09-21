global tempo conc;


Tempo = [1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24];
Conc = [0.2300 0.3128 0.3406 0.4713 0.6688 0.7717 0.7810 0.8942 0.8119 ...
    0.8572 0.9086 0.9354 0.8325 0.9879 0.9832 1.4951 1.5888 1.6958 ...
    1.5085 1.9366 1.8584 1.9942 1.9860 2.7576];

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







