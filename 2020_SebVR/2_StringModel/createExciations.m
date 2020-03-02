function [excite_imp, excite_ham] = createExciations(ftm, string, len, t, T)
%% Exciations
f = -0.05/(string.E*string.I);
fe = zeros(1,len);
fe(1) = f;

excite_imp = zeros(ftm.Mu,len);
Fe = zeros(4,len);
Fe(4,:) = fe;

xe = 0.5*string.l;

for mu = 1:ftm.Mu 
   gm = ftm.gm(mu);
   excite_imp(mu,:) = sin(gm*xe)*fe;
end

%% 1+cos*hamming 
Tf = 0.07e-3;
delta = 0.02;
fe = createExcitationFunction(t,Tf);
fe = fe.*-0.05/(string.E*string.I);
% a1 = 0.54;
% a2 = 0.46;
a1 = 0.5;
a2 = 0.5;

excite_ham = getExcitationFunction3(ftm, len, fe, delta,a1,a2,xe);


end