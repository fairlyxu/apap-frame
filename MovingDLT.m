function linear_mdlt = MovingDLT(img,canvas,Point,TP)

%-------------------------
% User defined parameters.
%-------------------------
% Global model specific function handlers.
clear global;
global fitfn resfn degenfn psize numpar
fitfn = 'homography_fit';
resfn = 'homography_res';
degenfn = 'homography_degen';
psize   = 4;
numpar  = 9;

M     = 500;  % Number of hypotheses for RANSAC.
thr   = 0.1;  % RANSAC threshold.

C1 = 200; % Resolution/grid-size for the mapping function in MDLT (C1 x C2).
C2 = 200;


%----------------------
% Reading img and some other params.
%----------------------
img1 = canvas;
img2 = img;

data_orig(4,:) = Point(:,1)';
data_orig(5,:) = Point(:,2)';
data_orig(3,:) = 1;
data_orig(1,:) = TP(:,1)';
data_orig(2,:) = TP(:,2)';
data_orig(6,:) = 1;

[ dat_norm_img1,T1 ] = normalise2dpts(data_orig(1:3,:));
[ dat_norm_img2,T2 ] = normalise2dpts(data_orig(4:6,:));
data_norm = [ dat_norm_img1 ; dat_norm_img2 ];

Kp = Point;

cw = size(img1,2);
ch = size(img1,1);
off = [ 1 - min([1 size(img1,2)]) + 1 ; 1 - min([1 size(img1,1)])];

gamma = 0.01; % Normalizer for Moving DLT. (0.0015-0.1 are usually good numbers).
sigma = 10;  % Bandwidth for Moving DLT. (Between 8-12 are good numbers).   
scale = 1;    % Scale of input images (maybe for large images you would like to use a smaller scale).

[ h,A,D1,D2 ] = feval(fitfn, data_norm);
%-----------------------
% Global homography (H).
%-----------------------
fprintf('DLT (projective transform) on inliers\n');
% Refine homography using DLT on inliers.
fprintf('> Refining homography (H) using DLT...');tic;
[ h,A,D1,D2 ] = feval(fitfn,data_norm);
Hg = T2\(reshape(h,3,3)*T1);
fprintf('done (%fs)\n',toc);

%----------------------------------------------------
% Obtaining size of canvas (using global Homography).
%----------------------------------------------------
fprintf('Canvas size and offset (using global Homography)\n');
fprintf('> Getting canvas size...');tic;
% Map four corners of the right image.
TL = Hg\[1;1;1];
TL = round([ TL(1)/TL(3) ; TL(2)/TL(3) ]);
BL = Hg\[1;size(img2,1);1];
BL = round([ BL(1)/BL(3) ; BL(2)/BL(3) ]);
TR = Hg\[size(img2,2);1;1];
TR = round([ TR(1)/TR(3) ; TR(2)/TR(3) ]);
BR = Hg\[size(img2,2);size(img2,1);1];
BR = round([ BR(1)/BR(3) ; BR(2)/BR(3) ]);

% Canvas size.
cw = max([1 size(img1,2) TL(1) BL(1) TR(1) BR(1)]) - min([1 size(img1,2) TL(1) BL(1) TR(1) BR(1)]) + 1;
ch = max([1 size(img1,1) TL(2) BL(2) TR(2) BR(2)]) - min([1 size(img1,1) TL(2) BL(2) TR(2) BR(2)]) + 1;
fprintf('done (%fs)\n',toc);

% Offset for left image.
fprintf('> Getting offset...');tic;
off = [ 1 - min([1 size(img1,2) TL(1) BL(1) TR(1) BR(1)]) + 1 ; 1 - min([1 size(img1,1) TL(2) BL(2) TR(2) BR(2)]) + 1 ];
fprintf('done (%fs)\n',toc);

% %--------------------------------------------
% % Image stitching with global homography (H).
% %--------------------------------------------
% % Warping source image with global homography 
% fprintf('Image stitching with global homography (H) and linear blending\n');
% fprintf('> Warping images by global homography...');tic;
% warped_img1 = uint8(zeros(ch,cw,3));
% warped_img1(off(2):(off(2)+size(img1,1)-1),off(1):(off(1)+size(img1,2)-1),:) = img1;
% warped_img2 = imagewarping(double(ch),double(cw),double(img2),Hg,double(off));
% warped_img2 = reshape(uint8(warped_img2),size(warped_img2,1),size(warped_img2,2)/3,3);
% fprintf('done (%fs)\n',toc);
% 
% % Blending images by simple average (linear blending)
% fprintf('  Homography linear image blending (averaging)...');tic;
% linear_hom = imageblending(warped_img1,warped_img2);
% fprintf('done (%fs)\n',toc);
% figure;
% imshow(linear_hom);
% title('Image Stitching with global homography');

%-------------------------
% Moving DLT (projective).
%-------------------------
fprintf('As-Projective-As-Possible Moving DLT on inliers\n');

% Image keypoints coordinates.
Kp = [data_orig(1,:)' data_orig(2,:)'];

% Generating mesh for MDLT.
fprintf('> Generating mesh for MDLT...');tic;
[ X,Y ] = meshgrid(linspace(1,cw,C1),linspace(1,ch,C2));
fprintf('done (%fs)\n',toc);

% Mesh (cells) vertices' coordinates.
Mv = [X(:)-off(1), Y(:)-off(2)];

% Perform Moving DLT
fprintf('  Moving DLT main loop...');tic;
Hmdlt = zeros(size(Mv,1),9);
parfor i=1:size(Mv,1)
    
    % Obtain kernel    
    Gki = exp(-pdist2(Mv(i,:),Kp)./sigma^2);   

    % Capping/offsetting kernel
    Wi = max(gamma,Gki); 
    
    % This function receives W and A and obtains the least significant 
    % right singular vector of W*A by means of SVD on WA (Weighted SVD).
    v = wsvd(Wi,A);
    h = reshape(v,3,3)';        
    
    % De-condition
    h = D2\h*D1;

    % De-normalize
    h = T2\h*T1;
    
    Hmdlt(i,:) = h(:);
end
fprintf('done (%fs)\n',toc);

%---------------------------------
% Image stitching with Moving DLT.
%---------------------------------
fprintf('As-Projective-As-Possible Image stitching with Moving DLT and linear blending\n');
% Warping images with Moving DLT.
fprintf('> Warping images with Moving DLT...');tic;
warped_img1 = uint8(zeros(ch,cw,3));
warped_img1(off(2):(off(2)+size(img1,1)-1),off(1):(off(1)+size(img1,2)-1),:) = img1;
[warped_img2] = imagewarping(double(ch),double(cw),double(img2),Hmdlt,double(off),X(1,:),Y(:,1)');
warped_img2 = reshape(uint8(warped_img2),size(warped_img2,1),size(warped_img2,2)/3,3);


%Blending images by averaging (linear blending)
fprintf('  Moving DLT linear image blending (averaging)...');tic;
linear_mdlt = imageblending(warped_img1,warped_img2);
 
% imshow(linear_mdlt);
 
fprintf('done (%fs)\n',toc);
