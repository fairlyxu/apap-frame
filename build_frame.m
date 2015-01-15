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
%%global param
% 画布放大倍数
scale = 1.1 ;
%% prepare the data of first row

[Point1,TP1,s1,t1,img1]=readParams('G9PQ0282');
[Point2,TP2,s2,t2,img2]=readParams('G9PQ0283');
[Point3,TP3,s3,t3,img3]=readParams('G9PQ0284');
[Point4,TP4,s4,t4,img4]=readParams('G9PQ0285');
[Point5,TP5,s5,t5,img5]=readParams('G9PQ0286');
[Point6,TP6,s6,t6,img6]=readParams('G9PQ0287');
[Point7,TP7,s7,t7,img7]=readParams('G9PQ0288');%G9PQ0335 G9PQ0341
[Point335,TP335,s335,t335,img335]=readParams('G9PQ0335');
[Point341,TP341,s341,t341,img341]=readParams('G9PQ0341');
[Point418,TP418,s418,t418,img418]=readParams('G9PQ0418');
[Point424,TP424,s424,t424,img424]=readParams('G9PQ0424');
[Point442,TP442,s442,t442,img442]=readParams('G9PQ0442');
[Point448,TP448,s448,t448,img448]=readParams('G9PQ0448');
s=[s1;s2;s3;s4;s5;s6;s7;s335;s341;s418;s424;s442;s448];
sx=geomean(s(:,1));sy=geomean(s(:,2));
t=[t1;t2;t3;t4;t5;t6;t7;t335;t341;t418;t424;t442;t448];
tx = max(t(:,1));ty = max(t(:,2));

%%点坐标还原 偏移校正
TP1(:,1) = TP1(:,1) *sx + tx; TP1(:,2) = TP1(:,2) *sy + ty;
TP2(:,1) = TP2(:,1) *sx + tx; TP2(:,2) = TP2(:,2) *sy + ty;
TP3(:,1) = TP3(:,1) *sx + tx; TP3(:,2) = TP3(:,2) *sy + ty;
TP4(:,1) = TP4(:,1) *sx + tx; TP4(:,2) = TP4(:,2) *sy + ty;
TP5(:,1) = TP5(:,1) *sx + tx; TP5(:,2) = TP5(:,2) *sy + ty;
TP6(:,1) = TP6(:,1) *sx + tx; TP6(:,2) = TP6(:,2) *sy + ty;
TP7(:,1) = TP7(:,1) *sx + tx; TP7(:,2) = TP7(:,2) *sy + ty;

TP335(:,1) = TP335(:,1) *sx + tx; TP335(:,2) = TP335(:,2) *sy + ty;
TP341(:,1) = TP341(:,1) *sx + tx; TP341(:,2) = TP341(:,2) *sy + ty;

TP424(:,1) = TP424(:,1) *sx + tx; TP424(:,2) = TP424(:,2) *sy + ty;
TP442(:,1) = TP442(:,1) *sx + tx; TP442(:,2) = TP442(:,2) *sy + ty;
TP418(:,1) = TP418(:,1) *sx + tx; TP418(:,2) = TP418(:,2) *sy + ty;
TP448(:,1) = TP448(:,1) *sx + tx; TP448(:,2) = TP448(:,2) *sy + ty;


TP = [TP1;TP2;TP3;TP4;TP5;TP6;TP7;TP335;TP341;TP418;TP424;TP442;TP448];

scatter(TP(:,1),TP(:,2));

%%building frame
length = ceil(max(TP(:,1))*scale);
width = ceil(max(TP(:,2))*scale);

% length = 11000;
% width = 7700;

canvas = zeros(width,length ,3);
canvas = im2uint8(canvas);
imwrite(canvas,'frame.jpg');

% canvas = imread('canvas.jpg');
canvas = imread('frame.jpg');
pano = MovingDLT(img1,canvas,Point1,TP1);
imshow(pano);
% pano = MovingDLT(img4,pano,Point4,TP4);
% figure;imshow(pano);
pano = MovingDLT(img7,pano,Point7,TP7);
figure;imshow(pano);
pano = MovingDLT(img335,pano,Point335,TP335);
pano = MovingDLT(img341,pano,Point341,TP341);
figure;imshow(pano);

pano = MovingDLT(img418,pano,Point418,TP418);
pano = MovingDLT(img424,pano,Point424,TP424);
pano = MovingDLT(img442,pano,Point442,TP442);
pano = MovingDLT(img448,pano,Point448,TP448);
figure;imshow(pano);
imwrite(pano,'bones3.jpg');

 