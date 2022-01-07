%% Weronika Hebda
function main
clear; 
a=6378137; 
e2=0.00669437999013; 

%wsp samolotu 
macierzDane= load('danelotu2.txt'); 
phi=macierzDane(:,1);  
lambda=macierzDane(:,2); 
h=macierzDane(:,3); 
rows = size(macierzDane, 1);

%wsp lotniska 
phiB=50.033333;
lambdaB=8.570556;
hB=111;

%wspolrzedne xyz samolotu
[xs,ys,zs] = geo2xyz(phi,lambda,h,a,e2);
%wspolrzedne xyz lotniska
[xl,yl,zl] = geo2xyz(phiB,lambdaB,hB,a,e2);

%xyz to neu
for i = 1:rows
    [n(i),e(i),u(i)] = xyz2neu(phiB,lambdaB,xs(i),ys(i),zs(i),xl,yl,zl);
end

%odleglosc skosna
s = sqrt(n.^2+e.^2+u.^2);

%odleglosc zenitalna
z = acosd(u./s);

%azymuty
az = atand(e./n);

% geo to xyz
function [x,y,z] = geo2xyz(fi, lam, h, a, e2)
    N = a./sqrt(1-e2.*sind(fi).^2);
    x = (N+h).* cosd(fi) .* cosd(lam);
    y = (N + h) .* cosd(fi) .* sind(lam);
    z = (N.*(1-e2)+h).*sind(fi);
end

%xyz to neu
function [n,e,u] = xyz2neu(fi,lam,xA,yA,zA,xB,yB,zB)
    %macierz obrodu z wykorzystaniem wspolrzednych lotniska
    T = [-sind(fi).*cosd(lam) -sind(lam) cosd(fi).*cosd(lam);
     -sind(fi).*sind(lam) cosd(lam) cosd(fi).*sind(lam);
      cosd(fi) 0 sind(fi)];
    T=T';
    
    %wspl samolotu - wspl lotniska
    D = [xA - xB;yA - yB;zA - zB];

    neu = T*D;
    n = neu(1);
    e = neu(2);
    u = neu(3);
end
end