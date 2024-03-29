clear all
close all
clc

info = randi([0 1],20000,1);
info_mod = pskmod(info, 2);
fd = 100;
Rs = 10e3;

canal1 = rayleighchan(1/Rs, fd);
canal1.StoreHistory = 1;
canal2 = rayleighchan(1/Rs, fd);
canal2.StoreHistory = 1;

sinal_rx1 = filter(canal1, info_mod);
ganho_canal1 = canal1.PathGains;
sinal_rx2 = filter(canal2, info_mod);
ganho_canal2 = canal2.PathGains;




for SNR = 0:25
    sinal_rx1_awgn = awgn(sinal_rx1, SNR);
    sinal_rx2_awgn = awgn(sinal_rx2, SNR);
    sinal_eq_1 = sinal_rx1_awgn./ganho_canal1;
    sinal_eq_2 = sinal_rx2_awgn./ganho_canal2;
    for t = 1:length(info_mod)
        if abs(ganho_canal1(t)) > abs(ganho_canal2(t))
            sinal_demod(t) = pskdemod(sinal_eq_1(t), 2);
            ganho_eq(t) = ganho_canal1(t);
        else
            sinal_demod(t) = pskdemod(sinal_eq_2(t), 2);
            ganho_eq(t) = ganho_canal2(t);
        end
    end
    sinal_demod_1Tx1Rx = pskdemod(sinal_eq_1, 2);
    [num(SNR+1), taxa(SNR+1)] = biterr(info, transpose(sinal_demod));
    [num2(SNR+1), taxa2(SNR+1)] = biterr(info, (sinal_demod_1Tx1Rx));
end
figure(1)
plot(20*log10(abs(ganho_canal1)),'b')
hold on
plot(20*log10(abs(ganho_canal2)),'r')
hold on
plot(20*log10(abs(ganho_eq)),'y')

figure(2)
semilogy([0:25],taxa,'b', [0:25],taxa2,'r') 
    
