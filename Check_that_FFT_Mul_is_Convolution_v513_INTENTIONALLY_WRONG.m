function Check_that_FFT_Mul_is_Convolution_v513_INTENTIONALLY_WRONG()
% Assure that multiplication in FFT is same as imfilter() with flipped filter.
% 25-Sep-2016
%
% Modified to version 512 on 01-Mar-2018
%
% Thomas Kinsman
%
FFS = 22;       % Figure font size.

    % If you missed the movie, here's "17 Shades of Gray", and black... 
    % (There was a movie "50 Shades of Gray".
    %
    % Spread the line out width wise to 512 pixels wide by first replicating each pixel
    % vertically and then vectorizing the entire image into one column vector.
    %
    % Then replicate that line so it is 512 pixels up and down.
    % That gives us one image that is (512x512).  The FFT likes
    % images that are even powers of 2.
    %
    im_values   = uint8([0:17:255 255:-17:0]);  % Create a Column vector with zeros on the outsides.
    im_order    = repmat( im_values, 16, 1 );   % Replicate pixels 16 times up and down.
    im_line     = im_order(:).';                % Make into a single line.
    im_in_uint8 = repmat( im_line, 512, 1 );    % Form the input image.
    im_in_dbl   = im2double( im_in_uint8 );

    fig1 = figure('Position', [1 1 900 900 ], 'Color','w');
    imagesc( im_in_dbl );
    colormap(gray(256));
    title('\bf Input Image.  Fifteen Shades of Gray.', 'FontSize', FFS );
    colorbar();


    %
    %   Here is a local smoothing filter.
    %   Use your favorite filter:
    %
    my_fav_fltr       = [   1     4     6     4     1
                            4    16    24    16     4
                            6    24    36    24     6
                            4    16    24    16     4
                            1     4     6     4     1 ] / 256;

    % Over-riding to make it not symmetrical:
    my_fav_fltr       = [   2     8     6     0     0
                            8    32    24     0     0
                           12    48    36     0     0
                            8    32    24     0     0
                            2     8     6     0     0 ] / 256;
    
    % Here we zero padd the filter, so that is at the center of the (512x512) image.
    % It has to be the same size as the image so that we can do the multiplication.
    dims                                                = size( im_in_dbl );
    edg_fltr                                            = double( zeros( dims ) );
    edg_fltr( (dims(1)/2) + [-2:2], (dims(2)/2)-2 )     = my_fav_fltr(:,1);
    edg_fltr( (dims(1)/2) + [-2:2], (dims(2)/2)-1 )     = my_fav_fltr(:,2);
    edg_fltr( (dims(1)/2) + [-2:2], (dims(2)/2)+0 )     = my_fav_fltr(:,3);
    edg_fltr( (dims(1)/2) + [-2:2], (dims(2)/2)+1 )     = my_fav_fltr(:,4);
    edg_fltr( (dims(1)/2) + [-2:2], (dims(2)/2)+2 )     = my_fav_fltr(:,5);
    
    
    
    %
    % Flip the filter -- top to bottom, and left to right, to get the convolution.
    % Oh, rats, we used a symmetrical filter.
    %
%     edg_fltr_flipped = imrotate( edg_fltr, 180 );
    
    warning('On Line 69 or so, the filter is flipped back to the wrong way -- intentionally');
    edg_fltr_flipped = edg_fltr;                    % THIS IS WRONG -- FORGETS TO FLIP THE FILP THE FILTER.

    
    %
    %  Now compute the convolution in the Fourier domain
    %
    im_fft              = fftshift( fft2( im_in_dbl ) );
    edg_fft             = fftshift( fft2( edg_fltr_flipped ) );
    product_fft         = im_fft .* edg_fft;
    fft_output          = abs( ifftshift( ifft2( product_fft ) ) );
    fft_output_uint8    = uint8( fft_output * 255 );
    
    %
    %  Clean up the edges from the FFT manually, to avoid edge effects.
    %  The input image has a wicked step wedge from right most pixel values (255) 
    %  to the left most pixels (0).  And the FFT assumes that things wrap around.
    %
    EW                                  = 1;                        % Edge width
    fft_output_uint8(:,1:EW)            = 0;
    fft_output_uint8(:,end-EW:end)      = 0;
    fft_output_uint8(1:EW,:)            = 0;
    fft_output_uint8(end-EW:end,:)      = 0;


    %
    %  Do it all in one line:
    %
    imfilter_output = imfilter( im_in_uint8, my_fav_fltr, 'same', 'repl' );
    
    imfilter_output(:,1:EW)            = 0;
    imfilter_output(:,end-EW:end)      = 0;
    imfilter_output(1:EW,:)            = 0;
    imfilter_output(end-EW:end,:)      = 0;
    
    
    %
    %  Compute the absolute differences:
    %
    im_abs_errors         = imabsdiff( imfilter_output, fft_output_uint8 );
    ttl_err               = sum( im_abs_errors(:) );
    

    
    % Display and compare the results.
    %
    % Other artifacts show up, such as the line down the middle.
    fig2 = figure('Position', [100 10 900 900]);
    imagesc( fft_output_uint8 );
    title('FFT MULTIPLICATION Output of the Convolution. ', 'FontSize', FFS );
    colormap(gray);
    colorbar;


    % We see that imfilter, which does what we want,
    % gets the opposite of what the ifft( fft*fft) generates.
    %
    fig3 = figure('Position', [600 10 900 900]);
    imagesc( imfilter_output );
    title('Imfilter Output by comparison. ', 'FontSize', FFS );
    colormap(gray);
    colorbar;
    
    
    % Show the absolute value of the differences, with the total abs error
    %
    fig4 = figure('Position', [400 10 900 900]);
    imagesc( im_abs_errors );
    ttl_txt = sprintf('Absolute value of Differences.  Total Abs Error=%6.2f', ttl_err );
    title(ttl_txt, 'FontSize', FFS );
    colormap(gray(128));
    colorbar;
    
    figure( fig4 );
    figure( fig3 );
    figure( fig2 );
    figure( fig1 );

end
