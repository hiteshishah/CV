% HW01 Instructions
%
% Create a file called ÒHW01_<your last name w/o spaces>_<your first nameÉ>.m
% In it put the commands from the following, and add your answers.
% You can add your answer using the display command:
disp('Answer 0:  Put your answers to the questions here, so that when the');
disp('Command is run, they will print out.'); 
fprintf('\n')

% Compare element-wise versus array-wise operations on matrices:
%
% See the documentation for the magic() function "doc magic", and create a 4x4 magic square: 
m4 = magic(4);

% Q1: What does this operation do?
%    Does it work on the entire matrix or on each element?
m4.^2;
disp('Ans 1: This operator squares each element of the matrix');
fprintf('\n')

% Q2: What does this operation do?
%    Does it work on the entire matrix or on each element?
m4^2;
disp('Ans 2: This operator squares the entire matrix, i.e., it performs m4 * m4');
fprintf('\n')

%
%  Notice when there are, or are-not, semicolons on the end of the lines.
%
% Q3: Can you generate a 7x7 magic square?
%    (This defines the variable m7?)
%
m7 = magic(7);

% Q4: Print out one element:
altuae = m7( 5, 5 )


% Q5:  Extract a sub-matrix from rows 1 to 4, and columns 1 to 2:
submat = m7( 1:4, 1:2 )


% Q6: Treat the entire matrix as one long vector, and print the 34th element:
m7(34)


% Q7:  If we wanted to print element #34 using (row,col) notation, what notation would we use
%  Demonstrate that here
[row, col] = ind2sub(size(m7), 34);
m7(row, col)

% Q8: Extract the last row:

%  Remember that you can use ÒendÓ as the last element of a dimension. 
%  This will be on a quiz later
%
m7( end, : )


% Q9: What command would I use to get this row of the matrix, m7:
%   38    47     7     9    18    27    29
% ANS:  write the command and execute it.
m7(2, :)


% Q10: Extract the 4th column, and transpose it using the .' operator:
%
% REM:
% The .' works on the values.  
% The ' operator alone converts imaginary values.
%
% Does it print as a row or a column?
m7(: ,4).'
disp('Ans 10: It prints as a row')
fprintf('\n')

% Q11: Read in the cameraman image, from the Matlab image example repository:
im_cam = imread( 'cameraman.tif' );
imshow( im_cam );

% Q12: Get a sub-section of the cameraman, and show just the heads of the man and the tripod:
im_cam_head = im_cam( 35:83  , 97:176  );
imshow( im_cam_head );


% Q13: What command would you use to isolate the part of the image that is the 
% faint building in the back right side?
im_subset =  im_cam( 124:161  , 214:243  ); ...  your command to get that image here ...
imagesc( im_subset );
pause( 3 ); 				% This waits 3 seconds.

% Q14:  Read in the peppers.png image:
im_peppers = imread( 'peppers.png' );
imshow( im_peppers );


% Q15:
% Get a sub-section of the peppers image, and display it:
%
% WHY DO I NEED THE THIRD PARAMETER HERE?? 
% I DIDN'T USE THAT FOR THE CAMERA MAN?
%
% ANS:
sub_im = im_peppers(  164:255   ,  200:312  , :  );
imshow( sub_im );
disp('Ans 15: The third dimension stores the RGB values of each pixel.')
disp('Without this, it returns the subsection in grayscale' )
fprintf('\n')


% Q16:
% Go back to the camera man:
%
% Let's multiply the values, to see the dark regions better.
% Does this help us see the dark regions?
% Does it hide any regions?
%
% ANS ALL QUESTIONS:
im_cam_mult = im_cam * 4 ; 
imagesc( im_cam_mult );
disp('Ans 16: It scales each value of the image by a factor of 4,')
disp('making the dark regions darker and bright regions brighter.')
disp('This high contrast helps to see the dark regions but the other regions blend into each other.')
fprintf('\n')

% Q17:   Try this version, what is different?
% ANS:
im_cam_mult = im2double( im_cam ) * 4;
imagesc( im_cam_mult );
disp('Ans 17: This version is a lot more bluer (cool-towned) than the previous one');
fprintf('\n')





% Q18: When we do this what does it do? Does it help us see his pockets?
%      Why or why not?  What did we do to the image?  What can you not see?
%
%  Now I am going to clip the current im_cam_mult image to a maximum 
%  value of 1, and re-display it.
im_cam_mult( im_cam_mult > 1.0 ) = 1.0;
imagesc( im_cam_mult );
disp('Ans 18: It looks similar to an earlier version where the dark regions');
disp('become darker and bright regions are brighter. This high contrast');
disp('helps to see the dark regions like the pockets but the other regions');
disp('blend into each other.')
fprintf('\n')


% That operation selects only the values of the image that are over 1.0, 
% and those are set to 1.0
% It does this by creating a temporary boolean variable "im_cam_mult > 1.0", 
% and using it to impact only those pixels.

% Lets get a clean copy of the cameraman, and mess up the values:
im_uint8  = imread('cameraman.tif');
im_double = im2double( im_uint8 );

% Q19: What do the following commands emphasize about the image?
%  How do they differ?
%
% ANS:
im_new = im_double.^3 ;
imagesc( im_new ); 

im_new = im_double.^(1/2.8);
imagesc( im_new );

disp('Ans 19: In the first command where each value of the image is raised by 3,');
disp('the final output turns out to be a darker version of the original.');
disp('In the second command where each value of the image is raised by 1/2.8,');
disp('the final output turns out to be a lighter version of the original.');
fprintf('\n')


% Q20:
% Read in the image, RED_GREEN_BLUE_YELLOW_MEMORY_COLORS.jpg
% Convert the image to a double format.
im = im2double( imread('RED_GREEN_BLUE_YELLOW_MEMORY_COLORS.jpg') );
% And display the following versions of the image


% Q20a: Display the image itself.
%  Then pause for two seconds  pause(2).
% put your code here ... 
imshow(im);
pause(2);

%
% Q20b: Display just the red   channel (the red color plane). 
%      Then pause for two seconds.
red = im;
red(:,:,2:3) = 0;
imshow(red);
pause(2)
disp('Ans 20b: The left top half of the color wheel vanishes.');
fprintf('\n')


%
% Q20c: Just the green channel (the green color plane). 
%      Then pause for two seconds.
% put your code here ...
green = im;
green(:,:,1) = 0; 
green(:,:,3) = 0;
imshow(green);
pause(2)
disp('Ans 20c: The left bottom half of the color wheel vanishes.');
fprintf('\n')

%
% Q20d: Just the blue  channel (the blue  color plane). 
%      Then pause for three seconds.
% put your code here ... 
blue = im;
blue(:,:,1) = 0; 
blue(:,:,2) = 0;
imshow(blue);
pause(2)
disp('Ans 20d: The right half of the color wheel vanishes.');
fprintf('\n')

%
% Q20e: The inverse of the image.
%      Then pause for two seconds.
% put your code here ... 
im_inverted = imcomplement(im);
imshow(im_inverted);
pause(2)

%
% Q20f: Display the first channel of inverted image.  
%      Just the first  channel.  What color is this?
%      Then pause for two seconds.
% put your code here ... 
%      What color is this?  ANS: 
first = im_inverted;
first(:,:,2:3) = 0;
imshow(first);
pause(2)
disp('Ans 20f: Red');
fprintf('\n')

%
% Q20g: Just the second channel.  What color is this?
%      Then pause for two seconds.
% put your code here ... 
%      What color is this?  ANS:
second = im_inverted;
second(:,:,1) = 0; 
second(:,:,3) = 0;
imshow(second);
pause(2)
disp('Ans 20g: Green');
fprintf('\n')

% Q20h: Just the third channel.
%      Then pause for three seconds.
% put your code here ... 
%      What color is this?  ANS:
third = im_inverted;
third(:,:,1) = 0; 
third(:,:,2) = 0;
imshow(third);
pause(2)
disp('Ans 20f: Blue');




% Q21 -- print the version of matlab you are using, and the associated toolboxes:
ver

pause(2);
% Close all images... 
close all;



