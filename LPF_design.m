
% design a low pass filter 
% Fst = Stop-Band frequency
% T sampling time

function HLP = LPF_design(T,Fst)

%Fst = Stop-Band frequency
%Fp = Pass band frequency

Fp = Fst - 1000;

% tolerannces
% in pass band (deltap)
% and stop band (delats)

deltap=0.01; 
deltas=0.001;

% Tolerances expressed in dB

Ap = 20*log10(1+deltap)-20*log10(1-deltap); % (approximate)
Ast = -20*log10(deltas);



SPEC = 'Fp,Fst,Ap,Ast';
LP = fdesign.lowpass(SPEC,Fp,Fst,Ap,Ast,1/T);

HLP = design(LP,'equiripple')

% plot frequency response, the red line is the ideal low pass filter with
% tolerances and transiotion band depicted.
% the blue line is the realized frequency response

fvtool(HLP)

% design a low pass filter 
% Fst = Stop-Band frequency
% T sampling time
