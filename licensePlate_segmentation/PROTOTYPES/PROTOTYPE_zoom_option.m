clc; clear; close all;
car=imread('seg3.jpg');
car=rgb2gray(car);

r=size(car,1);
c=size(car,2);

level=graythresh(car);
th=im2bw(car,level);
figure(1);
imshow(th);

blured=imfilter(th,fspecial('average',3),'replicate');

shapes = imfilter(blured,fspecial('laplacian',0.2), 'replicate');
figure(2);
imshow(shapes);

%% Region selection

zoom=0;
while 1
I=regionprops(shapes, 'BoundingBox', 'Image');% Choosen region char

numobj=numel(I);% Number of regions in the picture

results = 0;
delta = 0.20; % 10% tolerance for the y/x calculation
conditionMin = 0.33 - delta;
conditionMax = 0.33 + delta;
init = I(1).BoundingBox;

for k = 2 : numobj
    init = cat(3,init,I(k).BoundingBox);
end

% init is now a 1 by 4 by x 3D-array, where x is the number of
% regions found in the picture.

for k = 1 : numobj
    
    if ( init(1,4,k)/init(1,3,k) ) > conditionMin && ...
            ( init(1,4,k)/init(1,3,k) ) < conditionMax ...
            && (init(1,4,k)) >= 33 && (init(1,3,k) >= 100) ...
            && (init(1,4,k)) <= 150 && (init(1,3,k) <= 350)
        results=cat(2,results,k); % On oubliera l'indice 1 plus tard
    end
end

% Now we have in result all index of region inside I that match our
% condition.
if size(results,2) > 1
    break;
end

% Zooming in to see new information before doing the loop again:
X=10;Y=10;
WX=c-2*X;
WY=r-2*Y;
shapes = imcrop(shapes, [X,Y,WX,WY]);

% Resizing the zoomed:
shapes = imresize(shapes, [r c]);
zoom=zoom+1;% used to resize the founded rectangle after
end

% We now want to display it:
numResults = size(results, 2);


% Displaying boundary boxes
imshow(shapes);
for i=2:numResults
    rectangle('Position', I(i).BoundingBox, 'EdgeColor', 'r');
end
%results(1,i)
% Choix entre les régions restantes
fresult=results(1,2);


% Extraction de la plaque:

plate=imcrop(car, I(fresult).BoundingBox);
figure(3);
imshow(plate);

% Image processing on the plate:

%plate = 






