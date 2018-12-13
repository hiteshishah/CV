function SHOW_YCbCr_DEMO()

    figure('Position',[10 10 1024 768]);
    im_rgb          =    im2double( imread('IMG_7651_BALLS.JPG') );  
    color_names     = { 'RGB', 'Red', 'Green', 'Blue' };
    show_separations( im_rgb, color_names );

    figure('Position',[200 10 1024 768]);
    im_ycc          =    rgb2ycbcr( im_rgb );    
    color_names     = { 'YCbCr Shown in RGB Colors', 'Luminance', 'Cb', 'Cr' };
    show_separations( im_ycc, color_names );
    
end