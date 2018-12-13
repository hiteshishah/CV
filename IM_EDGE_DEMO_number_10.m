%% Edge gradient Estimation.
%
%  Foundations of Computer Vision, 631
%
%  Dr. Thomas B. Kinsman, Ph.D
%  Feb 08th, 2018
%
%
%  IMPORTANT NOTE:  
%  The Sobel edge detector is Dr. Kinsman's __favorite__ form
%  of edge estimation because from it he can compute:
%  1.  The edge magnitude, and 
%  2.  The edge direction (or angle).
%
%  Sometimes the patterns that you look for are revealed by:
%  1.  the edge magnitude, OR,
%  2.  the edge direction.
%
%  Look at the two results here...
%

function IM_EDGE_DEMO_number_10()
% Demo of computing edge strength.
FS = 20;            % Font Size
Fig_Wd = 800;

    % Here we demonstrate getting informtion about the 'root' display:
    scr_size    = get(0, 'ScreenSize' );
    
    
    im          = im2double( imread( 'cameraman.tif' ) );
    
    %% Smooth the image to reduce noise:
    %
    % This is done here to reduce local unwanted variations
    % in the image which are caused by motion jitter in the
    % microscope as it is recording the negative, and 
    % local power flucutations in the system when recording
    % the negative 
    % 
    filter_gauss    = fspecial( 'Gauss', 9, 0.75 );
    im_smoothed     = imfilter( im, filter_gauss, 'same', 'repl' );
    
    %% Sobel Filter:
    %
    % Here I define my own sobel filter because nobody else
    % gets the math correct:
    %
    fltr            = [ -1 0 1 ;
                        -2 0 2 ;
                        -1 0 1 ] / 8;
    
    %% Edge gradient estimation:
    % Estimate the derivative in the X and Y directions: 
    dIdx            = imfilter( im_smoothed, fltr,   'same', 'repl' );
    dIdy            = imfilter( im_smoothed, fltr.', 'same', 'repl' );
    
    %% Edge Magnitude:
    %
    %  Compute the local edge magnitude:
    %
    dI_magnitude    = ( dIdx.^2  + dIdy.^2 ).^(1/2);
    
    
    
    %% Original Image:
    %
    figure('Position',[0 10 Fig_Wd 768]);
    imagesc( im );
    axis image;
    colormap( gray(256) );
    colorbar;
    title('Original Image ', 'FontSize', FS );
    
    
    
    %% Edge Magnitude:
    %
    %  We use knowledge about the screen size to center the image:
    % 
    figure('Position',[round( (scr_size(3)-Fig_Wd)/2) 10 Fig_Wd 768]);
    imagesc( dI_magnitude );
    axis image;
    colormap( jet );
    colorbar;
    title('Magnitude -- Notice the Edges on the Jacket!! ', 'FontSize', FS );
    
    
    %% Edge Direction:
    %
    %  Compute the local edge direction, or angle:
    %
    %  Because image coordinates are left handed (Y goes down),
    %  we switch the polarity of dIdy to get the angles to 
    %  be what you would expect them to be normally.
    %
    dI_angle        = atan2( -dIdy, dIdx ) * 180 / pi;  % Convert angle to degrees.
    
    %  We use knowledge about the screen size to put the image on the right side:
    % 
    figure('Position',[scr_size(3)-Fig_Wd, 10 Fig_Wd 768]);
    imagesc( dI_angle );
    axis image;
    colormap( jet );
    colorbar;
    title('Angle -- Notice the Patterns in the Sky!! ', 'FontSize', FS );
    
end

