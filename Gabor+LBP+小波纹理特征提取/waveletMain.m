
clc;close all;clear all;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%˵������ͼ����е�����ͼ�񣬽���������ȡ���ұ�����Щ�������Ա�����ʱ��
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%��1������ͼ���������ͼ�����������ȡ
ImgFilePath='����ͼ���\';     
D=dir([ImgFilePath '*.jpg']);
for n=1:length(D)  %һ��һ�Ŵ�ͼ��
    f=[ImgFilePath D(n).name]; %�ϳ�ͼ���ļ���
    Img=imread(f);
   
    [H,W,dim]=size(Img);
    %���򿪵��ǻҶ�ͼ�񣬴���һ��
    if (dim<3)
       t=Img;
       Img(:,:,1)=t;Img(:,:,2)=t;Img(:,:,3)=t;
    end
    %figure(1),imshow(Img)
    
    %�ֱ�Դ򿪵�ͼ����ȡ����
    [Fea] = wavelet4Texture(Img);
    
    ImgSet(n).fea=Fea;          %��������
    ImgSet(n).ImgName=f;        %����ͼ���ļ���
    if (mod (n,10)==0)
       n 
    end
end
save ImgDB_3Fea.mat ImgSet     %����ͼ�������������Ϣ
disp('ͼ��������ȡ���...')

%��2����ͼ�����Ƽ���ʵ��
    load ImgDB_3Fea.mat   %��ͼ��������������ؽ��� ImgSet
    %2.1 ����ͼ
    ImgName = '����ͼ���\27.jpg';  %�Լ�����ɻ�ͼ���ļ���(��Ҫ��������ͼ�񣬾ͻ�����������)

    Q_img=imread(ImgName);
    figure,imshow(Q_img),title('�����ҵ���ͼ')
    %���򿪵��ǻҶ�ͼ�񣬴���һ��
    
    %2.2 ��ͼ������ȡ
    Q_ImgFea=wavelet4Texture(Q_img);    %3�������ۺ���һ��

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
