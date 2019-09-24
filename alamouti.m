clear all
close all
clc

M = 2;
fd = 100;
Rs = 10e3;

%% Modulação Alamouti
info = randi([0 M-1],4,1);
info_mod = pskmod(info,M);

info_mod_i = info_mod(1:2:end);%indices impar
info_mod_par = info_mod(2:2:end);%indices par

info_tx_1 = zeros(1,length(info));
info_tx_2 = zeros(1,length(info));

info_tx_1(1:2:end) = info_mod_i; %parte impar da info tx
info_tx_1(2:2:end) = conj(info_mod_par);%parte par da info tx


info_tx_2(1:2:end) = info_mod_par; %parte par da info tx
info_tx_2(2:2:end) = conj(info_mod_i);%parte impar da info tx

%% interferencias e ruidos

canal1 = rayleighchan(1/Rs, fd);
canal1.StoreHistory = 1;
canal2 = rayleighchan(1/Rs, fd);
canal2.StoreHistory = 1;

sinal_rx1 = transpose(filter(canal1, info_tx_1));
ganho_canal1 = canal1.PathGains;
sinal_rx2 = transpose(filter(canal2, info_tx_2));
ganho_canal2 = canal2.PathGains;


for SNR = 0:25      
    %estimador
    r0 = (ganho_canal1.*sinal_rx1) + (ganho_canal2.*sinal_rx2);
    r0 = awgn(r0,SNR);
    r1 = ( -ganho_canal1.*conj(sinal_rx2) ) + (ganho_canal2.*(sinal_rx1));
    r1 = awgn(r1,SNR);
    
end


s0 = (conj(ganho_canal1).*r0) + (ganho_canal2.*conj(r1));
s1 = (conj(ganho_canal2).*r0) - (ganho_canal1.*conj(r1));
sinal1_demod = pskdemod(s0,M);
sinal2_demod = pskdemod(s1,M);



