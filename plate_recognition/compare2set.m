function sum_rate = compare2set(myChar, mySet)

% This function compare one binary picture with a set of several chars in
% our set. To pictures compared must have the same size.

% It returns the similitude and the difference between the two pictures as 
% a percentage according to the following idea.

% We first process on every pixel of the picture we want to check. The ref
% is oa picture of the set.
%   - if a pixel on the picture is 0:
%       - if the pixel on the set is 0: do nothing.
%       - if the pixel on the set is 1: increment a diff counter.
%   - if a pixel on the picture is 1:
%       - if the pixel on the set is 0: increment a diff counter.
%       - if the pixel on the set is 1: increment a same counter.

% We want boh picture to have the same size. changing the size of the
% picture to the sample or the sample to the picture does not change in
% terms of result quality since incertitude will be the same in both cases.
% Then we are going to change the size of the picture to the sample, so
% that we dont have to change the size of each sample off the set.
resizedChar=myResize(myChar, mySet(:,:,1));

% The first goal is to know how much pixels are different and ho much are
% both equal to 1.

r_pic = size(resizedChar,1);
c_pic = size(resizedChar,2);

tot_sum = [0 0];
for n=1:36 % For each sample of the set from 0 to Z.
    same = 0;
    diff = 0;

    for i = 1:r_pic
        for j = 1:c_pic
            % Comparing each pixel
            if resizedChar(i,j)==0
                if mySet(i,j,n)==1
                    diff = diff + 1;
                end
            else
                if mySet(i,j,n)==0
                    diff = diff + 1;
                else
                    same = same + 1;
                end
            end 
        end
    end
    % saving the value of the two incremented values using cat.
    tot_sum = cat(1, tot_sum, [same diff]);
end

% now we have the number of time the pixels are the same and the number of
% time the pixels are different. We need to transform that into
% rates (between 0 and 1). 1 mean that white pixels in both image are
% totally at the same coordinates for the "same" value.

pixTot = r_pic*c_pic;
sum_rate=zeros(37, 2);

for n = 1:37
    sum_rate(n,1)=tot_sum(n,1)/pixTot;
    sum_rate(n,2)=tot_sum(n,2)/pixTot;
end
   