% Created on 09/01/25
% Author: Pyansu Nahak, BT22ECE131
% Practical #1: Convert a Color Image to Grayscale and Modify RGB Components

clc;
clear;
close all;

% Load the image from file
image = imread("landscape.jpg");

% Get image dimensions
[rows, cols, channels] = size(image);
disp(['Image dimensions: ', num2str(rows), ' x ', num2str(cols)]);

% Display the intensity of a specific pixel or use a fallback if out of bounds
if rows >= 1010 && cols >= 505
    disp(['Pixel value at (1010, 505): ', num2str(image(1010, 505))]);
else
    center_row = round(rows / 2);
    center_col = round(cols / 2);
    disp(['Center pixel value at (', num2str(center_row), ', ', num2str(center_col), '): ', num2str(image(center_row, center_col))]);
end

% Convert to grayscale using the red channel only
gray_single_channel = image(:, :, 1);

% Convert to grayscale using average method
red_channel = image(:, :, 1);
green_channel = image(:, :, 2);
blue_channel = image(:, :, 3);
gray_avg = round((red_channel + green_channel + blue_channel) / 3);

% Convert to grayscale using the luminosity method
gray_luminosity = round(0.299 * red_channel + 0.587 * green_channel + 0.114 * blue_channel);

% Create an image highlighting the red channel
image_red = image;
image_red(:, :, 2) = 0;
image_red(:, :, 3) = 0;

% Create an image highlighting the green channel
image_green = image;
image_green(:, :, 1) = 0;
image_green(:, :, 3) = 0;

% Create an image highlighting the blue channel
image_blue = image;
image_blue(:, :, 1) = 0;
image_blue(:, :, 2) = 0;

% Display original image and grayscale versions
figure(1);
subplot(2, 2, 1), imshow(image); xlabel("Original Image");
subplot(2, 2, 2), imshow(gray_single_channel); xlabel("Grayscale (Single Channel)");
subplot(2, 2, 3), imshow(gray_avg); xlabel("Grayscale (Average Method)");
subplot(2, 2, 4), imshow(gray_luminosity); xlabel("Grayscale (Luminosity Method)");

% Display original image and color-filtered versions
figure(2);
subplot(2, 2, 1), imshow(image); xlabel("Original Image");
subplot(2, 2, 2), imshow(image_red); xlabel("Red-Filtered Image");
subplot(2, 2, 3), imshow(image_green); xlabel("Green-Filtered Image");
subplot(2, 2, 4), imshow(image_blue); xlabel("Blue-Filtered Image");
