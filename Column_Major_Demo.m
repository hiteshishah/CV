function Column_Major_Demo() 

    mm = magic( 3 );

    
    loop_counter = 1;
    for vec = mm
        fprintf('Loop Counter = %d  ', loop_counter );
        
        fprintf('%d, ', vec );
        
        fprintf('\n');
        loop_counter = loop_counter + 1;
    end
    
    
    fprintf('done\n');
end
