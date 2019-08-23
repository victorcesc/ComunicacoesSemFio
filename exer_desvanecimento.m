%csf - aula 16/08

data = randint(1,5000,2);%dados 0 e 1, 5000 bits(simbolos)
data_mod = pskmod(data,2); %modulaçao digital psk
canal = rayleighchan(1/10000,3); % canal do tipo rayleigh
canal.StoreHistory = 1; %pegar dados transmitidos constantemente
sinal_rec = filter(canal,data_mod);

plot(canal)