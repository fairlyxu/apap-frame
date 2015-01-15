canvas = imread('canvas.jpg');

pano = MovingDLT(img1,canvas,Point1,TP1);
imshow(pano);
pano = MovingDLT(img4,pano,Point4,TP4);
figure;imshow(pano);
pano = MovingDLT(img7,pano,Point7,TP7);
figure;imshow(pano);