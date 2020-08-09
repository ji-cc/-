function [mu ta]=wavelet4Texture(Im)
% 4-level 2-D wavelet decomposition
% Input:
%          Im: image file
% Output:
%             mu: means of each subwavelet coefficient after decompostion
%             ta: standard error

warning off
origSize = size(Im);
if length(origSize)==3 Im=rgb2gray(Im);end
Im=double(Im);
%
nbcol = 256;%size(colormap,1);
% Perform 4-level decomposition of Im using db1
[cA1,cH1,cV1,cD1]=dwt2(Im,'db1');
[cA2,cH2,cV2,cD2]=dwt2(cA1,'db1');
[cA3,cH3,cV3,cD3]=dwt2(cA2,'db1');
[cA4,cH4,cV4,cD4]=dwt2(cA3,'db1');

% construct cell
cA={cH1,cV1,cD1,cH2,cV2,cD2,cH3,cV3,cD3,cA4,cH4,cV4,cD4};
% Images coding and calculate means and standard error 
for i=1:13
    cod_cA{i}=wcodemat(cA{i},nbcol);
    [g,h]=size(cod_cA{i});
    mu(i)=sum(sum(abs(cod_cA{i})))/(g*h);
      ta(i)=sqrt(sum(sum((abs(cod_cA{i})-mu(i)).^2))/(g*h));
end
WavletTex=[mu ta];
WavletTex=WavletTex/sum(WavletTex);

