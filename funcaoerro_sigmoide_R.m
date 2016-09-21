function erro = funcao_sigmoide_R(coef);

global tempo conc;

A=coef(1);
B=coef(2);
C=coef(3);
D=coef(4);

y = A*(1-sigmf(tempo, [B C]))+D;
erro1 = (conc-y).^2;
% peso=ones(1,length(erro1));
% peso(1:10)=peso(1:10)*300;
% peso(11:50)=peso(11:50)*100;
% peso(51:80)=peso(51:80)*50;
% peso(100:end)=peso(100:end)*100;
% erro1=erro1.*peso;

erro=sum(erro1);
