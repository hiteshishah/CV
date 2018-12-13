% Name: Hiteshi Shah (hss7374)
% Homework 8
%

function HW08_Shah_Hiteshi_MAIN( fn )

    addpath( '../TEST_IMAGES');
    
    im = imread(fn);
    
    % checking if the image is in landscape mode and rotating if it's not
    dims = size(im);
    if dims(1) > dims(2)
       im = imrotate(im); 
    end
    
    fprintf("INPUT FILE NAME: %s\n", fn);
    
    % using only the red channel for this image to make the red logo on
    % the dice to blend into it
    im = im(:,:,1);
    
    % converting the image from grayscale to binary
    level = graythresh(im);
    im_bw = imbinarize(im, level);
    
    % using the erosion operation on the image to make the white specks in
    % the background go away
    se = strel('disk', 4);        
    im_e = imerode(im_bw, se);
    
    % using the dilation operation on the image to make the black dots on
    % the white dice go away
    se = strel('square', 50);
    im_d = imdilate(im_e, se);
    
    % using bwlabel to get the number of dice in the image
    [im_count, n] = bwlabel(im_d);
    
    fprintf("Number of dice: %d\n", n);
    
    % initializing an array of 6 zeroes for counts of each of the dot 
    % numbers of the die
    dots = zeros(6, 1);
    
    % getting the boundaries of each of the connected components
    B = bwboundaries(im_count);
    
    % calculating the smallest rectangle bounding each of the compnents
    box = regionprops(im_count, 'BoundingBox');
    
    imshow(im_bw)
    
    % initializing the sum of all dots to zero
    sum = 0;
    
    % initializing the count of unknowns to zero
    unknowns = 0;
    
    hold on
    for idx = 1:n
       % plotting a red boundary around the current die
       boundary = B{idx};
       plot(boundary(:,2), boundary(:,1), 'r', 'LineWidth', 2);
       
       % reducing the binary image to just the bounding box of the current 
       % die and taking its complement
       num = box(idx).BoundingBox;
       im_crop = im_bw(num(2):num(2) + num(4), num(1):num(1) + num(3));
       im_crop = imcomplement(im_crop);

       % using the dilation operation on the image to make the black dots on
       % the white dice more prominent
       se = strel('disk', 6);        
       im_cd = imdilate(im_crop, se);
       
       % using bwlabel to get the number of dots on the current die and
       % adding it to the total sum
       [im_dots, d] = bwlabel(im_cd);
       d = d - 1;
       if d < 1
           unknowns = unknowns + 1;
       elseif d > 6
           unknowns = unknowns + 1;
       else
           dots(d) = dots(d) + 1;
       end
       sum = sum + d;
       
    end
    hold off
    
    % printing the counts of each of the dot numbers of the dice
    for k = 1:length(dots)
        fprintf("Number of %d 's: %d\n", k, dots(k));
    end
    
    fprintf("Number of unknowns: %d\n", unknowns);
    fprintf("Total of all dots: %d\n", sum);

end