function FeatureExtract()
clc;close all;clear all;
%%%说明：下面这些句子是将当前目录下所有的子目录加为可搜索路径%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
files = dir(cd);
for i=1:length(files)
    if files(i).isdir & strcmp(files(i).name,'.') == 0  && strcmp(files(i).name,'..') == 0
        addpath([cd '/' files(i).name]);
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%说明： 对指定文件中所有类别的训练图像进行特征提取，提取的特征存放在一个mat文件中
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%图像所在目录
ImgFilePath='Corel图像集\';     

%图像类别名
ClassName={'Africa','beaches','buildings','buses','dinosaurs','elephants','flowers','horses','mountains','food'};
ID=0;
%打开库中图像，分别提取它们的特征
for n=0:999  %共1000个图像
    f=num2str(n);
    f=[ImgFilePath f '.jpg'];    %合成图像文件名
    
    Img=imread(f);
    %figure(1),imshow(Img)
    [Fea]=ImgFea(Img);  %提取图像特征
    
    ID=floor(n/100)+1;   
    %以结构体的方式，将图像相关信息保存起来
    FeaBuff(n+1).Fea=Fea;               %变成了一行对应一个特征
    FeaBuff(n+1).ImgName=f;                 %图像文件名
    FeaBuff(n+1).ClassName=ClassName{ID};   %所属类别
    FeaBuff(n+1).id=ID;                     %图像号
    
    if (mod (n,10)==0)
       n 
    end
    
end
save tmp\ImgFeature.mat FeaBuff             %保存图像信息
disp('图像特征提取完成...')



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%功能：提取的特征 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [FeaBuff]=ImgFea(Img)
     [mu,ta]=wavelet4Texture(Img);         %26维的小波纹理牺特征
     Fea=[mu ta];
     [mu1,ta1,is1]=mome(256*rgb2hsv(Img)); %9D hsv颜色矩特征
     FeaBuff=[Fea mu1 ta1 is1];
     [AngHist]=HOG_Hist(Img);    % 9D梯度方向角直方图特征（形状特征）
     FeaBuff=[FeaBuff AngHist];
 
    


