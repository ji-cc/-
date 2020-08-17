function [AngHist]=HOG_Hist(Im)
% 说明：提取图像的梯度方向角直方图特征（形状特征）
warning off
dim=9;
AngHist=zeros(1,dim);
[H W dim]=size(Im);
if dim>1
   Im=rgb2gray(Im); 
end
G=double(Im);
[H W]=size(G);
sumpix=1;
for ii=3:H-3
	for jj=3:W-3
		dx=G(ii,jj+2)-G(ii,jj); % (float)( ((BYTE)gray->imageData[tt+2]) - ((BYTE)gray->imageData[tt]) );
		dy=G(ii+2,jj)-G(ii,jj); %(float)( ((BYTE)gray->imageData[tt+2*W]) - ((BYTE)gray->imageData[tt]) );
		if ((dy*dy+dx*dx)>50)
			ang=angle(dx+dy*i);   %//返回0-360间的角度
			ang=(ang/pi)*180;
            if (ang<0)
				ang=ang+360;
            end
            
            ang=ang-(360.0/(dim*2.0));
			if (ang<0)
				ang=ang+360;
            end
            p=floor(ang/(360/dim));
            if (p>dim-1)
                p=dim-1;
            end
            AngHist(p+1)=AngHist(p+1)+1.0;
		    sumpix=sumpix+1;
        end
    end
end
AngHist=AngHist/sumpix;
warning on