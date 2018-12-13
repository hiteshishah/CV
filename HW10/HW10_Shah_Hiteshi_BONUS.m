function HW10_Shah_Hiteshi_BONUS( hwdir )

    cd(hwdir);
    imagefiles = dir('*.jpg'); 
    for ii=1:length(imagefiles)
        fn = imagefiles(ii).name;
        [im, left_line, top_line, right_line, bottom_line] = HW10_Shah_Hiteshi_MAIN( fn );
        imshow(im);
        pause(2);
    end

end