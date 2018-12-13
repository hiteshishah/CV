% Name: Hiteshi Shah (hss7374)
% Homework 11
%
function HW11_Shah_Hiteshi_MAIN( fn )

    addpath( '../TEST_IMAGES');
    addpath( '../../TEST_IMAGES');
    
    im = imread( fn );
    
    % converting image to binary for morphological operations
    im_bw = im2bw(im);
    
    % using the closing operation on the image to make the white specks 
    % in the background go away as well as enhance the white washers
    se = strel('disk', 20);
    im_c = imclose(im_bw, se);
    
    % resizing the image to scale down the radii to be detected
    im_c = imresize(im_c, 0.35);
    
    % using bwlabel to get the label matrix of the white washers
    [L, n] = bwlabel(im_c);
    
    % displaying the scaled down version of the original image
    figure, imshow(imresize(im, 0.35)), hold on
    for idx = 1:n
       % getting the labeled matrix at the current index
       circle = (L == idx);
       
       % using the hough transform to find circles in the current labelled
       % matrix of radii ranging from 30 to 100
       [centers, radii] = imfindcircles(circle ,[30 100]);
       
       % displaying the circles found by the hough transform
       if length(radii) > 1
           centersStrong = centers(1:length(centers),:); 
       else
           centersStrong = centers(1:length(centers));
       end
       radiiStrong = radii(1:length(radii));
       viscircles(centersStrong, radiiStrong,'EdgeColor','m');
       
       % plotting the centers of each circle
       for i = 1:length(radii)
            plot( centers(i, 1), centers(i, 2), 'm+', 'LineWidth', 2, 'MarkerSize', 20 );
       end
    end

end