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

%% prepare the data of first row

[Point1,TP1,s1,t1,img1]=readParams('G9PQ0282');
[Point2,TP2,s2,t2,img2]=readParams('G9PQ0283');
[Point3,TP3,s3,t3,img3]=readParams('G9PQ0284');
[Point4,TP4,s4,t4,img4]=readParams('G9PQ0285');
[Point5,TP5,s5,t5,img5]=readParams('G9PQ0286');
[Point6,TP6,s6,t6,img6]=readParams('G9PQ0287');
[Point7,TP7,s7,t7,img7]=readParams('G9PQ0288');

s=[s1;s2;s3;s4;s5;s6;s7];
sx=geomean(s(:,1));sy=geomean(s(:,2));
t=[t1;t2;t3;t4;t5;t6;t7];
tx = max(t(:,1));ty = max(t(:,2));

%%点坐标还原 偏移校正
TP1(:,1) = TP1(:,1) *sx + tx; TP1(:,2) = TP1(:,2) *sy + ty;
TP2(:,1) = TP2(:,1) *sx + tx; TP2(:,2) = TP2(:,2) *sy + ty;
TP3(:,1) = TP3(:,1) *sx + tx; TP3(:,2) = TP3(:,2) *sy + ty;
TP4(:,1) = TP4(:,1) *sx + tx; TP4(:,2) = TP4(:,2) *sy + ty;
TP5(:,1) = TP5(:,1) *sx + tx; TP5(:,2) = TP5(:,2) *sy + ty;
TP6(:,1) = TP6(:,1) *sx + tx; TP6(:,2) = TP6(:,2) *sy + ty;
TP7(:,1) = TP7(:,1) *sx + tx; TP7(:,2) = TP7(:,2) *sy + ty;

TP = [TP1;TP2;TP3;TP4;TP5;TP6;TP7];

scatter(TP(:,1),TP(:,2));

%% building frame
% canvas = imread('canvas.jpg');
% pano = MovingDLT(img1,canvas,Point1,TP1);
% % imshow(pano);
% pano = MovingDLT(img4,pano,Point4,TP4);
% % figure;imshow(pano);
% pano = MovingDLT(img7,pano,Point7,TP7);
% figure;imshow(pano);
% imwrite(pano,'frame.jpg');

%% stitching the bones of first row

frame =   imread('frame.jpg');
mosic = mosicMDLT(img2,frame);
mosic = mosicMDLT(img3,mosic);
imwrite(mosic,'mosic23.jpg');
mosic = mosicMDLT(img5,mosic);
imwrite(mosic,'mosic5.jpg');
mosic =   imread('mosic5.jpg');
mosic = mosicMDLT(img6,mosic);
imwrite(mosic,'mosic6.jpg');
mosic = mosicMDLT(img7,mosic);
imwrite(mosic,'mosic7.jpg');
% pano = MovingDLT(img1,canvas,Point1,TP1);
% imshow(pano);
% pano = MovingDLT(img4,pano,Point4,TP4);
% figure;imshow(pano);
% pano = MovingDLT(img7,pano,Point7,TP7);
% figure;imshow(pano);