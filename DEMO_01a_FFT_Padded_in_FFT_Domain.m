function DEMO_01a_FFT_Padded_in_FFT_Domain( )
% Demonstrate some more FFT Magic -- padding the FFT changes the image size:
%
FS = 22;

    im_space                = im2double( imread( 'cameraman.tif' ) );
    dims                    = size( im_space );
    
    %
    %  Go to the FFT Domain:
    %
    im_fft                  = fftshift( fft2( im_space     ) );
    
    %
    %   Pad out the FFT with zeros -- make up frequencies that don't really exist in the image:
    %
    im_fft_big              = padarray( im_fft, ([512 512] - dims/2) ); 

    im_recovered            = ifft2( fftshift( im_fft_big ) );

    %
    %  Show the original image:
    %
    figure('Position',[100 400 512 512]);
    imagesc( im_space );
    title('Original ', 'FontSize', FS );
    colormap(gray);

    %
    %  Show the results:
    %
    figure('Position',[800   0  1024 1024]);
    imagesc( abs( im_recovered ) );
    axis image;
    title('Result after inverse FFT ', 'FontSize', FS );
    colormap(gray);
    
end

