clc; close all; clear;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% STEP 1: Characters extraction %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% This prototype is designed to create a function that can extract the
% characters in an image using regions properties.

% As we first have a function that segment the plate, we will proceed on
% several pictures of license plate extracted with this algorithm.

% What we aim at here is a detection of the characters in the piture. To do
% so, we are going to look at several characteristics:
%   - The size of the characters must be not too big or too small;
%   - The surface of thos characters must be the same for each of the
%   regions;
%   - The origin of the bounding box must be on the same horizontal line.

% The last is facultativ, we will first focus on the previous two. 
% All the job is done by the function cutPlate.m.

% Work perfectly with 1, 3, 4, 7.
% Other plates can be found with the position condition instead of the 
% surface one. I'll implement this condition if I still have time.
 
image = 'myplate_4.jpg';
way = 'pictures\';

plate = imread ([way image]);

chars = cutPlate(plate);
% Chars is now a x by 4 array of values, which contoins each bounding box
% of the characters in the plate's picture.

numChars = size(chars,1);

level=graythresh(plate);
bwPlate = im2bw(plate,level);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% STEP 2: Characters reading %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Here we want to use a function that allow us to compare a standardized
% version of the picture. To do so we are going to cut the picture in
% several areas. Each area will then be averaged to  get a binary value
% regarding its pixels intesity. We then compare the two results and we
% register the similitude percentage.
% We then get an average value with other samples of the same characters,
% for example with different fonts.

% Getting this we are then going to check which letter has the highest
% correspondance rate with our char. We then save this letter. All letters
% of the set have the same height, and the width can vary. The height is
% about 62 pixels, the width from 25 to 80. For the chars we want to read,
% we cannot think about a particular number of pixels, but the scale is
% around
mySet = creaSet();

% Before comparing the characters to the set, we need to know if the
% information in our plate is coded with 1 or with 0. Basically that means
% we need to check if letters are black or white. 


r = size(plate, 1);
c = size(plate, 2);
whitePix=0;
for i = 1:r
    for j= 1:c
        if bwPlate(i,j)==1
            whitePix=whitePix+1;
        end
    end
end

whiteRate=whitePix/(r*c);

if whiteRate < 0.5 % Reversing
    for i = 1:r
        for j = 1:c
            bwPlate(i,j)=1-bwPlate(i,j);
        end
    end
end

    
myRates = zeros(37, 2);
% Letters are black on a white background
        
% Now we are going to compare each rectangle we got with each letter. 
% We want to gather information about their similitudes and their 
% differences:
for i = 1:numChars % for each char
    myChar=imcrop(bwPlate, chars(i,:));
    charRates = compare2set(myChar, mySet);
    myRates = cat(3, myRates, charRates);
end
    
dictionary=['0', '1', '2', '3', '4', '5', '6', '7', '8', '9',...
            'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J',...
            'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T',...
            'U', 'V', 'W', 'X', 'Y', 'Z'];

% Now that we have rates for each sample of the set, we are going to check
% for each letter which one is the weaker and the stronger for each sample:

% We then want to get the index of this one and find the corresponding
% letter in the dictionnary.

letters_index = 0;
letters = 0;
% not mandatory anymore, kept for some checking on the values.
% for m = 2:numChars+1 % For all chars to identify:
%     smaller_same = myRates(2, 1, m);
%     bigger_diff = myRates(2, 2, m);
%     index_same = 2;
%     index_diff = 2;
%     for n = 2:37
%        if smaller_same > myRates(n, 1, m);
%            index_same = n;
%            smaller_same = myRates(n, 1, m);
%        end
%        if bigger_diff < myRates(n, 2, m);
%            index_diff = n;
%            bigger_diff = myRates(n, 2, m);
%        end
%     end
%     
%     % We now need to save the index of the caracteristic values:
%     letters_index = cat(1, letters_index, [index_same-1 index_diff-1]);   
%     letter = dictionary(letters_index(m));
%     letters = cat(2, letters, letter);
% end

results=0;
for m = 2:numChars+1 % For all chars to identify:
    smaller_same = myRates(2, 1, m);
    bigger_diff = myRates(2, 2, m);
    
    index_diff = 2;
    for n = 2:37
       if smaller_same <0.05
           results = cat(1, results, n);
       end
       if bigger_diff < myRates(n, 2, m);
           index_diff = n;
           bigger_diff = myRates(n, 2, m);
       end
    end
    
    numResults=size(results,1);
    if numResults==2 % only one result
        letters_index=cat(1, letters_index, results(2));
    else % If we have 0 or several results
        % We want to use the index of the higher value in the diff tab:
        letters_index=cat(1, letters_index, index_diff-1);
    end
    
    % We now need to save the index of the caracteristic values:
    %letters_index = cat(1, letters_index, [index_same-1 index_diff-1]);   
    letter = dictionary(letters_index(m));
    letters = cat(2, letters, letter);
end

letters
    
% figure('Name', 'myGraph');
% subplot(211); bar(myRates(:,1,6));title('Similitude checking');
% subplot(212); bar(myRates(:,2,6));title('Differences checking');

figure(10);
imshow('C:\Users\Yohann\Pictures\seg7.png');