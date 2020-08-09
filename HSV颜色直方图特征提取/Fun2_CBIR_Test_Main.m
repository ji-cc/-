function Fun2_CBIR_Test_Main()
clc;close all;clear all;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%˵���� CBIRͼ��������Է���
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    %��2����ͼ�����Ƽ���ʵ��
    load ImgDB_3Fea.mat   %��ͼ��������������ؽ��� ImgSet
    %2.1 ����ͼ
    ImgName = 'ͼ���\626.jpg';  %�Լ�����ɻ�ͼ���ļ���(��Ҫ��������ͼ�񣬾ͻ�����������)

    Q_img=imread(ImgName);
    figure,imshow(Q_img),title('�����ҵ���ͼ')
    %���򿪵��ǻҶ�ͼ�񣬴���һ��
    [H,W,dim]=size(Q_img);
    if (dim<3)
       t=Q_img;
       Q_img(:,:,1)=t;Q_img(:,:,2)=t;Q_img(:,:,3)=t;
    end
    %2.2 ��ͼ������ȡ
    [Fea1]=HSV_Hist(Q_img);       %��ͼ���HSV��ɫֱ��ͼ����
    [Fea2]=GLM_Texture(Q_img);    %��ͼ��ĻҶȹ�����������
    [Fea3]=Hu_Mone(Q_img);        %��ͼ���HU����״����
    Q_ImgFea=[Fea1 Fea2 Fea3];    %3�������ۺ���һ��

    %2.3 ���Ƽ���
    tic;
    %2 ����ͼ�������������ͼ���emd����
    DisBuff=[];
    for n=1:size(ImgSet,2)
         Fea=ImgSet(n).fea;  %ȡ����n��ͼ�������
         d=sum((Q_ImgFea-Fea).^2);
         DisBuff=[DisBuff d];
    end
    %2.4 ��С��������
    [v idx]=sort(DisBuff);

    %��3�����������Ƶ�20��ͼ����ʾ����
    figure,
    for n=1:20
        subplot(4,5,n)
        %�Ѷ�Ӧ��ͼ���ҳ���
        fn=ImgSet( idx(n) ).ImgName ;
        Im=imread(fn);
        imshow(Im),title(fn)
    end
    toc
    disp('ͼ������ɹ�....');








