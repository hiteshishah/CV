% Name: Hiteshi Shah (hss7374)
% Homework 5
%

% main function
function HW05_Shah_Hiteshi_main( input_image )

    addpath( '../TEST_IMAGES/');
    addpath( '../../TEST_IMAGES/');

    subplot(2, 2, 1); imagesc( input_image ); title("Original");
    subplot(2, 2, 3); plot(imhist(input_image)); axis([0 300 0 15000]);
    subplot(2, 2, 2);
    im_new = Local_Smear_Routine( input_image );
    imagesc( im_new ); title("Local Smear Routine");
    subplot(2, 2, 4); plot(imhist(im_new)); axis([0 300 0 15000]);
    pause( 2 );
    
    subplot(2, 2, 2);
    weights = [1 2 1 ; 2 4 2 ; 1 2 1 ] / 16;
    im_new = local_weighting_routine( input_image, weights); 
    imagesc( im_new ); title("Local Weighting Routine");
    subplot(2, 2, 4); plot(imhist(im_new)); axis([0 300 0 15000]);
    pause( 2 );
    
    subplot(2, 2, 2);
    mat1 = round( fspecial( 'gaus', 5, 1 )*1000 );
    im_new = local_weighting_routine( input_image, mat1);
    imagesc( im_new ); title("Local Weighting Routine - Guass 1");
    subplot(2, 2, 4); plot(imhist(im_new)); axis([0 300 0 15000]);
    pause( 2 );
    
    start = tic;
    subplot(2, 2, 2);
    mat2 = round( fspecial( 'gaus', 15, 7 )*1000 );
    im_new = local_weighting_routine( input_image, mat2);
    imagesc( im_new ); title("Local Weighting Routine - Guass 2");
    subplot(2, 2, 4); plot(imhist(im_new)); axis([0 300 0 15000]);
    time = toc(start);
    fprintf('%d', time);
    pause( 2 );
    close all;

end

% function that performs block smoothing over a 3x3 region
function output_image = Local_Smear_Routine( input_image )

    % storing the dimensions of the input image
    dimensions = size( input_image );
    
    % if the image is in RGB, converting to greyscale
    if length( dimensions ) > 2
        input_image = rgb2gray( input_image );
    end
    
    % converting imput image to double
    input_image = im2double(input_image);
    
    % initializing the output image
    output_image = input_image;
    
    % calculating the sum of the pixel values within the 3x3 matrix,
    % dividing the sum by 9, and setting the output pixel to the obtained
    % value one by one
    for row = 2 : (dimensions(2) -1)
        for col = 2 : (dimensions(1) -1 )
            summation = 0;
            for ii = -1 : 1
                for kk  = -1 : 1
                    summation = summation + input_image( col + ii, row + kk );
                end
            end
            output_image( col, row) = summation / 9;
        end
    end
    imagesc( output_image ); 
    colormap( gray );
    
end

% function that performs block smoothing over a MxM region
function output_image = local_weighting_routine( input_image, weights)
    % storing the dimensions of the weights matrix, a MxM matrix.
    wt_dims = size( weights );   
    
    % storing the dimensions of the image
    im_dims= size( input_image );
    
    % if the image is in RGB, converting to grayscale
    if length(im_dims) > 2 
        input_image = rgb2gray( input_image );
    end
    
    % initializing the values of Q, R, S, T
    T = fix(wt_dims(2) / 2);
    S = fix(wt_dims(1) / 2);

    Q = T + 1;
    R = S + 1;

     % converting imput image to double
    input_image = im2double(input_image);
    
    % initialzling the output image
    output_image = input_image;
    
    % calculating the sum of the pixel values within the MxM matrix,
    % dividing the sum by the sum of the weights, and setting the output 
    % pixel to the obtained value one by one
    for row = Q: (im_dims(2) - Q - 1 )
        for col = R: (im_dims(1) -R -1 )
            summation = 0;
            for ii = -S : S
                for kk  = -T : T
                    summation = summation + input_image( col + ii, row+ kk) * ... 
                                weights( R + ii, Q + kk );
                end
            end
            output_image( col, row ) = summation/sum(sum(weights));
        end
    end
    imagesc( output_image );  
    colormap( gray );

end