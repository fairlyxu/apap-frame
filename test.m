%% 初始化拼接图信息  生成骨架 返回所有图片
function [ frame,imags] =  import_images ()

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
% A = ['G9PQ0282'; 'G9PQ0283'; 'G9PQ0284'; 'G9PQ0285'; 'G9PQ0286'; 'G9PQ0287'; 'G9PQ0288'; 'G9PQ0302'; 'G9PQ0303'; 'G9PQ0304'; 'G9PQ0305'; 'G9PQ0306'; 'G9PQ0307'; 'G9PQ0308'; 'G9PQ0319'; 'G9PQ0320'; 'G9PQ0321'; 'G9PQ0322'; 'G9PQ0323'; 'G9PQ0324'; 'G9PQ0325'; 'G9PQ0335'; 'G9PQ0336'; 'G9PQ0337'; 'G9PQ0338'; 'G9PQ0339'; 'G9PQ0340'; 'G9PQ0341'; 'G9PQ0354'; 'G9PQ0355'; 'G9PQ0356'; 'G9PQ0357'; 'G9PQ0358'; 'G9PQ0359'; 'G9PQ0360'; 'G9PQ0380'; 'G9PQ0381'; 'G9PQ0382'; 'G9PQ0383'; 'G9PQ0384'; 'G9PQ0385'; 'G9PQ0386'; 'G9PQ0418'; 'G9PQ0419'; 'G9PQ0420'; 'G9PQ0421'; 'G9PQ0422'; 'G9PQ0423'; 'G9PQ0424'; 'G9PQ0442'; 'G9PQ0443'; 'G9PQ0444'; 'G9PQ0445'; 'G9PQ0446'; 'G9PQ0447'; 'G9PQ0448'];
% bones = ['G9PQ0282';'G9PQ0285';'G9PQ0288';'G9PQ0335';'G9PQ0338';'G9PQ0341';'G9PQ0442' ;'G9PQ0448'];
% % 
A = ['G9PQ0282'; 'G9PQ0283'; 'G9PQ0284'; 'G9PQ0285'; 'G9PQ0286'; 'G9PQ0287'; 'G9PQ0288'  ];
bones =['G9PQ0282'; 'G9PQ0283'; 'G9PQ0284'; 'G9PQ0285'; 'G9PQ0286'; 'G9PQ0287'; 'G9PQ0288'  ];


columnHeadings = {'title','Point','TP','s','t','img','flag'};
 
imgNum = size(A,1);
boneNum = size(bones,1);
scale = 1.01;
bonesPoints = [];
bonesImag = [];
imags = cell(imgNum,1);

for i = 1:imgNum
    tmp{1} = A(i,:);
    [tmp{2},tmp{3},tmp{4},tmp{5},tmp{6}] = readParams(A(i,:));
    tmp{7} = 0;
    
    for j = 1:boneNum
        if(strcmp(tmp(1),bones(j,:)) )
            tmp{7} = 1;           
            break; 
        end       
    end
    s(i,:) = tmp{4};
    t(i,:) = tmp{5};
    imags{i} = cell2struct(tmp, columnHeadings, 2);
end

 
sx=geomean(s(:,1));sy=geomean(s(:,2));
tx = max(t(:,1));ty = max(t(:,2));
 
for i = 1:imgNum
    imagS = imags{i};
    
    if(imagS.flag==1)
          
        bonesImag = [bonesImag;imagS]; 
    end
end 

%% 点坐标还原 偏移校正
for j = 1: boneNum
    tempTP = bonesImag(j).TP;
    tempTP(:,1) = tempTP(:,1) *sx + tx; tempTP(:,2) = tempTP(:,2) *sy + ty;
%     tempTP(:,1) = tempTP(:,1) *sx + tx; tempTP(:,2) = tempTP(:,2) *sy + ty;
    bonesImag(j).TP= tempTP; 
    bonesPoints = [bonesPoints;tempTP];
end
 scatter(bonesPoints(:,1),bonesPoints(:,2)); 
%% building frame
length = ceil(max(bonesPoints(:,1))*scale ) ;
width = ceil(max(bonesPoints(:,2))*scale ) ;
frame = zeros(width,length,3);
 
for i = 1:size(bonesImag,1)
    bonesTemp = bonesImag(i);
    frame = MovingDLT(bonesTemp.img,frame,bonesTemp.Point,bonesTemp.TP);
    
end
% frame = imresize(frame,0.5);
% mosicImag = imags;
figure;imshow(frame);
imwrite(frame,'frameaaaaa.jpg');
