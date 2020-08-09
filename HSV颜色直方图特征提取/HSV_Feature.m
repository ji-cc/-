function [Fea]=HSV_Feature(Im)
% 3-order color moment for color image
% Input:
%          Im: color image file
% Output:
%          mu: 1st order moment features
%          ta: 2nd order moment features
%          is: 3rd order moment features
%���ܣ�����HSV��ɫֱ��ͼ����

warning off
Fea=zeros(1,18);
[M N dim]=size(Im);
Thsv=rgb2hsv(Im);
sumpix=1;

[h,s,v] = rgb2hsv(Im);
H = h; S = s; V = v;

%��hsv�ռ�ǵȼ��������
%  h������8����
%  s������3����
%  v������3����
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

%��������ɫ�����ϳ�Ϊһά����������L = H*Qs*Qv+S*Qv+v��Qs,Qv�ֱ���S��V����������, Lȡֵ��Χ[0,255]
%ȡQs = 4; Qv = 4
for  i = 1:M
    for j = 1:N
        L(i,j) = H(i,j)*16+S(i,j)*4+V(i,j);
    end
end
%����L��ֱ��ͼ
for i = 0:255
    Hist(i+1) = size(find(L==i),1);
end
% Hist = Hist/sum(Hist);
T=Hist;

% ѭ������ͼ��
A=dir('G:\MATLAB\Demo\������Ƶͼ����ʵ��\ʵ��һ\HSV��ɫֱ��ͼ������ȡ\*.jpg');
for k=1:size(A)
   B=strcat('G:\MATLAB\Demo\������Ƶͼ����ʵ��\ʵ��һ\HSV��ɫֱ��ͼ������ȡ\',A(k).name);
   Image=imread(B);

end
[M,N,dim] = size(Im);
%M = 256;
%N = 256;

% ����ÿһ��ͼ�����ɫֱ��ͼ

[h,s,v] = rgb2hsv(Im);
H = h; S = s; V = v;
h = h*360;

%��hsv�ռ�ǵȼ��������
%  h������8����
%  s������3����
%  v������3����
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



%��������ɫ�����ϳ�Ϊһά����������L = H*Qs*Qv+S*Qv+v��Qs,Qv�ֱ���S��V����������, Lȡֵ��Χ[0,255]
%ȡQs = 4; Qv = 4
for  i = 1:M
    for j = 1:N
        L(i,j) = H(i,j)*16+S(i,j)*4+V(i,j);
    end
end
%����L��ֱ��ͼ
for i = 0:255
    Hist(i+1) = size(find(L==i),1);
end
Hist = Hist/sum(Hist);
T0=Hist;

% ����ͼ�����ÿһ��ͼ�����ѯ����ͼ���ŷʽ����
fea = T0-T;
EulerDistance = sqrt( sum( fea(:).*fea(:) ) );
w(k)=EulerDistance;
end

%warning on