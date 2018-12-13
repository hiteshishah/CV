% Name: Hiteshi Shah (hss7374)
% Homework 7
%

% function that uses a color map for segmentation
function HW07_part2_Changing_K( fn )

    im = imread( fn );

    % blurring the image as a method of noise removal
    fltr = fspecial( 'gaus', 5, 1 );
    im_out = imfilter( im, fltr, 'same', 'replicate');

    % for values of k from 5 to 256, compute a new colormap and display
    % only when k ias a power of 2
    for k = 5: 256
        [im_ind, map] = rgb2ind(im_out, k, 'nodither');
        [n, x] = log2(k);
        if n == 0.5
            figure
            imagesc(im_ind)
            colormap(map)
            title(strcat("k = ", num2str(k)))
        end
    end

end