function [Point,TP,s,t,img]=readParams(file)

[V1,V2,V3,V4] = importfile(['pt\',file,'.txt']);

img = imread(['..\..\source\', file,'.tif']);
%imref = imref2d(size(img1));

p1 = polyfit(V3,V1,1);
p2 = polyfit(V4,V2,1);

s=[p1(1) p2(1)];
t=[p1(2) p2(2)];


Point = [V1 V2];
TP = [V3 V4];