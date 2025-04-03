close all;
clear all;
clc;
%% importazione traccia audio
load audio
%% punto 1 
% data la freq. di campionamento ricavo il tempo di campionamento per
% creare la scala dei tempi e plottarlo
Tc = 1/F;
%creo vettore dei tempi supponendo che il segnale sia definito a partire da
%t=0;
t = 0:Tc:length(x_t)*Tc-Tc;

%definisco il numero di campioni del segnale nel tempo
N = length(x_t);
%definisco passo di campionamento della trasformata
fc = 1/(N*Tc);
Xf = Tc*fft(x_t);
Xf = fftshift(Xf);
%definisco scala dei "tempi" nel mondo delle frequenze (asse delle
%frequenze per fare il grafico)
f = (-N/2)*fc:fc:(N/2)*fc-fc;

%% plot del segnale e TDF
figure('name','Segnale e TDF');
hold on
%plotto segnale nel tempo
subplot(1,2,1);
plot(t,x_t,'-b');
xlabel("time");
ylabel("xt");

%plotto TDF
subplot(1,2,2);
plot(f,abs(Xf),'-b');
xlabel("frequency");
ylabel("Xf");
%facendo un calcolo della TDF teorica dovrei trovare la TDF del segnale x_t
%traslata a dx e sx di una quantità pari ad Fm e dal grafico questo si vede
%chiaramente e deduco che Fm = 40 000 Hz
%% punto 2 (demodulazione e ascolto)
%definisco la frequenza di modulazione 
fm = 40000;
%definisco la banda del segnale che ricavo osservando il grafico
B = 20000;
%moltplico il segnale modulato come da teoria
sig_da_filtrare = x_t.*(2*cos(2*pi*fm*t));
%calcolo TDF del segnale da filtrare
Xf_da_filtrare = fftshift(Tc*fft(sig_da_filtrare));

rect = @(t) 1*(abs(t)<0.5);
%TDF filtrato
Xf_filtrato = Xf_da_filtrare.*rect(f/(2*B));
%antitrasformo il segnale Xf_filtrato per avere il segnale demodualto da
%ascoltare
xt_da_ascoltare = ifft(ifftshift(Xf_filtrato))/Tc;
player = audioplayer(xt_da_ascoltare,F);
play(player);
figure('name','TDF segnale demodulato');
plot(f,abs(Xf_filtrato),'-b');
xlabel("frequency")
ylabel("Xf sig demodulato")
%% punto 4 (filtraggio degli artefatti sonori) rumori a 8300 hz e rumori a 5250 hz
HNF = NF_design(Tc,40000-8300);
x_t = filter(HNF,x_t);
HNF = NF_design(Tc,40000-5250);
x_t = filter(HNF,x_t);
%% punto 5 (demodulazione e ascolto) riutilizzo le stesse variabili del punto 2
%definisco la frequenza di modulazione per ordinare il codice
fm = 40000;
%definisco la banda del segnale che ricavo osservando il grafico
B = 20000;
%moltplico il segnale modulato come da teoria
sig_da_filtrare = x_t.*(2*cos(2*pi*fm*t));
%calcolo TDF del segnale da filtrare
Xf_da_filtrare = fftshift(Tc*fft(sig_da_filtrare));

rect = @(t) 1*(abs(t)<0.5);
%TDF filtrato
Xf_filtrato = Xf_da_filtrare.*rect(f/(2*B));
%antitrasformo il segnale Xf_filtrato per avere il segnale demodualto da
%ascoltare
xt_da_ascoltare = ifft(ifftshift(Xf_filtrato))/Tc;
player = audioplayer(xt_da_ascoltare,F);
play(player);
figure('name','TDF segnale demodulato filtrato con notch');
plot(f,abs(Xf_filtrato),'-b');
xlabel("frequency")
ylabel("Xf sig demodulato e filtrato")
%% punto 6 (campionamento)

%prendo 1 campione ogni 6 del segnale filtrato (come scritto nel pdf)
%in quanto la freq. di campionamento è 1/6 rispetto a quella del segnale
%originario
xt_camp = xt_da_ascoltare(1:6:end);
%definisco il passo di campionamento per il segnale campionato e freq.
%campionamento
Tc_camp = Tc * 6;
F_camp = F/6;
%definisco il numero di campioni del segnale nel tempo
N_camp = length(xt_camp);
%definisco passo di campionamento della trasformata
fc_camp = 1/(N_camp*Tc_camp);
Xf_camp = Tc_camp*fft(xt_camp);
Xf_camp = fftshift(Xf_camp);
%definisco scala dei "tempi" nel mondo delle frequenze (asse delle
%frequenze per fare il grafico)
f_camp = (-N_camp/2)*fc_camp:fc_camp:(N_camp/2)*fc_camp-fc_camp;
figure('name','TDF del segnale campionato')
plot(f_camp,abs(Xf_camp),'-b');
xlabel('frequency')
ylabel('Xf sig campionato')

%ascolto
player = audioplayer(xt_camp,F_camp);
play(player);
% Commento: vedendo la TDF del segnale xt_da_ascoltare deduco che la banda
% sia intorno ai 20 kHz quindi i disturbi che appaiono nel segnale
% campionato potrebbero essere dovuti al fenomeno di aliasing in quanto la
% frequenza di campionamento è al di sotto dei 40 kHz previsti dal teorema
% del campionamento. Detto questo come nuova procedura di campionamento
% propongo (prima di campionare) di filtrare il segnale con un
% filtro anti-aliasing centrato alla frequenza opportuna così da eliminare
% le code della TDF e togliere la sovrapposizione durante il campionamento

%% punto 7 (filtraggio anti-alising)
LPF = LPF_design(Tc,14700);
xt_antialiasing = filter(LPF,xt_da_ascoltare);
%% punto 8 (campionamente e ascolto dopo filtro antialiasing)

xt_camp_antialiasing = xt_antialiasing(1:6:end);
Xf_camp_antialiasing = fftshift(Tc_camp*fft(xt_camp_antialiasing));
figure('name','TDF segnale campionato con filtro antialiasing e non');
hold on;
plot(f_camp,abs(Xf_camp_antialiasing),'-b');
plot(f_camp,abs(Xf_camp),'-r');
xlabel('frequency')
ylabel('TDF segnale campionato')
legend('sig camp antialiasing','sig camp')

%ascolto
player = audioplayer(xt_camp_antialiasing,F_camp);
play(player);
