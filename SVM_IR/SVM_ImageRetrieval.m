function SVM_ImageRetrieval()
close all;clear all;clc;
%%%˵����������Щ�����ǽ���ǰĿ¼�����е���Ŀ¼��Ϊ������·��%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
files = dir(cd);
for i=1:length(files)
    if files(i).isdir & strcmp(files(i).name,'.') == 0  && strcmp(files(i).name,'..') == 0
        addpath([cd '/' files(i).name]);
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%����˵����  ���ñ�׼��SVM���з��ࡣ
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    FeaBuff.ClassName   -- �����
%    FeaBuff.ImgName  -- ͼ���ļ���
%    FeaBuff.instance    -- ʾ��,һ��Ϊһ��ʾ��
%    FeaBuff.label       -- ���ı��

%ͼ��/�ָ���ģͼ��·��
ImagePath='Corelͼ��\';
%����ͼ������ 
load tmp\ImgFeature.mat;      
%ͼ�������
ClassName={'Africa','beaches','buildings','buses','dinosaurs','elephants','flowers','horses','mountains','food'};

ID=4;  %������Ҫ������ͼ�����ID(���������ó�1-10����,��Ϊ����ֻ��10��ͼ��ÿ��100��)

%1 ����ѵ������Լ�
ImgNum=100;
N=40;   %����ѵ��ͼ�������,���Ǵ�ÿ��ͼ����ѡ40������SVMѵ������100-N�����ڲ���

%��
%����ͼ���������(ǰ40������ѵ������60�����ڲ���)
PosN=randperm(ImgNum); 
pFea=[];
for n=1:ImgNum
    P=(ID-1)*100+PosN(n);
    pLabel(n)=1;  %��
    pFea=[pFea;FeaBuff(P).Fea];
    pFN(n).fn=FeaBuff(P).ImgName;
end

%��
n=1;
NagN=randperm(1000); 
nFea=[];
for nn=NagN
    if ( nn>=((ID-1)*ImgNum+1) && nn<=((ID-1)*ImgNum+ImgNum) )
        continue;%��Щ������������
    end 
    P=nn;
    nLabel(n)=-1;  %��
    nFea=[nFea;FeaBuff(P).Fea];
    nFN(n).fn=FeaBuff(P).ImgName;
    n=n+1;
end
clear FeaBuff; %��ȥ���õı���,ʡһ���ڴ�

%2 �ֱ����������ѡ��ǰN����Ϊѵ����%%%%%%% 
TrainFea=pFea(1:N,:);
TrainLabel=pLabel(1:N);
TestFea=pFea(N+1:100,:);
TestLabel=pLabel(N+1:100);
TestImgFileName=pFN((N+1:100));

TrainFea=[TrainFea;nFea(1:N,:)];
TrainLabel=[TrainLabel nLabel(1:N)];
TestFea=[TestFea; nFea(N+1:900,:)];
TestLabel=[TestLabel nLabel(N+1:900)];
TestImgFileName=[TestImgFileName nFN(N+1:900)];


%3 �ڴ˺�������ѵ��SVM��������Ȼ���ٶԲ������ݽ������Ԥ��
[ypred1]=LibSvmTrainAndTest_fun(TrainFea,TestFea,TrainLabel,TestLabel);%TrainData �� TestDataһ�ж�Ӧһ����
%����AUC tpr fpr�ļ�����������
show_flg=1;
[AUC tpr fpr]=PlotROC_AUC(TestLabel,ypred1,show_flg);%title('VSͶӰ����')

%����˳�򣬽�����ǰ���20��ͼ����ʾ����
ShowTopNImg(TestImgFileName,ypred1,ImagePath)

%%���������%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('���������гɹ�!!!')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%�ӳ���2�������� TrainData ѵ��SVM���������Ҷ� TestData ���ݽ��в���
%������TrainData �� TestData�ֱ���ѵ����������ݣ�һ�ж�Ӧһ��������,TrainL��TestL �ֱ���������Ӧ�ı��
%      ypred Ϊ����������Ԥ����
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [ypred]=LibSvmTrainAndTest_fun(TrainData,TestData,TrainL,TestL)
%1 SVMѵ��������ļ�����
[r dim]=size(TrainData);
fid=fopen('tmp\RSSvmTrain.txt','w');
for n=1:r
      fprintf(fid, '%d ',TrainL(n)); %���
      %д������
      for x=1:dim-1
         fprintf(fid, '%d:%0.8f ',x,TrainData(n,x));
      end
      fprintf(fid, '%d:%0.8f',dim,TrainData(n,dim));
      fprintf(fid, '\n'); %����
end
fclose(fid); 
disp('SVMѵ���ļ�����ɹ�......')

[r dim]=size(TestData);
fid=fopen('tmp\RSSvmTest.txt','w');
Tnmu=0;
for n=1:r
      fprintf(fid, '%d ',TestL(n)); %ʵ����
      %д������
      for x=1:dim-1
         fprintf(fid, '%d:%0.8f ',x,TestData(n,x));
      end
      fprintf(fid, '%d:%0.8f',dim,TestData(n,dim));
      fprintf(fid, '\n'); %����
end
fclose(fid); 
disp('SVM�����ļ�����ɹ�......')

%2 SVMѵ�������
%�߶�����
system(['svm\svm-scale.exe -s tmp\�߶�ģ�� tmp\RSSvmTrain.txt > tmp\RSSvmTrain.scale']);
system(['svm\svm-scale.exe -r tmp\�߶�ģ�� tmp\RSSvmTest.txt > tmp\RSSvmTest.scale']);
for g=[0.001]
    for C=[100] %[0.0001 0.001 0.01 0.1 1]
        %�ϳ�����
        Tcom1='svm\svm-train.exe -s 3 -b 1 -t 2 -c ';
        Tcom2=[num2str(C) ' -g ' num2str(g)];
        Tcom3=' tmp\RSSvmTrain.scale tmp\����ģ��.mdl';
        T=[Tcom1 Tcom2 Tcom3];
        %ѵ��
        system(T);
        %system(['svm-train.exe -s 3 -t 2 -c 100 -g 0.001 RSSvmTrain.scale ����ģ��.mdl']);
        %Ԥ��
        system(['svm\svm-predict.exe tmp\RSSvmTest.scale tmp\����ģ��.mdl  tmp\Ԥ����.txt']);
        %����Ԥ����
        [ypred] = textread('tmp\Ԥ����.txt', '%f', length(TestL));
    end
end
disp('LdxSvm���гɹ�����......')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
%�ӳ���3:��ROC���������AUCֵ
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [AUC tpr fpr]=PlotROC_AUC(TestBag,PreLabels,show_flg)
    BagNum=length(TestBag);
    %1 ͳ�������ܸ�����
    PosBagNums=0;NagBagNums=0;
    for n=1:length(TestBag)
        tLabel=TestBag(n); %�����
        %ͳ����������TP���븺������TN
        if (tLabel==1)
            PosBagNums=PosBagNums+1;
        else
           NagBagNums=NagBagNums+1; 
        end
   end
   %2 �ı���ֵ����ROC   
     fpr=[];tpr=[];
     PP=sort(PreLabels,'descend');   
     PP=PP';
     %PP=PP(1:2:length(PP));
     for Th=PP %(1:s:length(PP))';  
        Pos=0;Nag=0;
        for n=1:BagNum
            tLabel=TestBag(n); %�����
            LL=PreLabels(n);
            if (LL>=Th && tLabel>0)
                Pos=Pos+1;%��ȷ���
            end
            if (LL>=Th && tLabel<0)
                Nag=Nag+1; %������
            end
        end
        TPr=Pos/(0.001+PosBagNums);FPr=Nag/(0.001+NagBagNums);
        fpr=[fpr FPr];tpr=[tpr TPr];
     end

     %3 ����AUC�ͻ�ROC����
     tpr = [0  tpr  1];
     fpr = [0  fpr  1];
     save F:\ROC6.mat fpr tpr
     n = length(tpr);
     AUC = sum((fpr(2:n) - fpr(1:n-1)).*(tpr(2:n)+tpr(1:n-1)))/2;
     if (show_flg)
         figure,plot(fpr,tpr),axis([-0.1 1.1 0 1.1]),title(['ROC���� AUC=' num2str(AUC)])
         disp('ROC������AUCֵ�������......')
     end
     
%����˳�򣬽�����ǰ���20��ͼ����ʾ����
function ShowTopNImg(Testbag,yp,ImgPath)
     [PP idx]=sort(yp,'descend');   
     Row=4;Col=5;   %4��5��=20��ͼ��
     figure,
     x=1;
     for n=1:Row
         for m=1:Col
             BN=Testbag(idx(x)).fn;
             L=length(BN);
             s=L-4;
             c=BN(s);CC='';
             while not(c=='\')
                 CC=[c CC];
                 s=s-1;
                 c=BN(s);
             end
             nn=str2num(CC);
             I=imread(BN);
             subplot(Row,Col,x),imshow(I),title([num2str(floor(nn/100)+1) '-' num2str(nn)])
             x=x+1;
         end
     end


    


     