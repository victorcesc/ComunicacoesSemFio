%gaussianas

syms n;

P = [-24.52, -30.54, -44.62, -54.06];
d = [100, 200, 1000, 3000];

E = P(1) - 10*log10(d./d(1));

J_n = sum((P-E).^2);

dJ_n = diff(J_n);
ans = solve(dJ_n);
exp_perda = vpa(ans,3); %mostra na forma decimal 3 casas apos o ponto.