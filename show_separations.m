function show_separations( im_in, cell_array_of_names )
FS = 18;

    if ( nargin < 2 )
        % Default color names:
        cell_array_of_names = { 'RGB', 'RED', 'GREEN', 'BLUE' };
    end

    figure( 'Position', [10 10 1024 768] );
    
    subplot( 2, 2, 1 );
    imagesc( im_in );
    title( cell_array_of_names{1}, 'FontSize', FS );
    
    subplot( 2, 2, 2 );
    imagesc( im_in(:,:,1) );
    title( cell_array_of_names{2}, 'FontSize', FS );
    
    subplot( 2, 2, 3 );
    imagesc( im_in(:,:,2) );
    title( cell_array_of_names{3}, 'FontSize', FS );
    
    subplot( 2, 2, 4 );
    imagesc( im_in(:,:,3) );
    title( cell_array_of_names{4}, 'FontSize', FS );
    
    colormap( gray );
    drawnow;
end