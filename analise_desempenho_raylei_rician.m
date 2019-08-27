clear all
close all
clc

Rs = 100e3; %taxa de símbolos da entrada do canal(eq a taxa de trasmissao)
num_bits = 1e6;
fd = 300; %doppler
k = 10000; %
M = 2; %ordem da modulaçao / M=2 representa a geraçao de bits(constelacao)
t = [0:1/Rs:num_bits/Rs-(1/Rs)];

%modulação
info = randint(num_bits,1,M);
info_mod = pskmod(info,M);

%transmissao tipo rayleigh e rician
canal_ray = rayleighchan(1/Rs,fd);
canal_ric = ricianchan(1/Rs,fd,k);
canal_ray.StoreHistory = 1;
canal_ric.StoreHistory = 1;

%filtro representa a transmissao
sinal_rec_ray = filter(canal_ray, info_mod);
sinal_rec_ric = filter(canal_ric, info_mod);
%ganhos do canal
ganho_ray = canal_ray.PathGains;
ganho_ric = canal_ric.PathGains;

%Recepcao abaixo

for SNR = 0:30
    sinalRxRayAwgn = awgn(sinal_rec_ray,SNR);
    sinalRxRicAwgn = awgn(sinal_rec_ric,SNR);
    %estabilizando constelaçao
    sinalEqRay = sinalRxRayAwgn./ganho_ray;
    sinalEqRic = sinalRxRicAwgn./ganho_ric;
    %demodulando
    sinalDemodRay = pskdemod(sinalEqRay,M);
    sinalDemodRic = pskdemod(sinalEqRic,M);
    %adicionando os valores para o plot
    [num_ray(SNR+1),taxa_ray(SNR+1)] = symerr(info,sinalDemodRay);
    [num_ric(SNR+1),taxa_ric(SNR+1)] = symerr(info,sinalDemodRic);
end


semilogy([0:30],taxa_ray,'r',[0:30],taxa_ric,'b')