% Discrete Wavelet Transform (DWT)
% Author: Pyansu Nahak, BT22ECE131
clear;
close all;
clc;

% Read and preprocess image
img = imread('input.png');
figure;
imshow(img);
title('Original Image');

if size(img, 3) == 3
    img = rgb2gray(img);
end

img = im2double(img);

% Ensure image has even dimensions
[rows, cols] = size(img);
if mod(rows, 2) ~= 0
    img(end+1, :) = img(end, :);  % Duplicate last row
end
if mod(cols, 2) ~= 0
    img(:, end+1) = img(:, end);  % Duplicate last column
end

% Perform custom Haar DWT
[LL, LH, HL, HH] = haar_dwt2(img);

% Display subbands
figure;
subplot(2,2,1); imshow(LL, []); title('Approximation (LL)');
subplot(2,2,2); imshow(LH, []); title('Horizontal Detail (LH)');
subplot(2,2,3); imshow(HL, []); title('Vertical Detail (HL)');
subplot(2,2,4); imshow(HH, []); title('Diagonal Detail (HH)');

% Perform inverse Haar DWT
reconstructed_img = haar_idwt2(LL, LH, HL, HH);

% Display reconstructed image
figure;
imshow(reconstructed_img, []);
title('Reconstructed Image from DWT');

%% Custom Haar DWT function
function [LL, LH, HL, HH] = haar_dwt2(img)
    % Process rows
    a = img(:,1:2:end);  % Even columns
    b = img(:,2:2:end);  % Odd columns
    L = (a + b) / sqrt(2);
    H = (a - b) / sqrt(2);

    % Process columns
    a = L(1:2:end,:); b = L(2:2:end,:);
    LL = (a + b) / sqrt(2);
    HL = (a - b) / sqrt(2);

    a = H(1:2:end,:); b = H(2:2:end,:);
    LH = (a + b) / sqrt(2);
    HH = (a - b) / sqrt(2);
end

%% Custom Inverse Haar DWT function
function img = haar_idwt2(LL, LH, HL, HH)
    % Reconstruct L and H
    a = (LL + HL)/sqrt(2);
    b = (LL - HL)/sqrt(2);
    L = zeros(size(a,1)*2, size(a,2));
    L(1:2:end, :) = a;
    L(2:2:end, :) = b;

    a = (LH + HH)/sqrt(2);
    b = (LH - HH)/sqrt(2);
    H = zeros(size(a,1)*2, size(a,2));
    H(1:2:end, :) = a;
    H(2:2:end, :) = b;

    % Reconstruct full image
    a = (L + H)/sqrt(2);
    b = (L - H)/sqrt(2);
    img = zeros(size(a,1), size(a,2)*2);
    img(:,1:2:end) = a;
    img(:,2:2:end) = b;
end
