function GENERATE_DCT_BASIS_FUNCTIONS_v005()
% Create all 64 DCT Coeficients, and show in one image.
%my_vers = get_fn_version( mfilename() );

REP    = 8;                         % Replication factor.
MARGIN = 24;                        % PIXELS BETWEEN DCT BASIS FUNCTIONS

    thetas = 0:7;
    
    % Allocate an image to handle the final set of coefficients:
    % Width is 8 pixels per DCT Block * REP * 8 BLOCKS ACROSS 
    % Plus 9 * the MARGIN
    %
    % AND It is square.
    full_frame_image  = (1/2) * ones( REP*8*8 + 9*MARGIN );
    
    iteration = 1;
    for r_idx = 0:7                 % Row index
        for c_idx = 0:7             % Column index

            fprintf('Iteration: %2d, row_index = %2d, col_index = %2d\n', ...
                        iteration, r_idx, c_idx);

            row_values  = cos( pi/8 * ( thetas + 1/2 ) * r_idx );
            col_values  = cos( pi/8 * ( thetas + 1/2 ) * c_idx );
            im_new      = col_values.' * row_values;
            im_big      = imresize( im_new, REP, 'nearest' );

            imagesc( im_big );
            colormap(gray);
            yttl = sprintf('%2.1f cycles ', (c_idx)*(1/2) );
            xttl = sprintf('%2.1f cycles ', (r_idx)*(1/2) );
            ylabel( yttl, 'FontSize', 24 );
            xlabel( xttl, 'FontSize', 24 );
            pause(0.5);
            
            % How far over should we put this new image:
            % Make it (row_idx * (the image width + the image_width) for a margin.
            ulrow   = r_idx * (size(im_big,2) + MARGIN ) + MARGIN;
            lrrow   = ulrow + size(im_big,2) - 1;
            
            ulcol   = c_idx * (size(im_big,2) + MARGIN ) + MARGIN;
            lrcol   = ulcol + size(im_big,1) - 1;
            
            full_frame_image( ulrow:lrrow, ulcol:lrcol ) = im_big;

            iteration = iteration + 1;
        end
    end
    
    imagesc( full_frame_image );
    axis image;
    
    fn_out = sprintf('DCT_COEFFICIENT_SET__%s.png', my_vers );
    imwrite( full_frame_image, fn_out, 'PNG' );
    
    fn_out = sprintf('DCT_COEFFICIENT_SET__%s.jpg', my_vers );
    imwrite( full_frame_image, fn_out, 'JPEG', 'Quality', 100 );
    
    dims = size( full_frame_image );
    fprintf('File size is: %d by %d\n', dims(1), dims(2) );

end
