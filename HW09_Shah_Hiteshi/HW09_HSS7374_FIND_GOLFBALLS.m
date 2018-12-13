% function that segments golf balls from the background using Mahalanobis
% distance
function HW09_HSS7374_FIND_GOLFBALLS( fn )

    % reading in the RGB image
    im_rgb = imread( fn );

    % asking user to select foreground and background pixels in the image
    imshow( im_rgb );
    fprintf('Select foreground pixels\n');
    [x_fg, y_fg] = ginput();

    fprintf('Now, select background pixels\n');
    [x_bg, y_bg] = ginput();
    
    % smoothing the image before any processing
    filter_disk    = fspecial( 'disk', 5 );
    im_rgb     = imfilter( im_rgb, filter_disk, 'same', 'repl' );

    % converting to Lab color space and extracting the first two channels
    im_lab      = rgb2lab( im_rgb );
    im_a        = im_lab(:,:,2);
    im_b        = im_lab(:,:,3);
    
    % extracting the linear indices of the foreground pixels from the image
    fg_indices  = sub2ind( size(im_lab), round(y_fg), round(x_fg) );
    fg_a        = im_a( fg_indices );
    fg_b        = im_b( fg_indices );

    % extracting the linear indices of the background pixels from the image
    bg_indices  = sub2ind( size(im_lab), round(y_bg), round(x_bg) );
    bg_a        = im_a( bg_indices );
    bg_b        = im_b( bg_indices );
    
    % forming a matrix of the two features of the foreground object
    fg_ab       = [ fg_a fg_b ];                  
    
    % forming a matrix of the two features of the background object
    bg_ab       = [ bg_a bg_b ]; 
    
    % forming a matrix of the two color channels of the image
    im_ab       = [ im_a(:) im_b(:) ];
    
    % calculating the Mahalanobis distance of each pixel in the image from
    % the foreground and background features
    mahal_fg    = ( mahal( im_ab, fg_ab ) ) .^ (1/2);
    mahal_bg    = ( mahal( im_ab, bg_ab ) ) .^ (1/2);
    
    % classifying balls as 1 if distance to foreground is < distance to background
    % with a tolerance of 2
    class_balls     = mahal_fg < mahal_bg - 2;
    
    % calculating the mean and standard deviation of the foreground pixels
    fg_dists        = mahal_fg(class_balls);
    dist_mean       = mean( fg_dists );
    dist_std        = std(  fg_dists );
    
    % tossing everything outside of one standard deviation, and re-adjusting the mean value
    b_inliers       = ( fg_dists <= (dist_mean + dist_std) ) & ( fg_dists >= (dist_mean - dist_std));
    the_inliers     = fg_dists( b_inliers );
    dist_mean       = mean( the_inliers );

    %  using the mean as the threshold distance to target variable as rules for inclusion
    better_class_balls      = mahal_fg < dist_mean;
    
    % changing the shape of the classification to look like an image
    class_im        = reshape( better_class_balls, size(im_a,1), size(im_a,2) );
    class_im        = im2uint8(class_im);
    
    % plotting the original and segmented images side-to-side
    subplot(1,2,1);
    imagesc(im_rgb);
    axis image;
    title('Original Image', 'FontSize', 20, 'FontWeight', 'bold' );
    
    subplot(1,2,2);
    imagesc( class_im );
    axis image;
    colormap(gray);
    title('Segmented Image', 'FontSize', 20, 'FontWeight', 'bold' );

end