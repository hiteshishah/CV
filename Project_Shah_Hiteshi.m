% Name: Hiteshi Shah (hss7374)
% Final Project
%
function Project_Shah_Hiteshi( fn )

    addpath( '../TEST_IMAGES');
    
    % reading the filename and converting the image to double
    im = imread( fn );
    im = im2double(im);
    
    % using the function to get the binary image along with co-ordinates
    % for all four lines of the Sudoku puzzle
    [im_bw, top_line, bottom_line, left_line, right_line] = HW10_Shah_Hiteshi_MAIN(im);
    
    % taking the complement of the binary image returned by the function
    % to get back the original binary image
    im_bw = imcomplement(im_bw);
    
    % creating a mask using the coordinates of the four lines of the Sudoku
    % puzzle
    top_xs = top_line(:,1); top_ys = top_line(:,2); 
    right_xs = right_line(:,1); right_ys = right_line(:,2);
    bottom_xs = bottom_line(:,1); bottom_ys = bottom_line(:,2);
    left_xs = left_line(:,1); left_ys = left_line(:,2);
    [top_x, top_x_ind] = min(top_xs);
    top_y = top_ys(top_x_ind);
    [right_y, right_y_ind] = min(right_ys);
    right_x = right_xs(right_y_ind);
    [bottom_x, bottom_x_ind] = max(bottom_xs);
    bottom_y = bottom_ys(bottom_x_ind);
    [left_y, left_y_ind] = max(left_ys);
    left_x = left_xs(left_y_ind);
    xs = [top_x; right_x; bottom_x; left_x];
    ys = [top_y; right_y; bottom_y; left_y];
    mask = poly2mask(xs, ys, size(im_bw, 1), size(im_bw, 2));
    
    % masking out the background to get the ROI
    final_image = im_bw & mask;
    
    % calculating the angle by which to rotate the image so that the puzzle
    % is upright
    angle = regionprops(mask, 'Orientation');
    if abs(angle.Orientation) >= 50 && abs(angle.Orientation) <= 90
        angle.Orientation = 90 - abs(angle.Orientation);
    end
    
    % rotating the mask (for obtaining the BoundingBox) as well as the image
    mask =  imrotate(mask, angle.Orientation - 4);
    final_image = imrotate(final_image, angle.Orientation - 4);
    
    % calculating the smallest rectangle bounding the puzzle and cropping
    % out the rest of the image
    box = regionprops(mask, 'BoundingBox');
    box = box.BoundingBox;
    final_image = final_image(box(2):box(2)+box(4), box(1):box(1)+box(3));
    
    % using the open operation on the image to make the black dots on
    % the white background go away while not losing the black text
    se = strel('square', 4);
    final_image = imopen(final_image, se);
    
    % using the erosion operation on the image to make the black text more
    % prominent
    se = strel('square', 3);
    final_image = imerode(final_image, se);
    
    % using bwlabel to get the labeled matrix and the number of squares in
    % the puzzle
    [L, n] = bwlabel(final_image);
    
    % using the "Extrema" property on the labeled matrix in order to sort
    % the squares of the puzzle using the left-most-bottom coordinate so
    % that the squares of the puzzle can be traversed in the right order
    % ,i.e, from top left to bottom right
    s = regionprops(L, 'BoundingBox', 'Extrema', 'Centroid', 'PixelIdxList');
    extrema = cat(1, s.Extrema);    
    left_most_bottom = extrema(6:8:end, :);
    left = left_most_bottom(:, 1);
    bottom = left_most_bottom(:, 2);
    bottom = 6 * round(bottom / 6);
    [sorted, sort_order] = sortrows([bottom left]);
    s2 = s(sort_order);
    
    % using the "PixelIdxList" property to relabel the matrix
    for k = 1:numel(s2)
       kth_object_idx_list = s2(k).PixelIdxList;
       L(kth_object_idx_list) = k;
    end
    
    % initializing the puzzle
    puzzle = [];
    
    % initializing a counter for the squares in the puzzle to combat the
    % empty components returned by bwlabel
    count = 0;
    
    % getting a fraction of the image size to calculate the number of
    % pixels to shave off all four edges of each of the squares as a
    % precautionary measure against any remnant noise
    pix = 0.02 * size(final_image, 1);
    
    % a list of dupes that the OCR could mistake the numbers 1 and 5 for
    dupes = ["l", "I", "S"];
    ones = ["l", "I"];
    
    for idx = 1:n
        % getting the current square from the labeled matrix
        block = (L==idx);
        
        % calculating the smallest rectangle bounding the square and
        % cropping out the rest of the background
        num = regionprops(block, 'BoundingBox');
        num = num.BoundingBox;
        block = final_image(num(2)+pix:num(2)+num(4)-pix, num(1)+pix:num(1)+num(3)-pix);
        
        if ~isempty(block)
            % incrementing the counter for the number of squares
            count = count + 1;
            
            % initializing an array for the first square of every row
            if mod(count - 1, 9) == 0
                row = [];
            end
            
            % reading the text from the current square
            text = ocr(block, 'TextLayout', 'Block');
            
            if ~isempty(text.Words)
                word = text.Words{1};
                
                % if the text contains a number or any one of the dupes,
                % adding the number to the end of the current row
                if ~isempty(regexp(word, '\d', 'once')) || ismember(word, dupes)
                    if ismember(word, ones)
                        row = [row, "1"];
                    elseif word == "S"
                         row = [row, "5"];   
                    else
                        i = regexp(word, '\d');
                        row = [row, word(i)+""];
                    end
                end
            else
                % if the returned text is empty, adding a comma to the end
                % of the current row to indicate an empty square in the
                % puzzle
                row = [row, ","];
            end
            
            % adding the row to the puzzle if the current square is the
            % last square of the row 
            if mod(count, 9) == 0
                puzzle = [puzzle; row];
            end
        end
    end  
    
    % printing the contents of the puzzle
    for row = 1:9
        for col = 1:9
            fprintf("%s ", puzzle(row, col));
        end
        fprintf("\n");
    end
    
end

% function from Homework 10 that returns the four edges of the Sudoku
% puzzle using the Hough transform
function [im_bw, top_line, bottom_line, left_line, right_line] = HW10_Shah_Hiteshi_MAIN( im )
    
    % converting image to binary for morphological operations
    im_bw = im2bw(im);
    
    % checking if the image has a black background
    if im_bw(1, 1) == 0
        
        % using the erosion operation on the image to make the white specks 
        % in the background go away
        se = strel('disk', 4);
        im_e = imerode(im_bw, se);
        
        % using the dilation operation on the image to make the black text
        % on the white paper go away
        se = strel('square', 50);
        im_d = imdilate(im_e, se);
        
        % using bwlabel to get the label matrix of the white object
        L = bwlabel(im_d);
        
        % calculating the angle of the white object w.r.t the x-axis
        angle = regionprops(L, 'Orientation');
        
        % rotating the image so that the puzzle is upright
        L = imrotate(L, 360-angle.Orientation);
        im_bw = imrotate(im_bw, 360-angle.Orientation);
        
        % calculating the smallest rectangle bounding the white object
        box = regionprops(L, 'BoundingBox');
        
        % reducing the binary image to just the bounding box of the white 
        % object
        num = box(1).BoundingBox;
        im_bw = im_bw(num(2)+40:num(2)+num(4)-40, num(1)+40:num(1)+num(3)-40);
    end
    
    % taking the complement of the binary image
    im_bw = imcomplement(im_bw);
    
    % using the erosion operation to reduce the text in the image
    se = strel('square', 3);
    bw = imerode(im_bw, se);
    
    % using the dilation operation make the Sudoku borders more prominent
    se = strel('line', 5.5, 0);
    bw2 = imdilate(bw, se);
    
    % using the hough transform to find lines in the image
    [H,theta,rho] = hough(bw2);
    P = houghpeaks(H,30);
    lines = houghlines(bw2,theta,rho,P);
    
    % initializing the count for the highest number of lines having the
    % same length
    max_count = 0;
    
    % initialzing the length for the highest number of lines with the same
    % length
    max_len = 0;
    
    % initializing the index for the highest number of lines having the
    % same length
    max_len_k = 0;
    
    for k = 1:length(lines)
       % initialzing the count for all lines having the same length as the 
       % current line
       count = 0;
       
       % getting the current line and calculating its length
       line1 = [lines(k).point1; lines(k).point2];
       len1 = pdist(line1,'euclidean');
       
       % loop for all the lines after the current line
       for j = k+1:length(lines)
           % getting the next line and calculating its length
           line2 = [lines(j).point1; lines(j).point2];
           len2 = pdist(line2,'euclidean');
           
           % if their lengths are the same, incrementing the count
           if len2 == len1
               count = count + 1;
           end
       end
       % checking if current count is greater than the previous maximum
       % count
       if count > max_count
           % saving the count, length and index
           max_count = count;
           max_len = len1;
           max_len_k = k;
       end
    end
    
    % calculating the angle of the line with index max_len_k w.r.t the
    % x-axis
    max_len_line_angle = 90 - lines(max_len_k).theta;
    
    % checking if the line is horizontal
    if max_len_line_angle == 180
        % initializing the y-value for the top line
        min_y = 1000;
        % initializning the index for the top line
        min_y_k = 0;

        % initializing the y-value for the bottom line
        max_y = 0;
        % initializing the index for the bottom line
        max_y_k = 0;
    
        % displaying the original image
        for k = 1:length(lines)
            % getting the current line and calculating its length
            line = [lines(k).point1; lines(k).point2];
            len = pdist(line,'euclidean');
            
            % checking if the length of the current line is the same as
            % max_len (with a tolerance of 9)
            if len >= max_len - 9 && len <= max_len + 9
                % storing the index of the line with the smallest y-value
                if min(line(:,2)) < min_y
                    min_y = min(line(:,2));
                    min_y_k = k;
                end
                % storing the index of the line with the highest y-value
                if max(line(:,2)) > max_y
                    max_y = max(line(:,2));
                    max_y_k = k;
                end
            end
        end
        % the line with the lowest y-value is the top line for the box 
        % around the Sudoku
        top_line = [lines(min_y_k).point1; lines(min_y_k).point2];

        % the line with the highest y-value is the bottom line for the box 
        % around the Sudoku
        bottom_line = [lines(max_y_k).point1; lines(max_y_k).point2];
        
        % calculating the angle of the top line w.r.t the x-axis
        top_line_angle = 90 - lines(min_y_k).theta;
        
        % initializing the x-value for the left line
        min_x = 1000;
        % initializing the index for the left line
        min_x_k = 0;

        % initializing the x-value for the right line
        max_x = 0;
        % initializing the index for the right line
        max_x_k = 0;

        for k = 1:length(lines)
            % getting the current line and calculating its angle w.r.t the
            % x-axis
            line = [lines(k).point1; lines(k).point2];
            angle = 90 - lines(k).theta;
            
            % checking if the angle between the top line and the current
            % line is 90
            if abs(top_line_angle - angle) == 90
                % calculating the four determinants to check for
                % intersection between the two lines
                x = [top_line(:,1) line(:,1)];
                y = [top_line(:,2) line(:,2)];
                first = [x(1)-x(3) x(2)-x(3); y(1)-y(3) y(2)-y(3)];
                second = [x(1)-x(4) x(2)-x(4); y(1)-y(4) y(2)-y(4)];
                third = [x(3)-x(1) x(4)-x(1); y(3)-y(1) y(4)-y(1)];
                fourth = [x(3)-x(2) x(4)-x(2); y(3)-y(2) y(4)-y(2)];
                dt1 = det(first);
                dt2 = det(second);
                dt3 = det(third);
                dt4 = det(fourth);
                
                % checking if the lines intersect
                if (dt1 <= 0 && dt2 >= 0) || (dt1 >= 0 && dt2 <= 0)
                   if (dt3 <= 0 && dt4 >= 0) || (dt3 >= 0 && dt4 <= 0)
                       % storing the index of the line with the smallest x-value
                       if min(line(:,1)) < min_x
                           min_x = min(line(:,1));
                           min_x_k = k;
                       end
                       % storing the index of the line with the highest x-value
                       if max(line(:,1)) > max_x
                           max_x = max(line(:,1));
                           max_x_k = k;
                       end
                   end
                end
            end
        end
        % the line with the lowest x-value is the left line for the box 
        % around the Sudoku
        left_line = [lines(min_x_k).point1; lines(min_x_k).point2];

        % the line with the highest x-value is the right line for the box 
        % around the Sudoku
        right_line = [lines(max_x_k).point1; lines(max_x_k).point2];
        
    % if the line with index max_len_k is not horizontal    
    else
        % initializing the x-value for the left line
        min_x = 1000;
        % initializing the index for the left line
        min_x_k = 0;

        % initializing the x-value for the right line
        max_x = 0;
        % initializing the index for the right line
        max_x_k = 0;
        
        % displaying the original image
        for k = 1:length(lines)
            % getting the current line and calculating its length
            line = [lines(k).point1; lines(k).point2];
            len = pdist(line,'euclidean');
            
            % checking if the length of the current line is the same as
            % max_len (with a tolerance of 3)
            if len >= max_len - 3 && len <= max_len + 3
                % storing the index of the line with the smallest x-value
                if min(line(:,1)) < min_x
                    min_x = min(line(:,1));
                    min_x_k = k;
                end
                % storing the index of the line with the highest x-value
                if max(line(:,1)) > max_x
                    max_x = max(line(:,1));
                    max_x_k = k;
                end
            end
        end

        % the line with the lowest x-value is the left line for the box 
        % around the Sudoku
        left_line = [lines(min_x_k).point1; lines(min_x_k).point2];

        % the line with the highest x-value is the right line for the box
        % around the Sudoku
        right_line = [lines(max_x_k).point1; lines(max_x_k).point2];
        
        % calculating the angle of the left line w.r.t the x-axis
        left_line_angle = 90 - lines(min_x_k).theta;

        % initializing the y-value for the top line
        min_y = 1000;
        % initializning the index for the top line
        min_y_k = 0;

        % initializing the y-value for the bottom line
        max_y = 0;
        % initializing the index for the bottom line
        max_y_k = 0;

        for k = 1:length(lines)
            % getting the current line and calculating its angle w.r.t the
            % x-axis
            line = [lines(k).point1; lines(k).point2];
            angle = 90 - lines(k).theta;
            
            % checking if the angle between the top line and the current
            % line is 90
            if abs(left_line_angle - angle) == 90
                % calculating the four determinants to check for
                % intersection between the two lines
                x = [left_line(:,1) line(:,1)];
                y = [left_line(:,2) line(:,2)];
                first = [x(1)-x(3) x(2)-x(3); y(1)-y(3) y(2)-y(3)];
                second = [x(1)-x(4) x(2)-x(4); y(1)-y(4) y(2)-y(4)];
                third = [x(3)-x(1) x(4)-x(1); y(3)-y(1) y(4)-y(1)];
                fourth = [x(3)-x(2) x(4)-x(2); y(3)-y(2) y(4)-y(2)];
                dt1 = det(first);
                dt2 = det(second);
                dt3 = det(third);
                dt4 = det(fourth);
                
                % checking if the lines intersect
                if (dt1 <= 0 && dt2 >= 0) || (dt1 >= 0 && dt2 <= 0)
                   if (dt3 <= 0 && dt4 >= 0) || (dt3 >= 0 && dt4 <= 0)
                       % storing the index of the line with the smallest y-value
                       if min(line(:,2)) < min_y
                           min_y = min(line(:,2));
                           min_y_k = k;
                       end
                       % storing the index of the line with the highest y-value
                       if max(line(:,2)) > max_y
                           max_y = max(line(:,2));
                           max_y_k = k;
                       end
                   end
                end
            end
        end

        % the line with the lowest y-value is the top line for the box 
        % around the Sudoku
        top_line = [lines(min_y_k).point1; lines(min_y_k).point2];

        % the line with the highest y-value is the bottom line for the box
        % around the Sudoku
        bottom_line = [lines(max_y_k).point1; lines(max_y_k).point2];
    end
    
end