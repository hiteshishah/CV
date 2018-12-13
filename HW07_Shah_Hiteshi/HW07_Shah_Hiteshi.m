% Name: Hiteshi Shah (hss7374)
% Homework 7
%

% main routing that calls all the other functions
function HW07_Shah_Hiteshi()

    addpath( '../TEST_IMAGES/');
    addpath( '../../TEST_IMAGES/');
    addpath( '../../../TEST_IMAGES/');
    
    HW07_part2_Changing_K( 'BALLS_FOUR_5244_shrunk.jpg' );
    HW07_part2_Changing_K( 'MACBETH_HW09_shrunk.jpg' );

    HW07_part3a_DistanceWts( '302008.jpg' );
    
    HW07_part3b_Euclidean_vs_CityBlock('BALLS_FOUR_5244_shrunk.jpg');
    
    HW07_part3c_198023('198023.jpg');
    
    HW07_part3d_Color_Spaces_Impact( 'BALLS_FOUR_5244_shrunk.jpg');
    HW07_part3d_Color_Spaces_Impact('MACBETH_HW09_shrunk.jpg');
    HW07_part3d_Color_Spaces_Impact('198023.jpg');
    
    HW07_part4_portrait();
    
    HW07_part5_Edge_Strength_Bonus( 'MACBETH_HW09_shrunk.jpg');

end