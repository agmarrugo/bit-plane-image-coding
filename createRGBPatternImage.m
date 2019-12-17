function rgb = createRGBPatternImage(Basename, Path, writeFile)
% CREATERGBPATTERNIMAGE Create a 24-bit image from 1-bit pattern images
%   This function facilitates the manual process of preparing the 
%   24 bit depth RGB image from single 1 bit pattern images
%   to be loaded in the DLPC350 LightCrafter.
% 
%   Inputs:
%   Basename:   base filename of the patterns, e.g., bitPLane_ (assumes bmp)
%   Path:       path to files
%   writeFile:  Default is true so that it writes the output at out.bmp
% 
%   Output:
%   rgb:        the output 24-bit depth rgb image.
% 
% Andres Marrugo, 2019

% From the documentation:
% 
% The function takes all the input files and bit weights the input images 
% according to the bit-plane position requested. Images added at bit 
% position B0 to B7 show blue, bit position G0 to G7 show red, and 
% bit position R0 to R7 show green. This is due to the DLPC350 display 
% order being GRB (see table 2-69, Pattern Number Mapping, in the DLPC350 
% Programmer's Guide), whereas BMP images are stored as RGB. For each color, 
% bit position 0 is the least significant bit, while bit position 7 is 
% the most significant bit.

% TODO: Need to create additional image if there are more than 24 bit plane
% images.

if nargin<3,
    writeFile = true;
end

if nargin<2,
    Path = '';
end

% LightCrafter pattern image size
width  = 912;
height = 1140;

listFiles = dir(strcat(Path,Basename,'*'));

if isempty(listFiles),
    error('No input files were provided');
end

% listFiles(1).name
% numel(listFiles)

rgb = uint8(zeros(height,width,3));
bit_values = uint8([1 2 4 8 16 32 64 128]);
bit_values = [bit_values bit_values bit_values];

% For writing the order of patterns
fileID = fopen('out_rgb_order.txt','w');

for k = 1:numel(listFiles),
    bitPlaneImage = uint8(im2bw(imread(strcat(Path,listFiles(k).name))));
    
    if k < 9,
        rgb(:,:,2) = rgb(:,:,2) + bitPlaneImage.*bit_values(k); 
        fprintf(fileID, 'G%d <- \t %s  \n',k-1, listFiles(k).name);

    elseif k < 17,
        rgb(:,:,1) = rgb(:,:,1) + bitPlaneImage.*bit_values(k);
        fprintf(fileID, 'R%d <- \t %s \n', k-9, listFiles(k).name);
        
    else
        rgb(:,:,3) = rgb(:,:,3) + bitPlaneImage.*bit_values(k);
        fprintf(fileID, 'B%d <- \t %s \n', k-17, listFiles(k).name);
        
    end
    
end

fclose(fileID);

if writeFile,
    imwrite(rgb,'out.bmp');
    fprintf('\nRGB file written to out.bmp\n');
end


end

