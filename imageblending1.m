function output_canvas = imageBlending1(warped_img1,warped_img2)
    
    w1 = imfill(im2bw(uint8(warped_img1), 0),'holes');
    w2 = imfill(im2bw(uint8(warped_img2), 0),'holes');
    
    w1 = mat2gray(w1);
    w2 = mat2gray(w2);

    warped_img1 = double(warped_img1);
    warped_img2 = double(warped_img2);

    
    %% �����ں�
    output_canvas(:,:,1) = ((warped_img1(:,:,1) )+(warped_img2(:,:,1))) ;
    output_canvas(:,:,2) = ((warped_img1(:,:,2) )+(warped_img2(:,:,2) )) ;
    output_canvas(:,:,3) = ((warped_img1(:,:,3) )+(warped_img2(:,:,3) )) ;
    output_canvas = uint8(output_canvas);
    