%% Create 24-bit RGB from 1-bit pattern images
% 
% Main file for creating the 24 bit depth RGB bmp file from 1-bit pattern
% images stored as individual bmp files

% Andres Marrugo, 2019

% The 1-bit pattern images were generated and stored in a folder:
% 
% input_pattern_images/
% ├── bitPlane_00.bmp
% ├── bitPlane_01.bmp
% ├── bitPlane_02.bmp
% ├── bitPlane_03.bmp
% ├── bitPlane_04.bmp
% ├── bitPlane_05.bmp
% ├── bitPlane_06.bmp
% ├── bitPlane_07.bmp
% ├── bitPlane_08.bmp
% └── bitPlane_09.bmp

% We call the createRGBPatternImage function with the basename for the
% images and folder path
if isunix
    rgb_im = createRGBPatternImage('bitPlane_', 'input_pattern_images/');
else
    rgb_im = createRGBPatternImage('bitPlane_', 'input_pattern_images\');
end

% The pattern images are stored in the RGB image with the following order:
% 
% G0, G1, ..., G7, R0, ..., R7, B0, ..., B7
% 
% The output image is stored in rgb_im and by default it is written to
% out.bmp

