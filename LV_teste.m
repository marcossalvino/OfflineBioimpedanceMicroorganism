s=tf('s'); %Defines s to be the Laplace variable used in transfer functions
K=1; T=1; %Gain and time-constant
H1=tf(K/(T*s+1)); %Creates H as a transfer function
delay=1; %Time-delay
H2=set(H1,'inputdelay',delay);%Defines H2 as H1 but with time-delay
figure(1) %Plot of simulated responses will shown in Figure 1
step(H1,H2) %Simulates with unit step as input, and plots responses.