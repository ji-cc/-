function FeatureExtract()
clc;close all;clear all;
%%%˵����������Щ�����ǽ���ǰĿ¼�����е���Ŀ¼��Ϊ������·��%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
files = dir(cd);
for i=1:length(files)
    if files(i).isdir & strcmp(files(i).name,'.') == 0  && strcmp(files(i).name,'..') == 0
        addpath([cd '/' files(i).name]);
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%˵���� ��ָ���ļ�����������ѵ��ͼ�����������ȡ����ȡ�����������һ��mat�ļ���
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%ͼ������Ŀ¼
ImgFilePath='Corelͼ��\';     

%ͼ�������
ClassName={'Africa','beaches','buildings','buses','dinosaurs','elephants','flowers','horses','mountains','food'};
ID=0;
%�򿪿���ͼ�񣬷ֱ���ȡ���ǵ�����
for n=0:999  %��1000��ͼ��
    f=num2str(n);
    f=[ImgFilePath f '.jpg'];    %�ϳ�ͼ���ļ���
    
    Img=imread(f);
    %figure(1),imshow(Img)
    [Fea]=ImgFea(Img);  %��ȡͼ������
    
    ID=floor(n/100)+1;   
    %�Խṹ��ķ�ʽ����ͼ�������Ϣ��������
    FeaBuff(n+1).Fea=Fea;               %�����һ�ж�Ӧһ������
    FeaBuff(n+1).ImgName=f;                 %ͼ���ļ���
    FeaBuff(n+1).ClassName=ClassName{ID};   %�������
    FeaBuff(n+1).id=ID;                     %ͼ���
    
    if (mod (n,10)==0)
       n 
    end
    
end
save tmp\ImgFeature.mat FeaBuff             %����ͼ����Ϣ
disp('ͼ��������ȡ���...')



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%���ܣ���ȡ������ 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [FeaBuff]=ImgFea(Img)
     [mu,ta]=wavelet4Texture(Img);         %26ά��С������������
     Fea=[mu ta];
     [mu1,ta1,is1]=mome(256*rgb2hsv(Img)); %9D hsv��ɫ������
     FeaBuff=[Fea mu1 ta1 is1];
     [AngHist]=HOG_Hist(Img);    % 9D�ݶȷ����ֱ��ͼ��������״������
     FeaBuff=[FeaBuff AngHist];
 
    


