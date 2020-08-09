% function [Fea]=HSV_moment(hsv)
% % 3-order color moment for color image
% % Input:
% %          Im: color image file
% % Output:
% %          mu: 1st order moment features
% %          ta: 2nd order moment features
% %          is: 3rd order moment features
% %功能：计算HSV颜色直方图特征
%     hImg = hsv(:,:,1);
%     sImg = hsv(:,:,2);
%     vImg = hsv(:,:,3);
%     [m,n] = size(hImg);
%     N = m*n;
%  
%     % 求一阶矩-均值
%     hMean = mean2( hImg );
%     sMean = mean2( sImg );
%     vMean = mean2( vImg );
%  
%     % 求二阶矩-方差
%     hSig = sqrt( sum(sum((hImg-hMean).^2))/N );
%     sSig = sqrt( sum(sum((sImg-sMean).^2))/N );
%     vSig = sqrt( sum(sum((vImg-vMean).^2))/N );
%  
    % 求三阶矩-斜度
%     h3   = sum( sum( (hImg-hMean).^3 ) );
%     hSke = ( h3/N )^(1/3);
%     s3   = sum( sum( (sImg-sMean).^3 ) );
%     sSke = ( s3/N )^(1/3);
%     v3   = sum( sum( (vImg-vMean).^3 ) );
%     vSke = ( v3/N )^(1/3);
%  
%     vectors = [ hMean, hSig, hSke, sMean, sSig, sSke, vMean, vSig, vSke ];
% end
function colorMoments = HSV_moment(image)
% input: image to be analyzed and extract 2 first moments from each R,G,B
% output: 1x6 vector containing the 2 first color momenst from each R,G,B
% channel

% extract color channels
R = double(image(:, :, 1));
G = double(image(:, :, 2));
B = double(image(:, :, 3));
% compute 2 first color moments from each channel
meanR = mean( R(:) );
stdR  = std( R(:) );
meanG = mean( G(:) );
stdG  = std( G(:) );
meanB = mean( B(:) );
stdB  = std( B(:) );
% construct output vector
colorMoments = [meanR stdR meanG stdG meanB stdB];
% clear workspace
% clear('R', 'G', 'B', 'meanR', 'stdR', 'meanG', 'stdG', 'meanB', 'stdB');
end