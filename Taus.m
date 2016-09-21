Ct1 = [5729 4293 4172 3737 3408 3192 3000 2793 2761 2645 2710 2624 2467];
Ct2 = [430.1 277 313.6 288.8 288.1 273.9 283.1 255 259 243.9 275.9 261.6 235.7];
Tempo = [0 1 2 3 4 5 7 8 9 10 11 12 13];

% subplot(2,1,1);
% plot(Tempo, Ct1,'--x');
% xlabel('Tempo (h)');
% ylabel('1/ConstanteTempo_1  (1/s)');
% subplot(2,1,2);
% plot(Tempo, Ct2,'--o');
% xlabel('Tempo (h)');
% ylabel('1/ConstanteTempo_2  (1/s)');


subplot(2,1,1);
plot(Tempo, 1./Ct1,'--x');
xlabel('Tempo (h)');
ylabel('\tau_1  (s)');
subplot(2,1,2);
plot(Tempo, 1./Ct2,'--o');
xlabel('Tempo (h)');
ylabel('\tau_2  (s)');