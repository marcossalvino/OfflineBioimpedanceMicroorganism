function erro = funcaoerro3_residuosEQ(coef)

global t_exp i_exp vd;

Rs=coef(1);
Rcy=coef(2);
Cm=coef(3);
Cdl=coef(4);
t0=coef(5);



Ip=vd*((Rs+Rcy)/(Rs*Rcy));

A = 1/((Rs+Rcy)*Cm);
B = ((Rs*Cdl/Cm)+Rs+Rcy)*(1/(Rs*Rcy*Cdl));
C = 1/(Rs*Rcy*Cdl*Cm);



BB=[1 A];
AA=[1 B C];
[R,P,K] = residue(BB,AA);
k1=R(1);
k2=R(2);

s1=P(1);
s2=P(2);


i_teo = Ip .*(k1.* exp(s1.*(t_exp-t0)) + k2.* exp(s2.*(t_exp-t0)));


erro1 = (i_teo - i_exp).^2;

peso=ones(1,length(erro1));
% peso(1:2)=peso(1:2)*500;
peso(1:10)=peso(1:10)*400;
peso(11:50)=peso(11:50)*200;
peso(51:80)=peso(51:80)*100;
peso(100:end)=peso(100:end)*50;
erro1=erro1.*peso;

erro=sum(erro1);
