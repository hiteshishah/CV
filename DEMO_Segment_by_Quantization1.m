function DEMO_Segment_by_Quantization( fn )
% Does simple color quantization, as per HW02.

    if ( nargin < 1 )
        fn = '../../ASSIGNING_HOMEWORK/HW_08_2161_SEGMENTATION/IMAGES_OF_RGBY_BALLS/BALLS_Four_RGBY_5239.jpg';
    end

    im_rgb      = im2double( imread( fn ) );
    
    % Hack the image down to a smaller number of pixels for speed:
    im_rgb      = imresize( im_rgb, 0.25, 'nearest' );
    
    
    % Immediately convert to possible colorspaces:
    im_hsv      = rgb2hsv(      im_rgb );

    im_lab      = rgb2lab(      im_rgb );

    % Do some dynamic ranging to normalize LAB:
    im_lab(:,:,1) = im_lab(:,:,1)./100.0;
    a_star_min    = -100;
    a_star_max    =  100;
    im_lab(:,:,2) = ( im_lab(:,:,2) - a_star_min ) / ( a_star_max - a_star_min ); 
   
    b_star_min    = -100;
    b_star_max    =  100;
    im_lab(:,:,3) = ( im_lab(:,:,3) - b_star_min ) / ( b_star_max - b_star_min ); 
   
    im_ycc      = rgb2ycbcr(    im_rgb );
    
    im_ymb      = im_rgb( :, :, 1 ) +   im_rgb( :, :, 2 ) -  2 * im_rgb( :, :, 3 );
    im_mmg      = im_rgb( :, :, 1 ) - 2*im_rgb( :, :, 2 ) +      im_rgb( :, :, 3 );

    N_QUANTS = 4;
    show_img_quantization( im_rgb, 'RGB ', N_QUANTS );
    show_img_in_colorspace( im_rgb );
    
    show_img_quantization( im_hsv, 'HSV', N_QUANTS );
    show_img_in_colorspace( im_hsv );
    
    show_img_quantization( im_lab, 'LAB ', N_QUANTS );
    show_img_in_colorspace( im_lab );
    
    show_img_quantization( im_ycc, 'YCC ', N_QUANTS );
    show_img_in_colorspace( im_ycc );
    
    show_img_quantization( im_ymb, 'Yellow minus Blue', N_QUANTS );
    
    show_img_quantization( im_mmg, 'Magenta minus Green', N_QUANTS );
    
    
end



function show_img_quantization( im_dbl, ttl, quant )

    x_offset = round( rand(1,1)*50 -25 );
    y_offset = round( rand(1,1)*50 -25 );
    
    figure('Position',[100+x_offset 100+y_offset 1024 768]);
    subplot( 2, 2, 1 );
    imshow( im_dbl );
    title( ttl, 'FontSize', 18 );
    
    % Quantize image and show planes:
    % This could be wrong ... 
    im_quant = round( im_dbl * (quant-1) ) ./ (quant-1);
    subplot( 2, 2, 2 );
    if ( length( size(im_dbl) ) == 3 )
        imshow( im_quant(:,:,1) );
    else
        imshow( im_quant );
    end
    ttl_b = sprintf('Quantized by %d', quant );
    title( ttl_b, 'FontSize', 18 );
    
    if ( length( size(im_dbl) ) == 3 )
        subplot( 2, 2, 3 );
        imshow( im_quant(:,:,2) );
        title( [ ttl(2) ' ' ], 'FontSize', 18 );
 
        subplot( 2, 2, 4 );    
        imshow( im_quant(:,:,3) );
        title( [ ttl(3) ' ' ], 'FontSize', 18 );
    end

end

function show_img_in_colorspace( im_dbl )

    xs = im_dbl(:,:,1);
    ys = im_dbl(:,:,2);
    zs = im_dbl(:,:,3);

    x_offset = round( rand(1,1)*50 -25 );
    y_offset = round( rand(1,1)*50 -25 );
    
    figure('Position', [30+x_offset, 30+y_offset, 1024, 768 ]);
    plot3( xs(1:5:end), ys(1:5:end), zs(1:5:end), 'k.');
    grid on;
    rotate3d on;
    
end
    

