clc;clear all;close all;
l = 'Authenticated';
n = 'not Authenticated';
srcFiles = dir('D:\Image processing\Finger_vein\Code\AAyush\dataset\*.jpg'); 
for i = 1 : length(srcFiles)
    filename = strcat('D:\Image processing\Finger_vein\Code\AAyush\dataset\',srcFiles(i).name);
    I = double(imread(filename));
figure, imshow(uint8(I));



se=strel('disk',7);
idilate = imdilate(I,se);


%

%HOG FEATURES
 [featureVector, hogVisualization] = extractHOGFeatures(I,[16 16]);
%     figure;
%    imshow(image); hold on; 
%     plot(hogVisualization);
% title('HOG');

m(i,1)=mean2(I);%mean
sd(i,1)=std2(I);%std dev
en(i,1)=entropy(I);%entropy
v(i,1)=var(I(:));%variance
skw(i,1)=skewness(I(:));%skewness
k(i,1)=kurtosis(I(:));

meas=[m sd en  v skw k ];

label = {l;n;n};

end

save Trainset.mat meas label
