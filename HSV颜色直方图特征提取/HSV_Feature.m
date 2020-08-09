function [Fea]=HSV_Feature(Im)
% 3-order color moment for color image
% Input:
%          Im: color image file
% Output:
%          mu: 1st order moment features
%          ta: 2nd order moment features
%          is: 3rd order moment features
%功能：计算HSV颜色直方图特征

warning off
Fea=zeros(1,18);
[M N dim]=size(Im);
Thsv=rgb2hsv(Im);
sumpix=1;

[h,s,v] = rgb2hsv(Im);
H = h; S = s; V = v;

%将hsv空间非等间隔量化：
%  h量化成8级；
%  s量化成3级；
%  v量化成3级；
for i = 1:M
    for j = 1:N
        if h(i,j)<=20||h(i,j)>316
            H(i,j) = 0;
        end
        if h(i,j)<=40&&h(i,j)>21
            H(i,j) = 1;
        end
        if h(i,j)<=75&&h(i,j)>41
            H(i,j) = 2;
        end
        if h(i,j)<=155&&h(i,j)>76
            H(i,j) = 3;
        end
        if h(i,j)<=190&&h(i,j)>156
            H(i,j) = 4;
        end
        if h(i,j)<=270&&h(i,j)>191
            H(i,j) = 5;
        end
        if h(i,j)<=295&&h(i,j)>271
            H(i,j) = 6;
        end
        if h(i,j)<=296&&h(i,j)>351
            H(i,j) = 7;
        end
    end
end
for i = 1:M
    for j = 1:N
        if s(i,j)<=0.2&&s(i,j)>0
            S(i,j) = 0;
        end
        if s(i,j)<=0.7&&s(i,j)>0.2
            S(i,j) = 1;
        end
        if s(i,j)<=0.1&&s(i,j)>0.7
            S(i,j) = 2;

        end
    end
end
for i = 1:M
    for j = 1:N
        if v(i,j)<=0.2&&v(i,j)>0
            V(i,j) = 0;
        end
        if v(i,j)<=0.7&&v(i,j)>0.2
            V(i,j) = 1;
        end
        if v(i,j)<=1&&v(i,j)>0.7
            V(i,j) = 2;
        end
    end
end

%将三个颜色分量合成为一维特征向量：L = H*Qs*Qv+S*Qv+v；Qs,Qv分别是S和V的量化级数, L取值范围[0,255]
%取Qs = 4; Qv = 4
for  i = 1:M
    for j = 1:N
        L(i,j) = H(i,j)*16+S(i,j)*4+V(i,j);
    end
end
%计算L的直方图
for i = 0:255
    Hist(i+1) = size(find(L==i),1);
end
% Hist = Hist/sum(Hist);
T=Hist;

% 循环读入图像
A=dir('G:\MATLAB\Demo\智能视频图像处理实验\实验一\HSV颜色直方图特征提取\*.jpg');
for k=1:size(A)
   B=strcat('G:\MATLAB\Demo\智能视频图像处理实验\实验一\HSV颜色直方图特征提取\',A(k).name);
   Image=imread(B);

end
[M,N,dim] = size(Im);
%M = 256;
%N = 256;

% 计算每一幅图像的颜色直方图

[h,s,v] = rgb2hsv(Im);
H = h; S = s; V = v;
h = h*360;

%将hsv空间非等间隔量化：
%  h量化成8级；
%  s量化成3级；
%  v量化成3级；
for i = 1:M
    for j = 1:N
        if h(i,j)<=20||h(i,j)>316
            H(i,j) = 0;
        end
        if h(i,j)<=40&&h(i,j)>21
            H(i,j) = 1;
        end
        if h(i,j)<=75&&h(i,j)>41
            H(i,j) = 2;
        end
        if h(i,j)<=155&&h(i,j)>76
            H(i,j) = 3;
        end
        if h(i,j)<=190&&h(i,j)>156
            H(i,j) = 4;
        end
        if h(i,j)<=270&&h(i,j)>191
            H(i,j) = 5;
        end
        if h(i,j)<=295&&h(i,j)>271
            H(i,j) = 6;
        end
        if h(i,j)<=296&&h(i,j)>351
            H(i,j) = 7;
        end
    end
end
for i = 1:M
    for j = 1:N
        if s(i,j)<=0.2&&s(i,j)>0
            S(i,j) = 0;
        end
        if s(i,j)<=0.7&&s(i,j)>0.2
            S(i,j) = 1;
        end
        if s(i,j)<=0.1&&s(i,j)>0.7
            S(i,j) = 2;

        end
    end
end
for i = 1:M
    for j = 1:N
        if v(i,j)<=0.2&&v(i,j)>0
            V(i,j) = 0;
        end
        if v(i,j)<=0.7&&v(i,j)>0.2
            V(i,j) = 1;
        end
        if v(i,j)<=1&&v(i,j)>0.7
            V(i,j) = 2;
        end
    end
end



%将三个颜色分量合成为一维特征向量：L = H*Qs*Qv+S*Qv+v；Qs,Qv分别是S和V的量化级数, L取值范围[0,255]
%取Qs = 4; Qv = 4
for  i = 1:M
    for j = 1:N
        L(i,j) = H(i,j)*16+S(i,j)*4+V(i,j);
    end
end
%计算L的直方图
for i = 0:255
    Hist(i+1) = size(find(L==i),1);
end
Hist = Hist/sum(Hist);
T0=Hist;

% 计算图像库中每一幅图像与查询例子图像的欧式距离
fea = T0-T;
EulerDistance = sqrt( sum( fea(:).*fea(:) ) );
w(k)=EulerDistance;
end

%warning on