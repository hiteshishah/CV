% Name: Hiteshi Shah (hss7374)
% Homework 7
%

% function to cluster image to see which distance metric works best
function HW07_part3b_Euclidean_vs_CityBlock( fn_in )

    addpath( './TEST_IMAGES'     );
    addpath( '../TEST_IMAGES'    );
    addpath( '../../TEST_IMAGES' );

    % number of clusters = 20
    n_clusters =  20;

    % number of pixels to use for max dimensions
    target_max_dimension = 420; 
    
    % distance weight
    wt = 1/100 ;

    if ( nargin < 1 )
        fn_in = 'science_frog.jpg';
    end

    im_orig         = imread( fn_in );
    
    % getting the dimensions of the original image
    dims            = size( im_orig );

    % resampling the image so it is smaller and takes less time to compute
    var_name_rvec   = ([1 1] * target_max_dimension) ./ dims(1:2);
    var_name_rfr    = min( var_name_rvec );
    
    im              = imresize( im_orig, var_name_rfr );   
    
    % getting the dimensions of the resized image
    dims            = size( im );

    % blurring the image 
    fltr        = fspecial( 'gauss', [15 15], 5 );            
    im          = imfilter( im, fltr, 'same', 'repl' );
    
    % converting the image from RGB color space to YCbCr
    im_ycc      = rgb2ycbcr( im );   
    
    %  2-D grid coordinates based on the dimensions of the resized image
    [xs, ys]     = meshgrid( 1:dims(2), 1:dims(1) );
    
    % separating the image into its indivial channels
    lum_y_s     = im_ycc(:,:,1);
    cb_s        = im_ycc(:,:,2);
    cr_s        = im_ycc(:,:,3);
    
    % cell array of name of distance metrics
    dist_names = { 'Cityblock', 'SqEuclid' };
    
    for dist_idx = 1:length(dist_names)
                
        % curly braces means it is a cell array
        dist_name = dist_names{ dist_idx };

        % using the x and y locations of the pixel as well as each of its color
        % channels as the attributes
        attributes  = [ xs(:)*wt, ys(:)*wt, double(lum_y_s(:)), double(cb_s(:)), double(cr_s(:)) ];

        % performing kmeans on the attributes for the given number of clusters
        % and current distance metric 
        tic;
        [cluster_id, cluster_centers] = kmeans( attributes, n_clusters, 'Dist', dist_name, 'Replicate', 3, 'MaxIter', 250 );
        toc

        % reshaping the new image using the dimensions of the resized image
        im_new      = reshape( cluster_id, dims(1), dims(2) );

        colors        = uint8( cluster_centers( :, 3:end ) );     % taking just the colors, separating from x & y attributes
        im_rgb        = ycbcr2rgb( colors );                      % converting from YCbCr to RGB
        im_rgb_double = im2double( im_rgb );                      % converting to double

        % random x position for figure placement
        x_over = round( rand(1,1)*400 + 100 );
        % random y position for figure placement
        y_up   = round( rand(1,1)*100 + 10 );
        figure('Position', [x_over, y_up, 600, 600] );
        
        % displaying new image along with its new colormap, a colorbar, axis
        % and title
        imagesc( im_new );
        axis image;
        ttl_test = sprintf('k = %d,  distance wt = %8.5f,  dist name = %s', n_clusters, wt, dist_name);
        title( ttl_test, 'FontSize', 14 );
        colorbar
        colormap( im_rgb_double );
        axis image;
        drawnow;
        
    end

end