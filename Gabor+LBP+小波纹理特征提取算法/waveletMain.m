
clc;close all;clear all;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%说明：对图像库中的所有图像，进行特征提取，且保存这些特征，以备检索时用
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%第1步：对图像库中所有图像进行特征提取
ImgFilePath='纹理图像库\';     
D=dir([ImgFilePath '*.jpg']);
for n=1:length(D)  %一张一张打开图像
    f=[ImgFilePath D(n).name]; %合成图像文件名
    Img=imread(f);
   
    [H,W,dim]=size(Img);
    %若打开的是灰度图像，处理一下
    if (dim<3)
       t=Img;
       Img(:,:,1)=t;Img(:,:,2)=t;Img(:,:,3)=t;
    end
    %figure(1),imshow(Img)
    
    %分别对打开的图像，提取特征
    [Fea] = wavelet4Texture(Img);
    
    ImgSet(n).fea=Fea;          %记下特征
    ImgSet(n).ImgName=f;        %记下图像文件名
    if (mod (n,10)==0)
       n 
    end
end
save ImgDB_3Fea.mat ImgSet     %保存图像特征与相关信息
disp('图像特征提取完成...')

%第2步：图像相似检索实验
    load ImgDB_3Fea.mat   %把图像的所有特征加载进来 ImgSet
    %2.1 打开样图
    ImgName = '纹理图像库\27.jpg';  %自己在这可换图像文件名(你要检索哪张图像，就换成它的名字)

    Q_img=imread(ImgName);
    figure,imshow(Q_img),title('待查找的样图')
    %若打开的是灰度图像，处理一下
    
    %2.2 样图特征提取
    Q_ImgFea=wavelet4Texture(Q_img);    %3种特征综合在一起

    %2.3 相似检索
    tic;
    %2 求样图与库中其他所有图像的emd距离
    DisBuff=[];
    for n=1:size(ImgSet,2)
         Fea=ImgSet(n).fea;  %取出第n幅图像的特征
         d=sum((Q_ImgFea-Fea).^2);
         DisBuff=[DisBuff d];
    end
    %2.4 从小到大排序
    [v idx]=sort(DisBuff);

    %第3步：将最相似的20幅图像显示出来
    figure,
    for n=1:20
        subplot(4,5,n)
        %把对应的图像找出来
        fn=ImgSet( idx(n) ).ImgName ;
        Im=imread(fn);
        imshow(Im),title(fn)
    end
    toc
    disp('图像检索成功....');
