function out = myResize(toResize, reference)
% This function is using two pictures. The first one is getting resized to
% the second one and sended in out

r_ref=size(reference, 1);
c_ref=size(reference, 2);

out=imresize(toResize, [r_ref c_ref]);