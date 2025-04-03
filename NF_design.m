
function HNF = NF_design(T,F_filter)

N=6;
Q = 30;

% tolerannces
% in pass band (deltap)
% and stop band (delats)

deltap=0.01; 
deltas=0.001;

% Tolerances expressed in dB

Ap = 20*log10(1+deltap)-20*log10(1-deltap); % (approximate)
Ast = -20*log10(deltas);

fdesign.notch('N,F0,Q,Ap,Ast',N,F_filter,10,1);

SPEC = 'N,F0,Q,Ap,Ast';
NF = fdesign.notch(SPEC,N,F_filter,Q,Ap,Ast,1/T);

HNF = design(NF)

% plot frequency response, the red line is the ideal low pass filter with
% tolerances and transiotion band depicted.
% the blue line is the realized frequency response

fvtool(HNF)

