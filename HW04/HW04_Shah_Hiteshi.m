% Name: Hiteshi Shah (hss7374)
% Homework 4
%

function HW04_Shah_Hiteshi( fn )

% initializing the value for maximum contrast
max_contrast = 0;

% initializing the title for the final display image
imageTitle = ' ';

% reading the passed filename
im = imread( fn );

% if the  image is in colorm take in only the green channel
% and set the coordinates for the region of interest depending on the input
% image
if size(im, 3) == 3
    im = im(:,:,2);
    x1 = 4167;
    y1 = 2740;
    x2 = 4447;
    y2 = 2768;
else
    x1 = 1586;
    y1 = 1069;
    x2 = 1628;
    y2 = 1097;
end

im = im2double(im);

% taking the log transform of the image and calculating the contrast in the
% region of interest
% if the contrast is higher than the current maximum contrast, then the
% maximum contrast is set to this value and the title is set for this
% transform
log_im = 2 * log(im + 1);
if (max(max(log_im(y1:y2, x1:x2))) - min(min(log_im(y1:y2, x1:x2)))) > max_contrast
    max_contrast = max(max(log_im(y1:y2, x1:x2))) - min(min(log_im(y1:y2, x1:x2)));
    imageTitle = 'Logarithmic transform';
end

% taking the gamma transform of the image and calculating the contrast in the
% region of interest
% if the contrast is higher than the current maximum contrast, then the
% maximum contrast is set to this value and the title is set for this
% transform
gamma_im = 2 * (im .^ 3.0);
if (max(max(gamma_im(y1:y2, x1:x2))) - min(min(gamma_im(y1:y2, x1:x2)))) > max_contrast
    max_contrast = max(max(gamma_im(y1:y2, x1:x2))) - min(min(gamma_im(y1:y2, x1:x2)));
    imageTitle = 'Gamma transform';
end

% taking the exponential transform of the image and calculating the contrast in the
% region of interest
% if the contrast is higher than the current maximum contrast, then the
% maximum contrast is set to this value and the title is set for this
% transform
exp_im = 4 * (((1 + 0.3).^(im)) - 1);
if (max(max(exp_im(y1:y2, x1:x2))) - min(min(exp_im(y1:y2, x1:x2)))) > max_contrast
    max_contrast = max(max(exp_im(y1:y2, x1:x2))) - min(min(exp_im(y1:y2, x1:x2)));
    imageTitle = 'Exponential transform';
end

% taking the square-root transform of the image and calculating the contrast in the
% region of interest
% if the contrast is higher than the current maximum contrast, then the
% maximum contrast is set to this value and the title is set for this
% transform
sqrt_im = im .^ (1/2);
if (max(max(sqrt_im(y1:y2, x1:x2))) - min(min(sqrt_im(y1:y2, x1:x2)))) > max_contrast
    max_contrast = max(max(sqrt_im(y1:y2, x1:x2))) - min(min(sqrt_im(y1:y2, x1:x2)));
    imageTitle = 'Square-root transform';
end

% taking the cuberoot transform of the image and calculating the contrast in the
% region of interest
% if the contrast is higher than the current maximum contrast, then the
% maximum contrast is set to this value and the title is set for this
% transform
cubert_im = im .^ (1/3);
if (max(max(cubert_im(y1:y2, x1:x2))) - min(min(cubert_im(y1:y2, x1:x2)))) > max_contrast
    max_contrast = max(max(cubert_im(y1:y2, x1:x2))) - min(min(cubert_im(y1:y2, x1:x2)));
    imageTitle = 'Cube-root transform';
end

% taking the square transform of the image and calculating the contrast in the
% region of interest
% if the contrast is higher than the current maximum contrast, then the
% maximum contrast is set to this value and the title is set for this
% transform
sqr_im = im .^ 2;
if (max(max(sqr_im(y1:y2, x1:x2))) - min(min(sqr_im(y1:y2, x1:x2)))) > max_contrast
    max_contrast = max(max(sqr_im(y1:y2, x1:x2))) - min(min(sqr_im(y1:y2, x1:x2)));
    imageTitle = 'Square transform';
end

% using histogram equalization on the image and calculating the contrast in the
% region of interest
% if the contrast is higher than the current maximum contrast, then the
% maximum contrast is set to this value and the title is set for this
% transform
histeq_im = histeq(im);
if (max(max(histeq_im(y1:y2, x1:x2))) - min(min(histeq_im(y1:y2, x1:x2)))) > max_contrast
    max_contrast = max(max(histeq_im(y1:y2, x1:x2))) - min(min(histeq_im(y1:y2, x1:x2)));
    imageTitle = 'Histogram equalization';
end

% using adaptive histogram equalization on the image and calculating the contrast in the
% region of interest
% if the contrast is higher than the current maximum contrast, then the
% maximum contrast is set to this value and the title is set for this
% transform
ahisteq_im = adapthisteq(im, 'clipLimit', 0.02, 'Distribution', 'exponential');
if (max(max(ahisteq_im(y1:y2, x1:x2))) - min(min(ahisteq_im(y1:y2, x1:x2)))) > max_contrast
    max_contrast = max(max(ahisteq_im(y1:y2, x1:x2))) - min(min(ahisteq_im(y1:y2, x1:x2)));
    imageTitle = 'Adaptive histogram equalization';
end

% using contrast stretching on the image and calculating the contrast in the
% region of interest
% if the contrast is higher than the current maximum contrast, then the
% maximum contrast is set to this value and the title is set for this
% transform
cs_im = imadjust(im ,stretchlim(im ,[0.05 0.95]),[]);
if (max(max(cs_im(y1:y2, x1:x2))) - min(min(cs_im(y1:y2, x1:x2)))) > max_contrast
    max_contrast = max(max(cs_im(y1:y2, x1:x2))) - min(min(cs_im(y1:y2, x1:x2)));
    imageTitle = 'Contrast stretching';
end

% switch statement that takes in the current title with the maximum
% contrast and displays the appropriate image along with the title
switch imageTitle
    case 'Logarithmic transform'
        imshow(log_im);
        title(imageTitle);
    case 'Gamma transform'
        imshow(gamma_im);
        title(imageTitle);
    case 'Exponential transform'
        imshow(exp_im);
        title(imageTitle);
    case 'Square-root transform'
        imshow(sqrt_im);
        title(imageTitle);
    case 'Cube-root transform'
        imshow(cubert_im);
        title(imageTitle);
    case 'Square transform'
        imshow(sqr_im);
        title(imageTitle);
    case 'Histogram equalization'
        imshow(histeq_im);
        title(imageTitle);
    case 'Adaptive histogram equalization'
        imshow(ahisteq_im);
        title(imageTitle);
    case 'Contrast stretching'
        imshow(cs_im);
        title(imageTitle);
    otherwise
        fprintf('Error');
end

end