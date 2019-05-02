function plate = selectPlate(car)

% This function take an grayscale picture and return the grayscale image of
% the license plate in it. 
% It proceeds to an auto-theshold and to a laplacian filter.

%Note: Same scheme as selectChar.m, but the selection's conditions change. 

%% STEP 1: Processing on the picture
show = 1; % 1 to show steps, 0 to hide them.
register = 1; % 1 to register in the current folder, 0 if not wanted.

level=graythresh(car);
th=im2bw(car,level);

if show == 1
    figure(1);
    imshow(th);
end

if register == 1
    imwrite(th, 'myth_car.jpg');
end

blured=imfilter(th,fspecial('average',3),'replicate');

if register == 1
    imwrite(blured, 'myblurred_car.jpg');
end

shapes = imfilter(blured,fspecial('laplacian',0.2), 'replicate');

if show == 1
    figure(2);
    imshow(shapes);
end

if register == 1
    imwrite(shapes, 'myshaped_car.jpg');
end

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

% Now we need to check how much results we have find to know what to do.
% we proceed like this:
%   - 0 results (1 el in the 'results' array): no plate found. Send an
%   error message with advices.
%   - 1 results (2 el in the 'results' array): return the cropped 'car'
%   around the corresponding 'BoundingBox' rectangle.
%   - More than 1 result: checking regions inside each region found as
%   result (which can be, as instance, letters for the plate). we return
%   the area with the most regions inside it.

msg='No plate found. Maybe it is too small, too big, or its sides are not clear enough.';

if results<2
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
    cropped = imcrop(shapes, regions(results(2)).BoundingBox);
    test = regionprops(cropped,'BoundingBox');
    if numel(test) >=5
        fresult=results(1,2);
    else
        error(msg);
    end
end

%% STEP 3: Displaying boundary boxes
% To understand a bit more the script procession and to debbug, we want to
% be able to see the area that match the conditions on the picture.
% To do so, we display the boundary boxes as rectangles on the picture.
if show == 1
    figure('Name', 'BoundingBox');
    imshow(shapes);
    for i=2:numResults
        rectangle('Position', regions(results(1,i)).BoundingBox, 'EdgeColor', 'r');
    end
end

%% STEP 4: Plate extraction
% Now that we got the plate selected, we crop the picture at the right
% location, we save the new picture and we display it.

plate=imcrop(car, regions(fresult).BoundingBox);

if show == 1
    figure('Name','Plate');
    imshow(plate);
end

if register == 1
    imwrite(plate,'myplate.jpg');
end
