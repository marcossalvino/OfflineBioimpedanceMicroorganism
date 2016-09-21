Tempo = [0 1 2 3 4 5 7 8 9 11 12];
Conc = [0.224709 0.376814 0.786560 0.911495 1.563446 1.968920 2.019142 2.137697 2.053309 2.155604 2.000617];

Corr = [15.27741 14.99590 17.14555 17.52088 17.45504 17.28402 17.97651 17.99250 17.71357 17.95203 18.66508 18.38865 18.34099];
Tempo1 = [0 1 2 3 4 5 7 8 9 10 11 12 13];


subplot(2,1,1);
plot(Tempo, Conc,'x');
xlabel('Tempo (h)');
ylabel('Concentração biomassa [X] (g/L)');
hold on;
ConcA = 2.109*sigmf(Tempo,[0.8561 2.853]);
plot(Tempo, ConcA,'r');
subplot(2,1,2);
plot(Tempo1, Corr,'o');
xlabel('Tempo (h)');
ylabel('Pico de Corrente (mA)');
hold on;
% CorrA = 72.52*sigmf(Tempo1,[.3394 -9.013])-54.23;
CorrB = 18.27*sigmf(Tempo1,[.3715 -4.183]);
% plot(Tempo1, CorrA,'r');
% hold on;
plot(Tempo1, CorrB,'g');
