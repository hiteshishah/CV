% Name: Hiteshi Shah (hss7374)
% Homework 6
%

% main function
function HW06_Shah_Hiteshi_main( input_image )

    addpath( '../TEST_IMAGES/');
    addpath( '../../TEST_IMAGES/');
    
    input_image = rgb2gray( im2double( imread(input_image) ));

    subplot(2, 4, 1); imagesc( input_image ); title("Original");
    subplot(2, 4, 2);
    weights = [-1 -2 -1 ; 0 0 0 ; 1 2 1 ] / 8;
    tic;
    im_new = local_weighting_routine( input_image, weights); 
    time = toc;
    fprintf("Manual time for filter A: %g\n", round(time, 3));
    imagesc( im_new ); title("Edge Detector A");
    
    tic;
    output_image = imfilter( input_image, weights, 'same', 'replicate');
    time = toc;
    fprintf("imfilter time for filter A: %g\n\n", round(time, 3));
    
    subplot(2, 4, 3);
    weights = [-1 0 1 ; -2 0 2 ; -1 0 1 ] / 8;
    tic;
    im_new = local_weighting_routine( input_image, weights); 
    time = toc;
    fprintf("Manual time for filter B: %g\n", round(time, 3));
    imagesc( im_new ); title("Edge Detector B");
    
    tic;
    output_image = imfilter( input_image, weights, 'same', 'replicate');
    time = toc;
    fprintf("imfilter time for filter B: %g\n\n", round(time, 3));
    
    subplot(2, 4, 4);
    weights = [-1 0 0 0 1 ; -2 0 0 0 2 ; -1 0 0 0 1 ] / 16;
    tic;
    im_new = local_weighting_routine( input_image, weights);
    time = toc;
    fprintf("Manual time for filter C: %g\n", round(time, 3));
    imagesc( im_new ); title("Edge Detector C");
    
    tic;
    output_image = imfilter( input_image, weights, 'same', 'replicate');
    time = toc;
    fprintf("imfilter time for filter C: %g\n\n", round(time, 3));
    
    subplot(2, 4, 5);
    weights = [-2 0 0 0 0 0 0 0 2 ; -3 0 0 0 0 0 0 0 3 ; -2 0 0 0 0 0 0 0 2 ] / 56;
    tic;
    im_new = local_weighting_routine( input_image, weights);
    time = toc;
    fprintf("Manual time for filter D: %g\n", round(time, 3));
    imagesc( im_new ); title("Edge Detector D");
    
    tic;
    output_image = imfilter( input_image, weights, 'same', 'replicate');
    time = toc;
    fprintf("imfilter time for filter D: %g\n\n", round(time, 3));
    
    subplot(2, 4, 6);
    weights = [0 1 0; 1 -4 1; 0 1 0];
    tic;
    im_new = local_weighting_routine( input_image, weights);
    time = toc;
    fprintf("Manual time for filter E: %g\n", round(time, 3));
    imagesc( im_new ); title("Edge Detector E");
    
    tic;
    output_image = imfilter( input_image, weights, 'same', 'replicate');
    time = toc;
    fprintf("imfilter time for filter E: %g\n\n", round(time, 3));
    
    subplot(2, 4, 7);
    fltr = fspecial('laplacian', 1);
    tic;
    im_new = local_weighting_routine( input_image, fltr);
    time = toc;
    fprintf("Manual time for filter F: %g\n", round(time, 3));
    imagesc( im_new ); title("Edge Detector F");
    
    tic;
    output_image = imfilter( input_image, fltr, 'same', 'replicate');
    time = toc;
    fprintf("imfilter time for filter F: %g\n\n", round(time, 3));
    
    subplot(2, 4, 8);
    fltr = fspecial('log', 9);
    tic;
    im_new = local_weighting_routine( input_image, fltr);
    time = toc;
    fprintf("Manual time for filter G: %g\n", round(time, 3));
    imagesc( im_new ); title("Edge Detector G");
    
    tic;
    output_image = imfilter( input_image, fltr, 'same', 'replicate');
    time = toc;
    fprintf("imfilter time for filter G: %g\n\n", round(time, 3));
    
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
    
    % initialzling the output image
    output_image = input_image;
    
    % calculating the sum of the pixel values within the MxM matrix,
    % dividing the sum by the sum of the weights, and setting the output 
    % pixel to the obtained value one by one
    for row = Q: (im_dims(2) - Q - 1 )
        for col = R: (im_dims(1) - R -1 )
            summation = 0;
            for ii = -S : S
                for kk  = -T : T
                    summation = summation + input_image( col + ii, row+ kk) * ... 
                                weights( R + ii, Q + kk );
                end
            end
            output_image( col, row ) = summation/sum(weights(:));
        end
    end
    imagesc( output_image );  
    colormap( gray );

end