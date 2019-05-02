close all; clc; clear;
%% STEP 1: Processing on the picture
car=imread('pictures\car\seg3.jpg');
level=graythresh(car);
th=im2bw(car,level);
figure(1);
imshow(th);

blured=imfilter(th,fspecial('average',3),'replicate');

shapes = imfilter(blured,fspecial('laplacian',0.2), 'replicate');
figure(2);
imshow(shapes);

%% Step 2: Plate searching

regions=regionprops(shapes, 'BoundingBox', 'Image', 'Extrema');% Choosen region char

numobj=numel(regions);% Number of regions in the picture

results = 0;
delta = 0.20; % 10% tolerance for the y/x calculation
conditionMin = 0.33 - delta;
conditionMax = 0.33 + delta;

init = regions(1).BoundingBox;
for k = 2 : numobj
    init = cat(3,init,regions(k).BoundingBox);
end
% Init is now a 1 by 4 by x 3D-array, where x is the number of
% regions found in the picture.

corners = regions(1).Extrema;
for k = 2 : numobj
    corners = cat(3,corners,regions(k).Extrema);
end
% Corners is now a 8 by 2 by x 3D-array, where x is the number of regions
% found in the picture.

for k = 1 : numobj
    % Conditions:
    %   - Height/width < 1 (at least) and:
    %       o > (condition - tolerance)
    %       o < (condition + tolerance)
    %   - Height should not be too big or too small
    %   - Width should not be too big or too small
    
    % It could be interesting to get some percentage of the picture size,
    % so that conditions may be more strict. Here we must open the interval
    % by growing the value 'delta' to admit more possibilities.
    
    if ( init(1,4,k)/init(1,3,k) ) > conditionMin && ...
            ( init(1,4,k)/init(1,3,k) ) < conditionMax ...
            && (init(1,4,k)) >= 20 && (init(1,3,k) >= 60) ...
            && (init(1,4,k)) <= 150 && (init(1,3,k) <= 300)
        % For each bounding box that match our conditions we add it's index
        % to the tab result along the 2nd dimension. 
        % After this we have to forget about the result(1,1), which is used
        % to initiate the concatenation tab. Maybe it is possible to
        % improve this to have a nicer code.
        % eg: results = [0 3 21 82 160 ...]
        results=cat(2,results,k); 
    end
end

% Rectangle test:
% There are several way to test if we can have the shape of a rectangle.
% We will use the fact that 2 opposite sides of it are paralel to each
% other.

numResults = size(results, 2);

% For each region we need to:
%   - Calculate the coef of each side;
%   - Compare each side to each other to see if they are parallele.
% coef=(y2-y1)/(x2-x1)
rectangles = 0;
delta=1;
for i= 2 : numobj
    topLeft = corners(1,:,i);
    topRight = corners(2,:,i);
    rightTop = corners(3,:,i);
    rightBottom = corners(4,:,i);
    bottomRight = corners(5,:,i);
    bottomLeft = corners(6,:,i);
    leftBottom = corners(7,:,i);
    leftTop = corners(8,:,i);
    
    horizontalUp = ...
    (topRight(1,2)-topLeft(1,2))/(topRight(1,1)-topLeft(1,1));
    horizontalBottom = ...
    (bottomRight(1,2)-bottomLeft(1,2))/(bottomRight(1,1)-bottomLeft(1,1));
    verticalLeft = ...
    (leftTop(1,2)-leftBottom(1,2))/(leftTop(1,1)-leftBottom(1,1));
    verticalRight = ...
    (rightTop(1,2)-rightBottom(1,2))/(rightTop(1,1)-rightBottom(1,1));
    
    horizontalCondMin = horizontalUp - horizontalUp*delta;
    horizontalCondMax = horizontalUp + horizontalUp*delta;
    verticalCondMin = verticalLeft - verticalLeft*delta;
    verticalCondMax = verticalLeft + verticalLeft*delta;
    
    if horizontalBottom >= horizontalCondMin &&...
       horizontalBottom <= horizontalCondMax &&...
       verticalRight >= verticalCondMin &&...
       verticalRight <= verticalCondMax 
        rectangles = cat(2, rectangles, i);
    end
end

figure('Name', 'rectangles');
imshow(shapes);
numRect = numel(rectangles);

for i = 2 : numRect
    rectangle('Posistion', regions(rectangles(i)).BoundingBox, 'EdgeColor', 'b');
end

% Now we need to check how much results we have find to know what to do.
% we proceed like this:
%   - 0 results (1 el in the 'results' array): no plate found. Send an
%   error message with advices.
%   - 1 results (2 el in the 'results' array): return the cropped 'car'
%   around the corresponding 'BoundingBox' rectangle.
%   - More than 1 result: checking regions inside each region found as
%   result (which can be, as instance, letters for the plate). we return
%   the area with the most regions inside it.

if results<2
    msg='No plate found. Maybe it is too small, too big, or its sides are not clear enough.';
    error(msg);
    
elseif numResults > 2
    numReg = 0;
    
    % We will proceed on each image successively 
    for i=2:numResults
        cropped = imcrop(shapes, regions(results(i)).BoundingBox);
        propCrop = regionprops(cropped, 'BoundingBox');
        numReg = cat(2, numReg, numel(propCrop));
    end
    
    % Now need to associate numbers of units to each region and then
    % finding which one is the biggest to save it.
    
    index=2; % Used to get the index of the area with the most regions.
    comp=numReg(1,2); % Used to compare number of regions in the area.
    
    % The first area's charactteristics are loaded already so we can start
    % with the other one directly (starting from 3 instead of 2):
    for j=3:numResults % For each area after the first one:
        if comp < numReg(1,j) % Checking if the number is bigger.
            comp = numReg(1,j); % If so the number is the new challenger.
            index=j;% And his index is saved for now
        end
    end
    
    % Now the best value is the element indexed "index" in numResults
    fresult=results(1, index);

else % 1 region found:
    fresult=results(1,2);
end

%% STEP 3: Displaying boundary boxes
% To understand a bit more the script procession and to debbug, we want to
% be able to see the area that match the conditions on the picture.
% To do so, we display the boundary boxes as rectangles on the picture.
figure('Name', 'BoundingBox');
imshow(shapes);
for i=2:numResults
    rectangle('Position', regions(results(1,i)).BoundingBox, 'EdgeColor', 'r');
end

%% STEP 4: Plate extraction
% Now that we got the plate selected, we crop the picture at the right
% location, we save the new picture and we display it.

plate=imcrop(car, regions(fresult).BoundingBox);
figure('Name','Plate');
imshow(plate);
imwrite(plate, 'myplate4.jpg');
