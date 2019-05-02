clc; clear; close all; 

% We want with this fucntion to proceed to a threshold selection of an
% object in a picture. By giving two threshold values, the user should be
% able to select object(s) according to pixel values without proceeding to
% basic image processing.

% This function provide:
%   - A gaussian f  iltering to remove noise on the picture.
%   - A laplacian high-pass filter to get shapes of the objects.
%   - The threshold process.
%   - A sum of the threshold result and the shape result, to cancel the
%   effect of the gaussian filter on the edge of shapes.

%% STEP 1: Settings
image_name = 'brain.jpg';
way = 'figures\';
image = imread([way image_name]);
image=rgb2gray(image);
figure('Name', 'Image processed');
imshow(image);

r=size(image,1);
c=size(image,2);

maskSub=0; % Set to 1 to activate the mask subtraction
seed = seed(7, [4 4], 'circle', 3);
%% STEP 2: Analysis
% Here we check the threshold values.
figure('Name', 'Histogram');
imhist(image);

th1 = 150;
th2 = 250;

%% STEP 3: Blurring
% Here we proceed to a gaussian filtering to blurr the initial picture.

blurred=imgaussfilt(image, 2);
figure('Name', 'Blurred picture');
imshow(blurred);

%% STEP 4: Threshold
% We proceed the threshold selection

select = selectThresholdIm(image, th1, th2);
select1 = imfill(select);
figure('Name', 'Threshold selection');
subplot(211); imshow(select);
subplot(212); imshow(select1);


%% STEP 5: Final result
% We proceed to the opening

% This is a prototype to change the size of the seed automatively.
%conditions = [c*0.01, r*0.01, c*0.99, r*0.99];
%radius = sizeSeed(select1, conditions, 0.05);

%seed = strel('disk', radius);

final=imdilate(imerode(select1, seed),seed);

% If the reversed option to substract is wanted:
if maskSub==1
    final_neg = negativeIm(final);
    final = image - final_neg;
    imshow(final_neg);
end

figure('Name', 'Selection result');
imshow(final);

% %% STEP 6: Single object selection
% % After cleaning and sorting the raw image, we want to give the user the
% % posibility to select one of the remaining objects
% % To do this we will use region growing, wich will work really nicely with
% % the first work. 
% 
% figure('Name', 'Select a region');
% imshow(image);
% hold all;
% finalselect=regionGrowing(final);
% 
% figure('Name', 'Selected object'); imshow(finalselect);

