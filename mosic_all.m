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
%      img = imread(['..\..\source\low_res\', temImag.title,'.jpg']);
%      img =  imread();
     if(temImag.flag ==0)
         mosic = mosicMDLT(temImag.img,mosic);
     end
     
 end
 
figure;imshow(mosic);
 
imwrite(mosic,'mosic.jpg');

 
 