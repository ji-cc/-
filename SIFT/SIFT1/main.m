clear;
clc;
image = imread('ÎÆÀíÍ¼Ïñ¿â/56.jpg');
image = rgb2gray(image);
image = double(image);
keyPoints = SIFT(image,3,5,1.3);
image = SIFTKeypointVisualizer(image,keyPoints);
imshow(uint8(image))

