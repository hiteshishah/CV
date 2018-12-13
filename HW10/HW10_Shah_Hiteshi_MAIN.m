% Name: Hiteshi Shah (hss7374)
% Homework 10
%
function HW10_Shah_Hiteshi_MAIN( fn )

    addpath( '../TEST_IMAGES');
    
    % reading the filename and converting the image to double
    im = imread( fn );
    im = im2double(im);
    
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
        im = imrotate(im, 360-angle.Orientation);
        
        % calculating the smallest rectangle bounding the white object
        box = regionprops(L, 'BoundingBox');
        
        % reducing the binary image to just the bounding box of the white 
        % object
        num = box(1).BoundingBox;
        im_bw = im_bw(num(2)+40:num(2)+num(4)-40, num(1)+40:num(1)+num(3)-40);
        im = im(num(2)+40:num(2)+num(4)-40, num(1)+40:num(1)+num(3)-40);
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
        figure, imshow(im), hold on
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
        % plotting the line with the lowest y-value as the top line for the
        % box around the Sudoku
        top_line = [lines(min_y_k).point1; lines(min_y_k).point2];
        plot(top_line(:,1),top_line(:,2), 'm-', 'LineWidth',4);

        % plotting the line with the highest y-value as the bottom line for 
        % the box around the Sudoku
        bottom_line = [lines(max_y_k).point1; lines(max_y_k).point2];
        plot(bottom_line(:,1),bottom_line(:,2), 'm-', 'LineWidth',4);
        
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
        % plotting the line with the lowest x-value as the left line for 
        % the box around the Sudoku
        left_line = [lines(min_x_k).point1; lines(min_x_k).point2];
        plot(left_line(:,1),left_line(:,2), 'm-', 'LineWidth',4);

        % plotting the line with the highest x-value as the right line for
        % the box around the Sudoku
        right_line = [lines(max_x_k).point1; lines(max_x_k).point2];
        plot(right_line(:,1),right_line(:,2), 'm-', 'LineWidth',4);
        
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
        figure, imshow(im), hold on
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

        % plotting the line with the lowest x-value as the left line for 
        % the box around the Sudoku
        left_line = [lines(min_x_k).point1; lines(min_x_k).point2];
        plot(left_line(:,1),left_line(:,2), 'm-', 'LineWidth',4);

        % plotting the line with the highest x-value as the right line for 
        % the box around the Sudoku
        right_line = [lines(max_x_k).point1; lines(max_x_k).point2];
        plot(right_line(:,1),right_line(:,2), 'm-', 'LineWidth',4);

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

        % plotting the line with the lowest y-value as the top line for 
        % the box around the Sudoku
        top_line = [lines(min_y_k).point1; lines(min_y_k).point2];
        plot(top_line(:,1),top_line(:,2), 'm-', 'LineWidth',4);

        % plotting the line with the highest y-value as the bottom line for 
        % the box around the Sudoku
        bottom_line = [lines(max_y_k).point1; lines(max_y_k).point2];
        plot(bottom_line(:,1),bottom_line(:,2), 'm-', 'LineWidth',4); 
    end
    
end