% Watermarking with DWT
% Created by Pyansu Nahak

% Watermarking with DWT
clc;
clear;
close all;

% Read the original image
img = imread('input.png');

% Convert to grayscale if it's a color image
if size(img,3) == 3
    img = rgb2gray(img);
end

% Ensure even dimensions
[rows, cols] = size(img);
if mod(rows,2) ~= 0
    img(end+1,:) = img(end,:);
end
if mod(cols,2) ~= 0
    img(:,end+1) = img(:,end);
end

% Initialize an empty watermark image of the same size as the original
watermark = zeros(size(img));

% Display the empty watermark image and overlay text onto it
figure;
imshow(watermark, []);
hold on;
text(size(img,2)/2, size(img,1)/2, 'PN', 'FontSize', 50, 'Color', 'white', 'FontWeight', 'bold', 'HorizontalAlignment', 'center');

% Capture the frame containing the text
frame = getframe(gca);
watermark = frame2im(frame);

% Convert to grayscale and resize to match half the image
watermark = rgb2gray(watermark);
watermark = imresize(watermark, size(img)/2);
close;

% Apply custom DWT
[LL, LH, HL, HH] = haar_dwt2(double(img));

% Define watermark strength
alpha = 0.6;

% Embed watermark in HH
HH_watermarked = HH + alpha * double(watermark);

% Reconstruct watermarked image
img_watermarked = haar_idwt2(LL, LH, HL, HH_watermarked);
img_watermarked = uint8(img_watermarked);

% Save and display
imwrite(img_watermarked, 'text_watermarked_image.png');
figure;
subplot(1,3,1); imshow(img); title('Original Image');
subplot(1,3,2); imshow(img_watermarked); title('Watermarked Image');
subplot(1,3,3); imshow(watermark, []); title('Text Watermark');

%Watermark Removal Process

% Apply DWT to the watermarked image
[LL2, LH2, HL2, HH2] = haar_dwt2(double(img_watermarked));

% Remove watermark from HH
HH2_cleaned = HH2 - alpha * double(watermark);

% Reconstruct cleaned image
img_cleaned = haar_idwt2(LL2, LH2, HL2, HH2_cleaned);
img_cleaned = uint8(img_cleaned);

% Save and display cleaned image
imwrite(img_cleaned, 'text_watermark_removed.png');
figure;
subplot(1,3,1); imshow(img_watermarked); title('Watermarked Image');
subplot(1,3,2); imshow(HH2_cleaned, []); title('HH after Removal');
subplot(1,3,3); imshow(img_cleaned); title('Watermark Removed');

%Custom Haar DWT Functions

function [LL, LH, HL, HH] = haar_dwt2(img)
    % Row transform
    a = img(:,1:2:end);
    b = img(:,2:2:end);
    L = (a + b) / sqrt(2);
    H = (a - b) / sqrt(2);

    % Column transform
    a = L(1:2:end,:);
    b = L(2:2:end,:);
    LL = (a + b) / sqrt(2);
    HL = (a - b) / sqrt(2);

    a = H(1:2:end,:);
    b = H(2:2:end,:);
    LH = (a + b) / sqrt(2);
    HH = (a - b) / sqrt(2);
end

function img = haar_idwt2(LL, LH, HL, HH)
    % Inverse column transform
    L = zeros(size(LL,1)*2, size(LL,2));
    H = zeros(size(LL,1)*2, size(LL,2));

    L(1:2:end,:) = (LL + HL) / sqrt(2);
    L(2:2:end,:) = (LL - HL) / sqrt(2);

    H(1:2:end,:) = (LH + HH) / sqrt(2);
    H(2:2:end,:) = (LH - HH) / sqrt(2);

    % Inverse row transform
    img = zeros(size(L,1), size(L,2)*2);
    img(:,1:2:end) = (L + H) / sqrt(2);
    img(:,2:2:end) = (L - H) / sqrt(2);
end
