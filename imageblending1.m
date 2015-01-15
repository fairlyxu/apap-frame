function mosaic = imageblending1(warped_img1,warped_img2)
mass = ~isnan(warped_img1) + ~isnan(warped_img2) ;
im1_(isnan(warped_img1)) = 0 ;
im2_(isnan(warped_img2)) = 0 ;
mosaic = (im1_ + im2_) ./ mass ;