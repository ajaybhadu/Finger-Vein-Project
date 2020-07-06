clc;
clear all;
close all;

filename = imgetfile;
a=imread(filename);
    I = double(a);
figure, imshow(uint8(I));
% f = double(imread(file));
%f = double(imread(Path));
a = imresize(a,[256 256]);

%pixval on 

sigmar = 40;             %sigmar: width of range Gaussian
eps    = 1e-3;           %eps: kernel accuracy

% compute Gaussian bilateral filter
sigmas = 3;              %sigmas: width of spatial Gaussian
[g,Ng] = GPA(I, sigmar, sigmas, eps, 'Gauss');

%Display the input and filtered image
colormap gray,
figure(1),
subplot(2,1,1), imshow(uint8(a)),
title('Input', 'FontSize', 10), axis('image', 'off');
subplot(2,1,2), imshow(uint8(g)),
title('Gaussian Bilateral Filter','FontSize', 10),axis('image', 'off');


a1 = a(52:186,72:177);
%imshow(a1);
[r c] = size(a1);
a2 = imresize(a1,1/4);
%imshow(a2);

a2 = imresize(a2,[r c]);
%imshow(a2);

a3 = histeq(a2);


a4 = imresize(a3,1/3);
%imshow(a4);
[ll lh hl hh] =dwt2(a4,'haar');
feature1 = mean(mean(ll));
a5 = im2bw(a4);


figure(2),
subplot(2,1,1);
imshow(a3);
title('Histogram equalization');
subplot(2,1,2)
imshow(a5);
title('Segmented image');


[row, col] = size(a);
mse = sum(sum((a(1,1) - g(1,1)).^2)) / (row * col);
psnr = 10 * log10(255 * 255 / mse);
disp('Mean Square Error ');
disp(mse);
disp('Peak Signal to Noise Ratio');
disp(psnr);


%ENHANCEMENT
%DILATION
se=strel('disk',7);
idilate = imdilate(I,se);

%HOG FEATURES
 [featureVector, hogVisualization] = extractHOGFeatures(I,[16 16]);


m=mean2(I);%mean
sd=std2(I);%std dev
en=entropy(I);%entropy
v=var(I(:));%variance
skw=skewness(I(:));%skewness
k=kurtosis(I(:));
feat=[m sd en  v skw k ];

disp('<--------------------Extracted Features------------------------>');
disp('Mean=');disp(m);
disp('Standard Deviation=');disp(sd);
disp('Entropy');disp(en);
disp('Variance');disp(v);
disp('Skewness');disp(skw);
disp('Kurtosis');disp(k);
disp('<-------------------------------------------------------------->');

%  Main function for using GSA algorithm.
N=5; 
 max_it=1000; 
 ElitistCheck=1; Rpower=1;
 min_flag=1; % 1: minimization, 0: maximization

 F_index=1
 [Fbest,Lbest,BestChart,MeanChart]=GSA(F_index,N,max_it,ElitistCheck,min_flag,Rpower);Fbest,
 figure;
 semilogy(BestChart,'--k');

 title(['\fontsize{12}\bf F',num2str(F_index)]);
 xlabel('\fontsize{12}\bf Iteration');ylabel('\fontsize{12}\bf Best-so-far');
 legend('\fontsize{10}\bf GSA',1);


load Trainset.mat
 xdata = meas;
 group = label;

 svmStruct1 = svmtrain(xdata,group,'kernel_function', 'linear');

 Result = svmclassify(svmStruct1,feat,'showplot',false)
  helpdlg(Result);