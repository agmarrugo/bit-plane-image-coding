%% Create white and black pattern images for LightCrafter 4500

% LightCrafter pattern image size
width  = 912;
height = 1140;

white_pat = im2uint8(ones(height,width));
black_pat = im2uint8(zeros(height,width));

imwrite(white_pat,'pat_white.bmp');
imwrite(black_pat,'pat_black.bmp');