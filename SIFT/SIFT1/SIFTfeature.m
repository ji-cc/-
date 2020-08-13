function feature = SIFTfeature(img)
%sift特征提取函数
image = rgb2gray(img);
image = double(imgimage);
keyPoints = SIFT(image,3,5,1.3);
image = SIFTKeypointVisualizer(image,keyPoints);
feature = hist(image);