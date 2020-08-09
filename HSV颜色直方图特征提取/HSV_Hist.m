function [Fea]=HSV_Feature(Im)
% 3-order color moment for color image
% Input:
%          Im: color image file
% Output:
%          mu: 1st order moment features
%          ta: 2nd order moment features
%          is: 3rd order moment features
%功能：计算HSV颜色直方图特征

warning off
Fea=zeros(1,18);
[M N dim]=size(Im);
Thsv=rgb2hsv(Im);
sumpix=1;

[h,s,v] = rgb2hsv(Image);
H = h; S = s; V = v;

%将hsv空间非等间隔量化：
%  h量化成8级；
%  s量化成3级；
%  v量化成3级；
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






for i=1:M
	for j=1:N
        sumpix=sumpix+1;
		v=Thsv(i,j,3);
        s=Thsv(i,j,2);
        h=Thsv(i,j,1)*360;
       
		t=0;
        if (v<0.1)
			t=0;
        elseif (s<0.1 && v>0.9)
			t=1;
		else
			t2=0;
			if (s<0.6)
				t2=0;
			else
				t2=1; 
            end
			
            t3=0;
            if ((h>=0 && h<20) || (h>=316 && h<=360))
				t3=0;
            elseif (h>=20 && h<40)
				t3=1;
            elseif (h>=40 && h<75)
				t3=2;
            elseif (h>=75 && h<155)
				t3=3;
            elseif (h>=155 && h<190)
				t3=4;
            elseif (h>=190 && h<270)
				t3=5;
            elseif (h>=270 && h<295)
				t3=6;
            elseif (h>=295 && h<316)
				t3=7;
            end
            t=8*t2+t3+2;
        end
        Fea(t+1)=Fea(t+1)+1.0;
    end
end
Fea=Fea/sumpix;


% 计算图像库中每一幅图像与查询例子图像的欧式距离
diff = T0-T;
EulerDistance = sqrt( sum( diff(:).*diff(:) ) );
w(k)=EulerDistance;
end
warning on