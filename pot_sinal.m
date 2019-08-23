clear all
close all
clc

d = 1:1:500e3;
Pt_dBm = 47;
Gt_dBi = 0;
Gr_dBi = 0;
L_dB = 0; %perdas
fc = 900e6;

lambda = 3e8/fc;
Pt = 10^(Pt_dBm/10)*1e-3;
Gt = 10^(Gt_dBi/10);
Gr = 10^(Gr_dBi/10);
L = 10^(L_dB/10);

Pr = (Pt*Gt*Gr*(lambda^2))./(((4*pi)^2).*(d.^2)*L);
Pr_dBm = 10*log10(Pr./1e-3);

figure(1)
plot(d,Pr);
title('potencia recebida')

figure(2)
%plot(d,Pr_dBm);
Pr_dBm(1e3);
semilogx(d,Pr_dBm)
title('potencia recebida dbm')

PL_dB = 10*log10(Pt./Pr);

figure(3)
semilogx(d,PL_dB);
title('perda de caminho dbm')

