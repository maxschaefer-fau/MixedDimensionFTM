function [kprim, kadj] = fct_eigenfunctions(string, ftm,x)

kprim = zeros(4,ftm.Mu);
kadj = zeros(4,ftm.Mu); 

for mu = 1:ftm.Mu
    smu = ftm.smu(mu);
    gm = ftm.gm(mu);
    q1 = string.c1*smu - string.a1;
%       Setting Full String
    kprim(:,mu) = [smu/gm*sin(gm*x)
                   -gm*sin(gm*x) 
                   cos(gm*x)
                   -gm^2*cos(gm*x)];
end
end