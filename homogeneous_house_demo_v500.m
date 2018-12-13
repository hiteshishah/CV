function homogeneous_house_demo_v500() 
% Demo of using Homogeneous Coords to translate,
% scale, rotate, etc... 
%
% Dr. Thomas B. Kinsman,
% Oct 31, 2017
% Happy Halloween.
%
% NOTE THAT ROTATION IS ALWAYS AROUND THE ORIGIN.
% So, to just twist the house, we:
%
% A.  Translate the origin to the center of the house.
%
% B.  Do the rotation.
%
% C.  Translate the origin back to the bottom left 
%     with respect to the house.
%
% The same sort of argument goes for shrinking things.
%
% Remember: 
% For this example, data is arranged in rows.
% For example, the rows of the house_xy matrix is a row of x values,
% then a row of y values, then a row of 1's.
%
% For situations where x values are a column on the left, then the y values are a column in the middle,
% a the right hand side is a column of 1's --> the matrices are post-multiplied, many of the matrices 
% are transposed, and the order of multiplications is left-for-right.
%

    hxy = load_xys( );                      % Get homogeneous (X,Y) points.
    
    plot( hxy(1,:), hxy(2,:), 'k-' );
    axis([-3 10 -3 10]);
    figure( gcf );
    pause(2);
    
    % Create a matrix to translate the center of the house,
    % at (6,3) to the origin:
    TranslationA = [ 1 0 -6 ;
                     0 1 -3 ;
                     0 0  1 ];
    new_pts = TranslationA * hxy;
    plot( new_pts(1,:), new_pts(2,:), 'k-' );
    
    axis([-3 10 -3 10]);
    figure( gcf );
    pause(2);
    
    % Create a matrix to scale all the points in by a 
    % factor of 0.5.
    %
    % (Tiny houses are in fashion.)
    %
    ScaleB = [ 1/2  0   0 ;
                0  1/2  0 ;
                0   0   1 ];
    new_pts = ScaleB * TranslationA * hxy;
    plot( new_pts(1,:), new_pts(2,:), 'k-' );
    
    axis([-3 10 -3 10]);
    figure( gcf );
    pause(2);
    
    % Create a matrix to rotate the points by some angle degrees.
    %
    theta   = 37;
    RotateA = [ cosd(theta)  -sind(theta)  0;
                sind(theta)   cosd(theta)  0;
                     0             0       1 ];
    new_pts = RotateA * ScaleB * TranslationA * hxy;
    plot( new_pts(1,:), new_pts(2,:), 'k-' );
    
    axis([-3 10 -3 10]);
    figure( gcf );
    pause(2);
    
    
    % Create a matrix to move the house back up to be 
    % centered at the point (4,6)
    %
    TranslationB = [ 1 0  4 ;
                     0 1  6 ;
                     0 0  1 ];
    new_pts = TranslationB * RotateA * ScaleB * TranslationA * hxy;
    plot( new_pts(1,:), new_pts(2,:), 'k-' );
    
    axis([-3 10 -3 10]);
    axis equal;                     % Make the units square.
    
    figure( gcf );
    pause(2);
    
    fprintf('\n');
    fprintf('The four operations can all be done with one combined matrix:\n\n');
    CombinedMatrix = TranslationB * RotateA * ScaleB * TranslationA
    
    %
    %  We can solve for that matrix, if we only knew the input points and 
    %  the resulting points:
    % 
    %         new_pts = MM * hxy
    %
    %  hxy and new_pts are both (3 by N).
    %
    %  Now, post-multiply both sides by the hxy transposed.  
    %  On the left this becomes (3 by N ) * ( N by 3 ).
    %  The inside dimensions cancel, and the left side becomes
    %  (3 by 3 ):
    %
    %         (new_pts * hxy.')  = MM * (hxy * hxy.') 
    %
    %  So, the left side is a (3 x 3 ) matrix.
    %  Let's hope that an inverse exists.  Then we can post-multiply both sides by inv( hxy * hxy.' ):
    %  
    %         (new_pts * hxy.') * inv( hxy * hxy.' ) = MM * (hxy * hxy.') * inv( hxy * hxy.' )
    %
    %  Anything times it's own inverse is the identity matrix.  
    %  So, the right hand side becomes:
    %
    %         (new_pts * hxy.') * inv( hxy * hxy.' ) = MM 
    %
    %  That's it.  That is what gives us the transformation matrix we would like.
    %  This should be ( 3 x 3 ).
    %  Let's check the dimensions:
    %
    %  ( 3 x N ) * ( N * 3 ) * inv( ( 3 x N ) * ( N x 3 ) )
    %  ( 3       x       3 ) * inv( ( 3       x       3 ) )
    %  ( 3                   x                        3   )
    %  
    %  So, it works, MM ends up being 3x3.
    %
    MM1 = (new_pts * hxy.') * inv( hxy * hxy.' )
    
    %  In Matlab we can use the slash operator to say, "Figure it out:"
    %
    %  new_pts = MM * hxy
    %  new_pts / hxy = MM
    MM2 = new_pts / hxy
    
    %  In some cases, especially when the data is stored in columns instead of
    %  rows, you use the backslash operator.
    %
    %  In any case, you can find the conversion matrix that goes from right to left,
    %  and from left to right.
    % 
    %  If   new_pts = MM2 * hxy
    %
    %  Then   inv(MM2) * new_pts  = inv(MM2) * MM2 * hxy
    %  or     inv(MM2) * new_pts  = hxy
    
    
    
end




function hxy = load_xys( )
% Return points which, when plotted, give a 
% representation of a house.
hxy = [ ...
    4.00  1.00  1.00 ;
    4.00  4.00  1.00 ;
    5.00  5.00  1.00 ;
    7.00  5.00  1.00 ;
    7.33  4.67  1.00 ;
    7.33  5.00  1.00 ;
    7.67  5.00  1.00 ;
    7.67  4.33  1.00 ;
    8.00  4.00  1.00 ;
    4.00  4.00  1.00 ;
    8.00  4.00  1.00 ;
    8.00  1.00  1.00 ;
    4.00  1.00  1.00 ;
    8.00  1.00  1.00 ;
    6.00  1.00  1.00 ;
    6.00  3.00  1.00 ;
    5.00  3.00  1.00 ;
    5.00  2.00  1.00 ;
    5.67  2.00  1.00 ;
    5.67  2.67  1.00 ;
    5.33  2.67  1.00 ;
    5.33  2.00  1.00 ;
    5.00  2.00  1.00 ;
    5.00  1.00  1.00 ;
    4.00  1.00  1.00 ;
    4.00  1.00  1.00 ;
];

% Return these as row vectors for homogeneous transformations
% using pre-fix notation.
hxy = hxy.';
    
end
