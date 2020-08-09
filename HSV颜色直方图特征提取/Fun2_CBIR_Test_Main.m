function Fun2_CBIR_Test_Main()
clc;close all;clear all;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%说明： CBIR图像检索测试仿真
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    %第2步：图像相似检索实验
    load ImgDB_3Fea.mat   %把图像的所有特征加载进来 ImgSet
    %2.1 打开样图
    ImgName = '图像库\626.jpg';  %自己在这可换图像文件名(你要检索哪张图像，就换成它的名字)

    Q_img=imread(ImgName);
    figure,imshow(Q_img),title('待查找的样图')
    %若打开的是灰度图像，处理一下
    [H,W,dim]=size(Q_img);
    if (dim<3)
       t=Q_img;
       Q_img(:,:,1)=t;Q_img(:,:,2)=t;Q_img(:,:,3)=t;
    end
    %2.2 样图特征提取
    [Fea1]=HSV_Hist(Q_img);       %求图像的HSV颜色直方图特征
    [Fea2]=GLM_Texture(Q_img);    %求图像的灰度共生纹理特征
    [Fea3]=Hu_Mone(Q_img);        %求图像的HU矩形状特征
    Q_ImgFea=[Fea1 Fea2 Fea3];    %3种特征综合在一起

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








