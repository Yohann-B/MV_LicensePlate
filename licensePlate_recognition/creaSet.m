function set = creaSet()


set = imresize(imread('MySet\usable\0_1.jpg'),[62,40]);

set = cat(3,set,imresize(imread('MySet\usable\1_1.jpg'),[62,40]));
set = cat(3,set,imresize(imread('MySet\usable\2_1.jpg'),[62,40]));
set = cat(3,set,imresize(imread('MySet\usable\3_1.jpg'),[62,40]));
set = cat(3,set,imresize(imread('MySet\usable\4_1.jpg'),[62,40]));
set = cat(3,set,imresize(imread('MySet\usable\5_1.jpg'),[62,40]));
set = cat(3,set,imresize(imread('MySet\usable\6_1.jpg'),[62,40]));
set = cat(3,set,imresize(imread('MySet\usable\7_1.jpg'),[62,40]));
set = cat(3,set,imresize(imread('MySet\usable\8_1.jpg'),[62,40]));
set = cat(3,set,imresize(imread('MySet\usable\9_1.jpg'),[62,40]));
set = cat(3,set,imresize(imread('MySet\usable\A_1.jpg'),[62,40]));
set = cat(3,set,imresize(imread('MySet\usable\B_1.jpg'),[62,40]));
set = cat(3,set,imresize(imread('MySet\usable\C_1.jpg'),[62,40]));
set = cat(3,set,imresize(imread('MySet\usable\D_1.jpg'),[62,40]));
set = cat(3,set,imresize(imread('MySet\usable\E_1.jpg'),[62,40]));
set = cat(3,set,imresize(imread('MySet\usable\F_1.jpg'),[62,40]));
set = cat(3,set,imresize(imread('MySet\usable\G_1.jpg'),[62,40]));
set = cat(3,set,imresize(imread('MySet\usable\H_1.jpg'),[62,40]));
set = cat(3,set,imresize(imread('MySet\usable\I_1.jpg'),[62,40]));
set = cat(3,set,imresize(imread('MySet\usable\J_1.jpg'),[62,40]));
set = cat(3,set,imresize(imread('MySet\usable\K_1.jpg'),[62,40]));
set = cat(3,set,imresize(imread('MySet\usable\L_1.jpg'),[62,40]));
set = cat(3,set,imresize(imread('MySet\usable\M_1.jpg'),[62,40]));
set = cat(3,set,imresize(imread('MySet\usable\N_1.jpg'),[62,40]));
set = cat(3,set,imresize(imread('MySet\usable\O_1.jpg'),[62,40]));
set = cat(3,set,imresize(imread('MySet\usable\P_1.jpg'),[62,40]));
set = cat(3,set,imresize(imread('MySet\usable\Q_1.jpg'),[62,40]));
set = cat(3,set,imresize(imread('MySet\usable\R_1.jpg'),[62,40]));
set = cat(3,set,imresize(imread('MySet\usable\S_1.jpg'),[62,40]));
set = cat(3,set,imresize(imread('MySet\usable\T_1.jpg'),[62,40]));
set = cat(3,set,imresize(imread('MySet\usable\U_1.jpg'),[62,40]));
set = cat(3,set,imresize(imread('MySet\usable\V_1.jpg'),[62,40]));
set = cat(3,set,imresize(imread('MySet\usable\W_1.jpg'),[62,40]));
set = cat(3,set,imresize(imread('MySet\usable\X_1.jpg'),[62,40]));
set = cat(3,set,imresize(imread('MySet\usable\Y_1.jpg'),[62,40]));
set = cat(3,set,imresize(imread('MySet\usable\Z_1.jpg'),[62,40]));

% jpg to binary
level=graythresh(set(:,:,1)); % intensity is the same in all pictures

for i = 1:36
    set(:,:,i) = im2bw(set(:,:,i), level);
end