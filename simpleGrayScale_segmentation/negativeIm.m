function [ negativedIm ] = negativeIm(inputIm)
% This function process an inverted linear transformation of the pixel
% value. That means that a pixel with the value 0 (max dark) will become a 
% pixel with value 255 (full white).
    negativedIm=zeros(256,256);
    
% The implemented function work on each pixel, so we have to work on all of
% them:
    r=size(inputIm,1);
    c=size(inputIm,2);
    
% We work on each pixel of the picture:

    for i= 1:r
        for j= 1:c
            negativedIm(i,j) = 255 - inputIm(i,j);
        end
    end
end

