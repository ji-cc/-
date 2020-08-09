function H = garbor(Im)

origSize = size(Im);
if length(origSize)==3 Im=rgb2gray(Im);end
Im=double(Im);

%grayimg=rgb2gray(im); 
%gim=im2double(grayimg);
wavelength=3;
angle=90;
kx=0.5;
kx=0.5;
showfilter=1;
if nargin == 5
     showfilter = 0;
 end

 im = double(Im);
 [rows, cols] = size(Im);
 newim = zeros(rows,cols);

 % Construct even and odd Gabor filters
 sigmax = wavelength*kx;
 sigmay = wavelength*ky;

 sze = round(3*max(sigmax,sigmay));
 [x,y] = meshgrid(-sze:sze);
 evenFilter = exp(-(x.^2/sigmax^2 + y.^2/sigmay^2)/2)...
.*cos(2*pi*(1/wavelength)*x);

 oddFilter = exp(-(x.^2/sigmax^2 + y.^2/sigmay^2)/2)...
.*sin(2*pi*(1/wavelength)*x);    


 evenFilter = imrotate(evenFilter, angle, 'bilinear');
 oddFilter = imrotate(oddFilter, angle, 'bilinear');    


 % Do the filtering
 Eim = filter2(evenFilter,Im); % Even filter result
 Oim = filter2(oddFilter,Im);  % Odd filter result
 Aim = sqrt(Eim.^2 + Oim.^2);  % Amplitude 
H = hist(Aim);
end

 