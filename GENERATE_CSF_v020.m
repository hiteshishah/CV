function GENERATE_CSF_v020()
%  Create an 1024x768 Contrast Sensitivity Function:
%
%  Matlab code to generate the classic contrast sensitivity figure in which
%  spatial frequency increases (exponentially) from left to right. 
%
%  Contrast increases from top to bottom. The boundary between the invisible and 
%  visible gratings is shaped like the human CSF (contrast sensitivity function).
%
%  Note, however, that the apparent contrast of the bottom of the image (high
%  contrast) appears roughly equal across spatial frequencies - a
%  demonstration of 'contrast constancy'.
%
%  Originally Written by G.M. Boynton, August 2005
%
%  Modified by Thomas B. Kinsman, April, 2018
%

my_vers = get_fn_version( mfilename() );

WIDTH   = 1024;
HEIGHT  = 768;

    sz          = [ HEIGHT, WIDTH ];

    x_range     = linspace( 1, 5, sz(2) );          % Range is from 1 to 5, linearly across WIDTH pixels.
    y_range     = linspace( 0, 1, sz(1) ).^(3);     % Contrast goes from 0 to 1, 
                                                    % However, the contrast is not linear across HEIGHT pixels,
                                                    % it is an increasing function the further down you go.
                                                    % It is a cube root.

    [x,y]       = meshgrid( x_range, y_range );     % Create all X and Y values simultaneously.

    img         = sin( exp(x) ).* y;                % Multiply all the sine waves times all the contrasts, all at once.
    
    img         = (img+1)*128;                      % Add one to the sine() so that the results go from 0 to 2,
                                                    % then multiply by 128, so that the results go from 0 to 256.

    % Display the results:
    figure('Position', [200 10 1024 768] );

    imagesc(img);
    axis off;                                       % Do not need an axis.
    caxis([0 255]);                                 % Contrast goes from 0 to 255.
    colormap(gray(256));
    axis image;                                     % Make the pixels square.
    set(gca,'Position',[0 0 1 1]);                  % Fill the axis with the figure.
    
    % Create a unique filename, with this file version in it:
    fn_out = sprintf('Fig__CSV%s.png', my_vers );
    
    % Convert the image to unsigned integer, 8-bit, and write it out:
    imwrite( uint8(img), fn_out, 'PNG' );

end
