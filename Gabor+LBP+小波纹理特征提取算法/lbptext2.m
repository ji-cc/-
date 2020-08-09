 I=imread('ÎÆÀíÍ¼Ïñ¿â\27.jpg');
mapping=getmapping(8,'u2');
H1=lbp(I,1,8,mapping,'h'); %LBP histogram in (8,1) neighborhood %using uniform patterns
subplot(1,1,1),stem(H1);