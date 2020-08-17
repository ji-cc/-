function [mu,ta,is]=mome(Im)
% 3-order color moment for color image
% Input:
%          Im: color image file
% Output:
%          mu: 1st order moment features
%          ta: 2nd order moment features
%          is: 3rd order moment features


warning off

imSize=size(Im);
N=imSize(1)*imSize(2);
% calculate moment features
for i=1:3
    temp=Im(:,:,i);
    temp=temp(:); %_convert 2-dimensional matrix into a single column
    mu(i)=sum(temp)/N;
    ta(i)=sqrt(sum((temp-mu(i)).^2)/N);
    S=sum((temp-mu(i)).^3)/N;
    if S<0
       is(i)=-((-S).^(1/3));
    else
       is(i)=(S).^(1/3);
    end
end
warning on