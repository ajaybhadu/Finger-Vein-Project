%Bilateral Filtering

clc;
clear all;
close all;

%Get the image for filtering
[Path,U_C]=imgetfile;
f = double(imread(Path));

% filter parameters
sigmar = 40;             %sigmar: width of range Gaussian
eps    = 1e-3;           %eps: kernel accuracy

% compute Gaussian bilateral filter
sigmas = 3;              %sigmas: width of spatial Gaussian
[g,Ng] = GPA(f, sigmar, sigmas, eps, 'Gauss');

%Display the input and filtered image
colormap gray,
subplot(1,2,1), imshow(uint8(f)),
title('Input', 'FontSize', 10), axis('image', 'off');
subplot(1,2,2), imshow(uint8(g)),
title('Gaussian Bilateral Filter','FontSize', 10),axis('image', 'off');
