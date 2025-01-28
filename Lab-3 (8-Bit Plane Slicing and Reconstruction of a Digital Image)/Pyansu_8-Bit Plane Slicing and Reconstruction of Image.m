% 8-Bit Plane Slicing and Reconstruction of a Digital Image
% Created on: 27/01/25
% Author: Pyansu Nahak, BT22ECE131

[fileName, filePath] = uigetfile({'*.jpg;*.png;*.bmp', 'Image Files (*.jpg, *.png, *.bmp)'; '*.*', 'All Files (*.*)'}, 'Select an Image');
if isequal(fileName, 0)
    disp('No file selected. Exiting...');
    return;
end


image = imread(fullfile(filePath, fileName));
if size(image, 3) == 3
    image = rgb2gray(image);
end

% Create Figure 1
figure(1);


subplot(3, 3, 1);
imshow(image);
title('Original Image');

% Perform 8-bit slicing and display all bit planes
bit_planes = cell(1, 8);
for bit = 1:8
    % Extract the bit plane
    bit_planes{bit} = bitget(image, bit);
    
    % Convert to uint8 for visualization
    bit_plane_uint8 = uint8(bit_planes{bit} * 255);
    
    % Display the bit plane
    subplot(3, 3, bit + 1); % Use subplot for the 3x3 grid
    imshow(bit_plane_uint8);
    title(['Bit Plane ', num2str(bit)]);
end

sgtitle('8-Bit Plane Slicing');

% Reconstruct the image with the LSB (bit plane 1) discarded
reconstructed_image = zeros(size(image), 'uint8');
for bit = 2:8
    reconstructed_image = reconstructed_image + uint8(bit_planes{bit} * 2^(bit - 1));
end

% Create Figure 2 for the reconstructed image
figure(2);
imshow(reconstructed_image);
title('Reconstructed Image (No LSB)');