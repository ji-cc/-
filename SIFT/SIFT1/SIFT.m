function Descriptors = SIFT(inputImage, Octaves, Scales, Sigma)
    Sigmas = sigmas(Octaves,Scales,Sigma);  %��ȡ��ͬ��sigmaֵ
    ContrastThreshhold = 7.68;
    rCurvature = 10;
    G = cell(1,Octaves);     % �洢��˹������
    D = cell(1,Octaves);     % ��˹���
    GO = cell(1,Octaves);  % �ݶȷ���
    GM = cell(1,Octaves);  % �ݶȴ�С
    P = [];
    Descriptors = {};        % �ؼ���
    % ��˹������
    for o = 1:Octaves
        % ��?
        [row,col] = size(inputImage);
        temp = zeros(row,col,Scales);
        for s=1:Scales
            % ��
            temp(:,:,s) = imgaussfilt(inputImage,Sigmas(o,s));
        end
        G(o) = {temp};
        inputImage = inputImage(2:2:end,2:2:end);
    end
    % DOG������
    for o=1:Octaves
        images = cell2mat(G(o));
        [row,col,Scales] = size(images);
        temp = zeros([row,col,Scales-1]);
        for s=1:Scales-1
            temp(:,:,s) = images(:,:,s+1) - images(:,:,s);
        end
        D(o) = {temp}; % DOG
    end
    % ��ȡ��ͬ�߶��µ��ݶ���Ϣ
    % �˲�������ڹؼ�����֮����У������������
    for o = 1:Octaves
        images = cell2mat(G(o));
        [row,col,Scales] = size(images);
        tempO = zeros([row,col,Scales]); %��¼������Ϣ
        tempM = zeros([row,col,Scales]); %��¼�ݶȴ�С?
        for s = 1:Scales
            [tempM(:,:,s),tempO(:,:,s)] = imgradient(images(:,:,s)); % �����ݶȷ�����ݶȴ�С
        end
        GO(o) = {tempO};
        GM(o) = {tempM};
    end
   %% ---------------------------------------------ȡ��ֵ��----------------
    for o=1:Octaves
        images = cell2mat(D(o));
        GradientOrientations = cell2mat(GO(o));
        GradientMagnitudes = cell2mat(GM(o));
        [row,col,Scales] = size(images);
        for s=2:Scales-1
            weights = gaussianKernel(Sigmas(o,s)); % ����һ����˹��ģ��
            radius = (length(weights)-1)/2; %ģ��뾶(������)
            for y=14:col-12
                for x=14:row-12
                    sub = images(x-1:x+1,y-1:y+1,s-1:s+1); % ��ȡ����������ͼ��3*3��С?3*3大小
                     % �м������Χ26����Ƚ�
                    if sub(2,2,2) > max([sub(1:13),sub(15:end)]) || sub(2,2,2) < min([sub(1:13),sub(15:end)])
                        if abs(sub(2,2,2)) < ContrastThreshhold
                            % ��ֵ�����������
                            continue
                        else
                             % �޳����ȶ��ı�Ե��Ӧ��
                            Dxx = sub(1,2,2)+sub(3,2,2)-2*sub(2,2,2); % ��ɭ����
                            Dyy = sub(2,1,2)+sub(2,3,2)-2*sub(2,2,2);
                            Dxy = sub(1,1,2)+sub(3,3,2)-2*sub(1,3,2)-2*sub(3,1,2);
                            trace = Dxx+Dyy;% ���㼣
                            determinant = Dxx*Dyy-Dxy*Dxy;
                            curvature = trace*trace/determinant;
                            if curvature > (rCurvature+1)^2/rCurvature
                                continue % ���������ȶ��ı�Ե��
                            end
                        end
                        % ֱ��ͼͳ�����������ص��ݶȺͷ���
                        a=0;b=0;c=0;d=0;
                        if x-1-radius < 0
                            a = -(x-1-radius);
                        end
                        if y-1-radius < 0
                            b = -(y-1-radius);
                        end
                        if row-x-radius < 0
                            c = -(row-x-radius);
                        end
                        if col-y-radius < 0
                            d = -(col-y-radius);
                        end
                        tempMagnitude = GradientMagnitudes(x-radius+a:x+radius-c,y-radius+b:y+radius-d,s).*weights(1+a:end-c,1+b:end-d); %计算极�?�点附近的梯度大�?
                        tempOrientation = GradientOrientations(x-radius+a:x+radius-c,y-radius+b:y+radius-d,s);
                        [wRows, wCols] = size(tempMagnitude);
                        % ֱ��ͼͳ��(36������)
                        gHist = zeros(1,36);
                        for i = 1:wRows
                            for j = 1:wCols
                                temp = tempOrientation(i,j);
                                if temp < 0
                                    temp = 360 + temp;
                                end
                               % �Է����С����36��bin����ͳ�Ʋ�ͬbin���ݶȴ�С
                                bin = floor(temp/10)+1;
                                gHist(bin) = gHist(bin) + tempMagnitude(i,j); 
                            end
                        end
                        % ��ȡ�ؼ����������Ϣ
                        % TODO: �ؼ���ľ�ȷ��λ
                        % ��ȡ���ֵ����Ϊ�ؼ���ķ���
                        orientationThreshold = max(gHist(:))*4/5; % �������80%
                        tempP = [];
                        for i=1:length(gHist)
                            if gHist(i) > orientationThreshold
                                % ��ɢ���ݶȷ���ֱ��ͼ���в�ֵ��ϴ�������ø���ȷ�ķ���Ƕ�ֵ??
                                if i-1 <= 0
                                    X = 0:2;
                                    Y = gHist([36,1,2]);
                                elseif i+1 > 36
                                    X = 35:37;
                                    Y = gHist([35,36,1]);
                                else
                                    X = i-1:i+1;
                                    Y = gHist(i-1:i+1);
                                end
                                % �����ֵ??
                                dir = interpolateExterma([X(1),Y(1)],[X(2),Y(2)],[X(3),Y(3)])*10;
                                mag = gHist(i); 
                                % ȥ�ظ�
                                if ismember(dir,tempP(5:6:end)) == false
                                    tempP = [tempP,x,y,o,s,dir,mag];
                                end
                            end
                        end
                        P = [P,tempP];
                    end
                end
            end
        end
    end
   %% -------------------------------������ȡ---------------------------------
    weights = gaussianKernel(Sigmas(o,s),13);
    weights = weights(1:end-1,1:end-1); % 26*26
    for i = 1:6:length(P)
        x = P(i);
        y = P(i+1);
        oct = P(i+2); % ��
        scl = P(i+3);  % ��?
        dir = P(i+4);  % ����
        mag = P(i+5); % ��С
        directions = cell2mat(GO(oct));    % ��ǰ����ݶȷ���
        directions = directions(x-13:x+12,y-13:y+12,scl); % ��ǰ���ص���Χ���ݶȷ���
        magnitudes = cell2mat(GM(oct)); % ��ǰ����ݶȴ�С
        magnitudes = magnitudes(x-13:x+12,y-13:y+12,scl).*weights; %  % ��ǰ���ص���Χ���ݶȴ�С
        descriptor = [];
        for m = 5:4:20
            for n = 5:4:20
                hist = zeros(1,8);
                for o = 0:3
                    for p = 0:3
                        [newx,newy] = rotateCoordinates(m+o,n+p,13,13,-dir);
                         % ����8��bin��ֱ��ͼ
                        hist(categorizeDirection8(directions(newx,newy))) = magnitudes(newx,newy);
                    end
                end
                descriptor = [descriptor, hist];
            end
        end
        descriptor = descriptor ./ norm(descriptor,2);
        for j =1:128
            if descriptor(j) > 0.2
                descriptor(j) = 0.2;
            end
        end
        descriptor = descriptor ./ norm(descriptor,2);
        % ����һ���ؼ������
        kp = KeyPoint;
        kp.Coordinates = [x*2^(oct-1),y*2^(oct-1)];
        kp.Magnitude = mag;
        kp.Direction = dir;
        kp.Descriptor = descriptor;
        kp.Octave = oct;
        kp.Scale = scl;
        Descriptors(end+1) = {kp};
    end
end

%% --------���㲻ͬ��sigmaֵ-------------
function matrix = sigmas(octave,scale,sigma)
    % octave���Ų�ͬ�߶ȵĸ�����
    matrix = zeros(octave,scale); % % octave��scare������Ӧ��sigma
    k = sqrt(2);
    for i=1:octave
        for j=1:scale
            matrix(i,j) = i*k^(j-1)*sigma;
        end
    end
end

%% ����sigma��С������һ����˹��(ģ��)
function result = gaussianKernel(SD, Radius)
    %  % ģ��뾶Ϊ3��sigma������99.7%����Ҫ��
    if nargin < 2
        Radius = ceil(3*SD);
    end
    side = 2*Radius+1;
    result = zeros(side);
    for i = 1:side
        for j = 1:side
            x = i-(Radius+1);
            y = j-(Radius+1);
            result(i,j)=(x^2+y^2)^0.5;
        end
    end
    result = exp(-(result .^ 2) / (2 * SD * SD));
    result = result / sum(result(:));
end

%% ��ϳ������ߣ���ȡ��ȷ�ļ�ֵ?
function exterma = interpolateExterma(X, Y, Z)
   % ���������ݽ��в�ֵ����һ����ȷֵ��������Ϊ2ά
    exterma = Y(1)+...
        ((X(2)-Y(2))*(Z(1)-Y(1))^2 - (Z(2)-Y(2))*(Y(1)-X(1))^2)...
        /(2*(X(2)-Y(2))*(Z(1)-Y(1)) + (Z(2)-Y(2))*(Y(1)-X(1)));
end

%% �������һ����8������
function bin = categorizeDirection8(Direction)
    if Direction <= 22.5 && Direction > -22.5
        bin = 1;
    elseif Direction <= 67.5 && Direction > 22.5
        bin = 2;
    elseif Direction <= 112.5 && Direction > 67.5
        bin = 3;
    elseif Direction <= 157.5 && Direction > 112.5
        bin = 4;
    elseif Direction <= -157.5 || Direction > 157.5
        bin = 5;
    elseif Direction <= -112.5 && Direction > -157.5
        bin = 6;
    elseif Direction <= -67.5 && Direction > -112.5
        bin = 7;
    elseif Direction <= -22.5 && Direction > -67.5
        bin = 8;
    end
end

%% ��ת����ϵ
function [x,y] =  rotateCoordinates(x, y, originx, originy, dir)
    % �����ص���תֵdir����
    p = [x,y,1]';
    translate = [1,0,-originx;0,1,-originy;0,0,1];  % �߽�
    rotate = [cosd(dir),-sind(dir),0;sind(dir),cosd(dir),0;0,0,1];
    translateBack = [1,0,originx;0,1,originy;0,0,1]; % �߽�
    p = translateBack*rotate*translate*p;
    x = floor(p(1));
    y = floor(p(2));
end