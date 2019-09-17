clear all
close all
clc

Rs = 100e3; %taxa de símbolos da entrada do canal(eq a taxa de trasmissao)
num_bits = 1e6;
fd = 300; %doppler
k = 10000; %
M = 2; %ordem da modulaçao / M=2 representa a geraçao de bits(constelacao)
t = [0:1/Rs:num_bits/Rs-(1/Rs)];

info = randint(num_bits,1,M);
info_mod = pskmod(info,M);

canal1 = rayleighchan(1/Rs,fd);
canal2 = rayleighchan(1/Rs,fd);


canal1.StoreHistory = 1;
canal2.StoreHistory = 1;


sinal_rec_canal1 = filter(canal1, info_mod);
sinal_rec_canal2 = filter(canal2, info_mod);
%ganhos do canal
ganho_canal1 = canal1.PathGains;
ganho_canal2 = canal2.PathGains;


plot(20*log(abs(ganho_canal1)))
hold on
plot(20*log(abs(ganho_canal2)))
hold on
xlim([0 2e3])
Y = 20*log(abs(max(ganho_canal1,ganho_canal2)));
plot(Y,'g--')

