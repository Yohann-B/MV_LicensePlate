clc; clear; close all;
img = 'seg7.png';
way = 'car\';
figure(10);
imshow([way img]);

car = imread([way img]);

myplate=selectPlate(car);

 
