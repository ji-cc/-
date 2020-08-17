function SVM_ImageRetrieval()
close all;clear all;clc;
%%%说明：下面这些句子是将当前目录下所有的子目录加为可搜索路径%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
files = dir(cd);
for i=1:length(files)
    if files(i).isdir & strcmp(files(i).name,'.') == 0  && strcmp(files(i).name,'..') == 0
        addpath([cd '/' files(i).name]);
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%功能说明：  再用标准的SVM进行分类。
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    FeaBuff.ClassName   -- 类别名
%    FeaBuff.ImgName  -- 图像文件名
%    FeaBuff.instance    -- 示例,一行为一个示例
%    FeaBuff.label       -- 包的标号

%图像/分割掩模图像路径
ImagePath='Corel图像集\';
%加载图像特征 
load tmp\ImgFeature.mat;      
%图像类别名
ClassName={'Africa','beaches','buildings','buses','dinosaurs','elephants','flowers','horses','mountains','food'};

ID=4;  %设置你要检索的图像类别ID(可任意设置成1-10的数,因为库中只有10类图像，每类100幅)

%1 构造训练与测试集
ImgNum=100;
N=40;   %设置训练图像的数量,就是从每类图像中选40幅用于SVM训练，另100-N幅用于测试

%正
%正类图像随机分组(前40幅用于训练，后60幅用于测试)
PosN=randperm(ImgNum); 
pFea=[];
for n=1:ImgNum
    P=(ID-1)*100+PosN(n);
    pLabel(n)=1;  %正
    pFea=[pFea;FeaBuff(P).Fea];
    pFN(n).fn=FeaBuff(P).ImgName;
end

%负
n=1;
NagN=randperm(1000); 
nFea=[];
for nn=NagN
    if ( nn>=((ID-1)*ImgNum+1) && nn<=((ID-1)*ImgNum+ImgNum) )
        continue;%这些已在正类中了
    end 
    P=nn;
    nLabel(n)=-1;  %负
    nFea=[nFea;FeaBuff(P).Fea];
    nFN(n).fn=FeaBuff(P).ImgName;
    n=n+1;
end
clear FeaBuff; %消去不用的变量,省一点内存

%2 分别从正、负类选出前N个作为训练集%%%%%%% 
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


%3 在此函数中先训练SVM分类器，然后再对测试数据进行类别预测
[ypred1]=LibSvmTrainAndTest_fun(TrainFea,TestFea,TrainLabel,TestLabel);%TrainData 和 TestData一行对应一样本
%计算AUC tpr fpr的检索精度数据
show_flg=1;
[AUC tpr fpr]=PlotROC_AUC(TestLabel,ypred1,show_flg);%title('VS投影特征')

%根据顺序，将排在前面的20个图像显示出来
ShowTopNImg(TestImgFileName,ypred1,ImagePath)

%%主程序结束%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('主程序运行成功!!!')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%子程序2：用数据 TrainData 训练SVM分类器，且对 TestData 数据进行测试
%参数：TrainData 和 TestData分别是训练与测试数据（一行对应一个样本）,TrainL和TestL 分别是样本对应的标号
%      ypred 为测试样本的预测结果
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [ypred]=LibSvmTrainAndTest_fun(TrainData,TestData,TrainL,TestL)
%1 SVM训练与测试文件构造
[r dim]=size(TrainData);
fid=fopen('tmp\RSSvmTrain.txt','w');
for n=1:r
      fprintf(fid, '%d ',TrainL(n)); %标号
      %写入特征
      for x=1:dim-1
         fprintf(fid, '%d:%0.8f ',x,TrainData(n,x));
      end
      fprintf(fid, '%d:%0.8f',dim,TrainData(n,dim));
      fprintf(fid, '\n'); %换行
end
fclose(fid); 
disp('SVM训练文件构造成功......')

[r dim]=size(TestData);
fid=fopen('tmp\RSSvmTest.txt','w');
Tnmu=0;
for n=1:r
      fprintf(fid, '%d ',TestL(n)); %实例名
      %写入特征
      for x=1:dim-1
         fprintf(fid, '%d:%0.8f ',x,TestData(n,x));
      end
      fprintf(fid, '%d:%0.8f',dim,TestData(n,dim));
      fprintf(fid, '\n'); %换行
end
fclose(fid); 
disp('SVM测试文件构造成功......')

%2 SVM训练与测试
%尺度缩放
system(['svm\svm-scale.exe -s tmp\尺度模板 tmp\RSSvmTrain.txt > tmp\RSSvmTrain.scale']);
system(['svm\svm-scale.exe -r tmp\尺度模板 tmp\RSSvmTest.txt > tmp\RSSvmTest.scale']);
for g=[0.001]
    for C=[100] %[0.0001 0.001 0.01 0.1 1]
        %合成命令
        Tcom1='svm\svm-train.exe -s 3 -b 1 -t 2 -c ';
        Tcom2=[num2str(C) ' -g ' num2str(g)];
        Tcom3=' tmp\RSSvmTrain.scale tmp\分类模型.mdl';
        T=[Tcom1 Tcom2 Tcom3];
        %训练
        system(T);
        %system(['svm-train.exe -s 3 -t 2 -c 100 -g 0.001 RSSvmTrain.scale 分类模型.mdl']);
        %预测
        system(['svm\svm-predict.exe tmp\RSSvmTest.scale tmp\分类模型.mdl  tmp\预测结果.txt']);
        %读出预测结果
        [ypred] = textread('tmp\预测结果.txt', '%f', length(TestL));
    end
end
disp('LdxSvm运行成功结束......')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
%子程序3:画ROC曲线与计算AUC值
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [AUC tpr fpr]=PlotROC_AUC(TestBag,PreLabels,show_flg)
    BagNum=length(TestBag);
    %1 统计正包＼负包数
    PosBagNums=0;NagBagNums=0;
    for n=1:length(TestBag)
        tLabel=TestBag(n); %包标号
        %统计正包个数TP，与负包个数TN
        if (tLabel==1)
            PosBagNums=PosBagNums+1;
        else
           NagBagNums=NagBagNums+1; 
        end
   end
   %2 改变阈值，画ROC   
     fpr=[];tpr=[];
     PP=sort(PreLabels,'descend');   
     PP=PP';
     %PP=PP(1:2:length(PP));
     for Th=PP %(1:s:length(PP))';  
        Pos=0;Nag=0;
        for n=1:BagNum
            tLabel=TestBag(n); %包标号
            LL=PreLabels(n);
            if (LL>=Th && tLabel>0)
                Pos=Pos+1;%正确检测
            end
            if (LL>=Th && tLabel<0)
                Nag=Nag+1; %误检测率
            end
        end
        TPr=Pos/(0.001+PosBagNums);FPr=Nag/(0.001+NagBagNums);
        fpr=[fpr FPr];tpr=[tpr TPr];
     end

     %3 计算AUC和画ROC曲线
     tpr = [0  tpr  1];
     fpr = [0  fpr  1];
     save F:\ROC6.mat fpr tpr
     n = length(tpr);
     AUC = sum((fpr(2:n) - fpr(1:n-1)).*(tpr(2:n)+tpr(1:n-1)))/2;
     if (show_flg)
         figure,plot(fpr,tpr),axis([-0.1 1.1 0 1.1]),title(['ROC曲线 AUC=' num2str(AUC)])
         disp('ROC曲线与AUC值计算完成......')
     end
     
%根据顺序，将排在前面的20个图像显示出来
function ShowTopNImg(Testbag,yp,ImgPath)
     [PP idx]=sort(yp,'descend');   
     Row=4;Col=5;   %4行5列=20幅图像
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


    


     