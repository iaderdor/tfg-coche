masa = 1100;
leje = 2.51;
empate = 1.485;
altura = 1.510;
coefaero = 0.286;

maxpotencia = 73000;
torquemax = 125;
maxn = 6000/60*2*pi;
minn = 900/60*2*pi;
MG = Motor('gasolina',torquemax,maxpotencia,maxn,minn);
ME = Motor('electrico',torquemax,maxpotencia,maxn,0);
reltrans = [0.3, 0.342, 0.534, 0.781, 1.032, 1.321];
efi = 0.98;
CC = CajaCambios(reltrans, efi);

radiorueda = 0.32;
densidadrueda = 600;

coche1 = Coche(masa, leje, empate, altura, coefaero, MG, CC, radiorueda, densidadrueda);
coche2 = Coche(masa, leje, empate, altura, coefaero, MG, CC, radiorueda, densidadrueda);


