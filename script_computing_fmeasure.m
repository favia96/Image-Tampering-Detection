clear all; close all;

% Open the example ground truth tampering map
map_gt=double(imread('dev_0011_gt.bmp'));
subplot(1,2,1); imshow(map_gt);

% Simulate an estimated tampering map
map_est = double(imread('dev_0011.bmp'));
subplot(1,2,2); imshow(map_est);

% Compute F-measure

[F] = f_measure(map_gt,map_est);




