function Revectorization_Demo(  str  ) 

    fprintf('%-16s, end\n', str );
    
    amt_to_add = 5;
    fprintf('%02d, \n', amt_to_add);
    
    mm = magic( 5 );

    ss = mm(:) + amt_to_add;
    
    
    fprintf('done\n');
end
