%% clean up and add path
close all;
clear all;
clc;

addpath('../mdlt/modelspecific');
addpath('../mdlt/mexfiles');
addpath('../mdlt/multigs');

cd ../mdlt/vlfeat-0.9.14/toolbox;
feval('vl_setup');
cd ../../../frame;
 
 

[frame,mosicImag ] = import_images; 

 
mosic = frame ;
%% building frame 
 for i = 1:size(mosicImag)     
     temImag =  mosicImag{i};
 
     if(temImag.flag ==0)
         mosic = mosicMDLT(temImag.img,mosic);
     end
     
 end
 
figure;imshow(mosic);
%% ÕÒµ½ÌØÕ÷µã
[ kp ,ds  ] = vl_sift(single(rgb2gray(mosic)),'PeakThresh', 0,'edgethresh',500);
[ kp1 ,ds1  ] = vl_sift(single(rgb2gray(mosicImag{1}.img)),'PeakThresh', 0,'edgethresh',500);
[ kp2 ,ds2  ] = vl_sift(single(rgb2gray(mosicImag{2}.img)),'PeakThresh', 0,'edgethresh',500);
[ kp3 ,ds3  ] = vl_sift(single(rgb2gray(mosicImag{3}.img)),'PeakThresh', 0,'edgethresh',500);
[ kp4 ,ds4  ] = vl_sift(single(rgb2gray(mosicImag{4}.img)),'PeakThresh', 0,'edgethresh',500);
[ kp5 ,ds5  ] = vl_sift(single(rgb2gray(mosicImag{5}.img)),'PeakThresh', 0,'edgethresh',500);
[ kp6 ,ds6  ] = vl_sift(single(rgb2gray(mosicImag{6}.img)),'PeakThresh', 0,'edgethresh',500);
[ kp7 ,ds7  ] = vl_sift(single(rgb2gray(mosicImag{7}.img)),'PeakThresh', 0,'edgethresh',500);

[matches1,score1] = vl_ubcmatch(kp, kp1); 
[matches2,score2] = vl_ubcmatch(kp, kp2);
[matches3,score3] = vl_ubcmatch(kp, kp3);
[matches4,score4] = vl_ubcmatch(kp, kp4);
[matches5,score5] = vl_ubcmatch(kp, kp5);
[matches6,score6] = vl_ubcmatch(kp, kp6);
[matches7,score7] = vl_ubcmatch(kp, kp7);
 
for i = 1:size(mosicImag)
    
end

%imwrite(mosic,'ba1.jpg');

 
 