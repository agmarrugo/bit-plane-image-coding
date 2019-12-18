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

numBitPlanes = numel(listFiles);

% number of RGB files needed
num_rgb = ceil(numBitPlanes/24);

switch num_rgb
    case 1
        bits_per_rgb = numBitPlanes;
    case 2
        bits_per_rgb = [23 numBitPlanes-23];
    case 3
        bits_per_rgb = [23 23 numBitPlanes-23];
end
    


if isempty(listFiles),
    error('No input files were provided');
end

% listFiles(1).name
% numel(listFiles)

rgb = uint8(zeros(height,width,3,num_rgb));
bit_values = uint8([1 2 4 8 16 32 64 128]);
bit_values = [bit_values bit_values bit_values];

% For writing the order of patterns
fileID = fopen('out_rgb_order.txt','w');

kk = 1;

for q=1:num_rgb,
    fprintf(fileID, '## Flash index %d ##\n',q-1);
    for k = 1:bits_per_rgb(q),
        bitPlaneImage = uint8(im2bw(imread(strcat(Path,listFiles(kk).name))));
        
        if k < 9,
            rgb(:,:,2,q) = rgb(:,:,2) + bitPlaneImage.*bit_values(k);
            fprintf(fileID, 'G%d <- \t %s  \n',k-1, listFiles(kk).name);
            
        elseif k < 17,
            rgb(:,:,1,q) = rgb(:,:,1) + bitPlaneImage.*bit_values(k);
            fprintf(fileID, 'R%d <- \t %s \n', k-9, listFiles(kk).name);
            
        else
            rgb(:,:,3,q) = rgb(:,:,3) + bitPlaneImage.*bit_values(k);
            fprintf(fileID, 'B%d <- \t %s \n', k-17, listFiles(kk).name);
            
        end
        
    end
    
    kk = kk+1;
    
end

fclose(fileID);

if writeFile,
    for k = 1:num_rgb,
        out_name = sprintf('out%d.bmp', k);
        imwrite(rgb(:,:,:,k),out_name);
        fprintf('\nRGB file written to %s\n',out_name);
    end
end


end

