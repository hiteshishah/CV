% Name: Hiteshi Shah (hss7374)
% Homework 3
%

% main function that calls the approriate function depending on the file
% name
function HW03_Shah_Hiteshi( fn )

    % cell array of all the names of the images to be sent to the grayscale
    % function
    CELL = {'GRAY_GC01_7334.jpg', 'GRAY_GC02_7354.jpg', 'GRAY_GC04_7370.jpg', 'GRAY_GC04_7371.jpg', 'GRAY_GC04_7372.jpg', 'GRAY_GC10_20170208_104521.jpg'};
    
    % if the passed string matches any file name in CELL, the grayscale
    % function is called, else the display colors function is called
    if any(strcmp(CELL, fn))
        HW03_Shah_Grayscale( fn )
    else
        HW03_Shah_Disp_Color_Spaces( fn )
    end
end

% function that takes in an image and displays the histogram of its
% grayscale regiion of interest
function HW03_Shah_Grayscale( fn )

    % read RGB image, convert the image to double and display it
    im_rgb = imread(fn);
    im_rgb_double = im2double(im_rgb);
    imshow(im_rgb_double);
    
    pause(2);
    
    % convert RGB image to grayscale, select region of interest and display
    % it
    im_grayscale = rgb2gray( im_rgb_double);
    im_grayscale_cropped = im_grayscale(1005:1857, 1191:2193);
    imshow(im_grayscale_cropped);
    
    % display the histogram of the region of interest
    figure( 'Position', [40 5 1024 768] );
    imhist( im_grayscale_cropped, 256 );
    
    % display the mean and standard deviation of the region of interest
    fprintf('%s', strcat('Mean: ', num2str(round(mean(mean(im_grayscale_cropped).'), 3))))
    fprintf('\n')
    fprintf('%s', strcat('Standard Deviation: ', num2str(round(std(std(im_grayscale_cropped).'), 3))))

end

% function that takes in an image and displays it in several different
% color spaces
function HW03_Shah_Disp_Color_Spaces( fn )

    % read the RGB image, convert it to double, separate the R, G and B
    % channels of the image
    im = imread(fn);
    im_rgb = im2double(im);
    im_r = im_rgb(:,:,1);
    im_g = im_rgb(:,:,2);
    im_b = im_rgb(:,:,3);
    
    % display the R, G and B channels of the image
    subplot(2, 2, 1);
    imshow(im_rgb);
    title('Original - RGB');
    subplot(2, 2, 2);
    imshow(im_r);
    title('Red Channel');
    subplot(2, 2, 3);
    imshow(im_g);
    title('Green Channel');
    subplot(2, 2, 4);
    imshow(im_b);
    title('Blue Channel');
    
    pause(3);
    
    % convert the RGB image to HSV and separate the H, S and V
    % channels of the image
    im_hsv = rgb2hsv(im_rgb);
    im_h = im_hsv(:,:,1);
    im_s = im_hsv(:,:,2);
    im_v = im_hsv(:,:,3);
    
    % display the H, S and V channels of the image
    subplot(2, 2, 1);
    imshow(im_hsv);
    title('Original - HSV');
    subplot(2, 2, 2);
    imshow(im_h);
    title('Hue Channel');
    subplot(2, 2, 3);
    imshow(im_s);
    title('Saturation Channel');
    subplot(2, 2, 4);
    imshow(im_v);
    title('Value Channel');
    
    pause(3);
    
    % convert the RGB image to L*a*b* and separate the L*, a* and b*
    % channels of the image
    im_lab = rgb2lab(im_rgb);
    im_l = im_lab(:,:,1);
    im_a = im_lab(:,:,2);
    im_b = im_lab(:,:,3);
    
    % display the L*, a* and b* channels of the image
    subplot(2, 2, 1);
    imshow(im_lab);
    title('Original - L*a*b*');
    subplot(2, 2, 2);
    imshow(im_l);
    title('L* Channel');
    subplot(2, 2, 3);
    imshow(im_a);
    title('a* Channel');
    subplot(2, 2, 4);
    imshow(im_b);
    title('b* Channel');
    
    pause(3);
    
    % convert the RGB image to YCbCr and separate the Y, Cb and Cr
    % channels of the image
    im_ycbcr = rgb2ycbcr(im_rgb);
    im_y = im_ycbcr(:,:,1);
    im_cb = im_ycbcr(:,:,2);
    im_cr = im_ycbcr(:,:,3);
    
    % display the Y, Cb and Cr channels of the image
    subplot(2, 2, 1);
    imshow(im_ycbcr);
    title('Original - YCbCr');
    subplot(2, 2, 2);
    imshow(im_y);
    title('Y Channel');
    subplot(2, 2, 3);
    imshow(im_cb);
    title('Cb Channel');
    subplot(2, 2, 4);
    imshow(im_cr);
    title('Cr Channel');
    
    pause(3);
    close all;

end