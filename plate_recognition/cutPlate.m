function out = cutPlate (in)
% cutPlate is a function that return a x by 4 array countaining rectangles
% of each char in the plate.
% It must have a picture of a license plate as an argument.

plate=in;
show = 1;

r = size(plate, 1);
c = size(plate, 2);

%% STEP 1: Processing on the picture
% There we do some basic processing to be able to work on the picture.
plate = rgb2gray(plate); % Grayscale
level=graythresh(plate);  
th=im2bw(plate,level); % Binary
if show==1
    figure(1);
    imshow(th);
end

shapes=imfilter(th, fspecial('laplacian', 0.2), 'replicate'); % HP filter
if show == 1
    figure(2);
    imshow(shapes);
end

%% STEP 2: Char searching
% Here we are going to process several filters on the regions we find:
%   - The first one is a filter regarding the size and the proportionnality
%   between height and width (those car are not really sharp to prevent the
%   loss of information).
%   - The second one is a filter regarding the similitude between the size
%   of each region:
%       o We look at the surface of the Bounding Box to count how much are
%       the same
%       o We then take the one that we see the most. The first filter
%       prevent the noise to interfere, since those little regions that can
%       easily be close (in term of surface) to each other are not choosen 
%       in this process.

% Region selection
carac = regionprops(shapes, 'BoundingBox', 'Image');
numObj=numel(carac);

% To simplify a bit the writing of the code, we use init as a temporary
% memory. Basicely, it replace carac.BoundingBox:
init = carac(1).BoundingBox;
for k = 2 : numObj
    init = cat(3,init,carac(k).BoundingBox);
end

% Displaying all the regions founded in the picture:
if show == 1
    figure (3);
    imshow(shapes);
    for i=1:numObj
        rectangle('Position', carac(i).BoundingBox, 'EdgeColor', 'r');
    end
end

results=0;
delta = 0.50;
conditionMin = 0.5 - delta;
conditionMax = 0.5 + delta;
 
for k = 1 : numObj
    % Conditions:
    %   - width/Height < 1 (at least) and:
    %       o > (condition - tolerance)
    %       o < (condition + tolerance)
    %   - Height should not be too small
    %   - Width should not be too small
    
    if ( init(1,3,k)/init(1,4,k) ) > conditionMin && ...
            ( init(1,3,k)/init(1,4,k) ) < conditionMax && ...
            init(1,3,k) > 0.05*c && init(1,4,k) > 0.05*r
        % For each bounding box that match our conditions we add it's index
        % to the tab result along the 2nd dimension. 
        % After this we have to forget about the result(1,1), which is used
        % to initiate the concatenation tab. Maybe it is possible to
        % improve this to have a nicer code.
        % eg: results = [0 3 21 82 160 ...]
        results=cat(2,results,k); 
    end
end

numRes = size(results,2);

% Displaying regions that passed the test:
if show == 1
    figure (4);imshow(shapes);
    for i=2:numRes
        rectangle('Position', carac(results(i)).BoundingBox, 'EdgeColor', 'r');
    end
end

% Now that we have those prefiltered results, we will proceed to a
% comparison between those elements about their size. That can allow us to
% found those which have the same size.
% Note: A filter that process on position is also really interesting.


var = 0.5; % We tolerate a percentage of the area to be selected.

% The array that will countain the number of regions that are the same: 
sameCarac=zeros(1,numObj);

% We process on 'results' values
for i=2:numRes
    % Calculation of the surface of the preselected region (in 'results'):
    aireMax=init(1,3,results(i))*init(1,4,results(i)) ...
        + var*(init(1,3,results(i))*init(1,4,results(i)));
    aireMin=init(1,3,results(i))*init(1,4,results(i)) ...
        - var*(init(1,3,results(i))*init(1,4,results(i)));
    
    for j=2:numRes
        if i~=j && ... % check that we don't compare with itself
           init(1,3,results(j))*init(1,4,results(j)) < aireMax &&...
           init(1,3,results(j))*init(1,4,results(j)) > aireMin
            % If the surface is include in the interval, then we add 1 to
            % the number of regions that have the 
            sameCarac(1,i)=sameCarac(1,i)+1;
        end
    end
end

% Now we want to get the index of those regions that are the same.
% First we check what is the bigger number:
biggest=sameCarac(1,2); % Used to compare number of regions in the area.
    
% The first area's charactteristics are loaded already so we can start
% with the other one directly (starting from 3 instead of 2):
for i=3:numRes % For each area after the first one:
    if biggest < sameCarac(1,i) % Checking if the number is bigger.
        biggest = sameCarac(1,i); % If so the number is the new challenger.
    end
end

indexMatch=0;
for i=1:numRes
    if sameCarac(1,i)==biggest
        indexMatch=cat(2, indexMatch, i);
    end
end
    

numRes2 = size(indexMatch,2);

% Displaying selected chararacters:
if show == 1
    figure(5);
    imshow(shapes);
    for i=2:numRes2
        rectangle('Position',carac(results(indexMatch(i))).BoundingBox,'EdgeColor','r');
    end
end

% Registering selected characters for output.
% Note: Those are regarding the image inputed (the plate).
out=carac(results(indexMatch(2))).BoundingBox;
for i=3:numRes2
    out=cat(1,out, carac(results(indexMatch(i))).BoundingBox);
end
