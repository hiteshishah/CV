% Name: Hiteshi Shah (hss7374)
% Homework 7
%

% function to cluster image using self potrait
function HW07_part4_portrait()

    addpath( './TEST_IMAGES'     );
    addpath( '../TEST_IMAGES'    );
    addpath( '../../TEST_IMAGES' );

    % number of clusters = 64
    n_clusters =  64;

    % number of pixels to use for max dimensions
    target_max_dimension = 420;

    % distance weight
    wt = 1/250 ;

    im_orig         = imread( 'photo_2017-06-12_13-21-10.jpg' );
    
    % getting the dimensions of the original image
    dims            = size( im_orig );

    % resampling the image so it is smaller and takes less time to compute
    var_name_rvec   = ([1 1] * target_max_dimension) ./ dims(1:2);
    var_name_rfr    = min( var_name_rvec );
    
    im              = imresize( im_orig, var_name_rfr ); 
    
    % getting the dimensions of the resized image
    dims            = size( im );
    
    % filter for Sobel edge detection
    fltr = [ -1 0 1 ;
             -2 0 2 ;
             -1 0 1 ] / 8;  
    
    % converting image to black and white & double
    im_double = im2double(im2bw(im));
         
    % calculating Gx, Gy, and G
    dIdx = imfilter( im_double, fltr, 'same', 'repl' );
    dIdy = imfilter( im_double, fltr.', 'same', 'repl' );
    dI_magnitude = ( dIdx.^2  + dIdy.^2 ).^(1/2);

    % blurring the image
    fltr         = fspecial( 'gauss', [15 15], 5 ); 
    im           = imfilter( im, fltr, 'same', 'repl' );
    
    % blurring the gradient
    fltr2         = fspecial( 'gauss', [15 15], 1 ); 
    dI_magnitude  = imfilter( dI_magnitude, fltr2, 'same', 'repl' );
    
    % converting the image from RGB color space to HSV
    im_hsv      = rgb2hsv( im );   
    
    %  2-D grid coordinates based on the dimensions of the resized image
    [xs, ys]     = meshgrid( 1:dims(2), 1:dims(1) );
    
    % separating the image into its indivial channels
    h_s     = im_hsv(:,:,1);
    s_s     = im_hsv(:,:,2);
    v_s     = im_hsv(:,:,3);

    % using the x and y locations of the pixel as well as each of its color
    % channels as the attributes
    attributes  = [ xs(:)*wt, ys(:)*wt, double(h_s(:)), double(s_s(:)), double(v_s(:)), dI_magnitude(:)];

    % performing kmeans on the attributes for the given number of clusters
    % and distance metric 'Cityblock'
    tic;
    [cluster_id, cluster_centers] = kmeans( attributes, n_clusters, 'Dist', 'Cityblock', 'Replicate', 3, 'MaxIter', 250 );
    toc

    % reshaping the new image using the dimensions of the resized image
    im_new      = reshape( cluster_id, dims(1), dims(2) );

    colors        = cluster_centers( :, 3:5 );     % taking just the colors, separating from x & y attributes
    im_rgb        = hsv2rgb( colors );             % converting from YCbCr to RGB
    im_rgb_double = im2double( im_rgb );           % converting to double
    
    % random x position for figure placement
    x_over = round( rand(1,1)*400 + 100 );
    % random y position for figure placement
    y_up   = round( rand(1,1)*100 + 10 );
    figure('Position', [x_over, y_up, 600, 600] );
    
    % displaying new image added with the edges along with its new 
    % colormap, a colorbar, axis and title
    imagesc( imadd(uint8(im_new), uint8(imcomplement(dI_magnitude))) );
    axis image;
    ttl_test = sprintf('k = %d,  distance wt = %8.5f,  dist name = %s', n_clusters, wt, 'Cityblock');
    title( ttl_test, 'FontSize', 14 );
    colorbar
    colormap( im_rgb_double );
    axis image;
    drawnow;
end