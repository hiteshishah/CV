function Fitting_Data_to_a_General_Conic_Equation_v030()
rand( 'seed', 7537 );
randn('seed', 7537 );

FFS = 18;
MS  = 11;


    % For this example, assume a circle, or radius R, centered at Cntr:
    R       = 3;                        % The radius of the circle.
    Cntr    = [ 3.75, 4.5 ];            % The (X,Y) Center of the circle.

    % Create some perfect points on the circle:
    thetas_perfect  = [  0 : 7.5 : 360 ];
    xs_perfect      = R * cosd( thetas_perfect ) + Cntr(1);
    ys_perfect      = R * sind( thetas_perfect ) + Cntr(2);
    
    %
    %  Generate some points near the perfect circle, but with random measurement noise added on:
    %
    %
    %  First, we add some noise to ~where~ they were measured, 
    %  by changing the thetas:
    %
    thetas          = thetas_perfect + randn( size(thetas_perfect) ) * 3;
    thetas          = thetas( 1:4:end );

    % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %
    %  Now, imagine you were given some points ~near~ these points that you
    %  measured, but not exactly.  These points would be similar to the ideal points,
    %  but they would have measurement error added into them.
    %
    %  This simulates measurement noise:
    %
    xs              = R * cosd( thetas ) + Cntr(1) + randn( size(thetas) ) / 2;
    ys              = R * sind( thetas ) + Cntr(2) + randn( size(thetas) ) / 2;

    %
    %  Now we compute the data matrix of all values -- the data which we want to fit our data to:
    %
    %  Fit Ax^2 + By^2 + Cx + Dy + 1 = 0;   % -- no XY Term.  
    %  This is the general form for an axially aligned ellipse,  
    %  but also includes a circle as a sub-set of the ellipse.
    %
    %  If we wanted to force a perfect circle, we would fit:
    %  Fit A (x^2 + y^2) + Cx + Dy + 1 = 0;
    %
    %  This assures that the term in front of the X^2 and Y^2 terms are identical.
    %  We aren't doing that in this case.
    %
    xs_squared      = xs.^2;
    ys_squared      = ys.^2;
    
    LHS             = [ xs_squared(:)  ys_squared(:)  xs(:)  ys(:)  ones(length(xs),1) ];
    LHS_SQRD        = LHS.' * LHS;
    
    [vecs, lambdas] = tbk_eig( LHS_SQRD );              % Returns sorted vectors and lambdas.
    
    Best_ABCD1      = vecs(:,end);                      % The Answer !!


    %
    %  Set up the quadratic equation to solve for the roots of f(y) = ay^2 + by + c.
    %
    %  f(y) = By^2 + Dy + (Ax^2 + Cx + 1)    --> THIS IS THE QUADRATIC EQUATION.
    %
    %  This is Y as a function of X.  It has two roots, which we find using the quadratic equation.
    %
    %  Normalize the fit of the equation by B :
    %
    Best_ABCD1      = Best_ABCD1 ./ Best_ABCD1(2);


    %
    %  Print an answer for human feedback:
    %
    fprintf('Best Fit Ellipse from this procedure is: ');
    fprintf('%6.5f X^2 + %6.5f Y^2 + %6.5f X   + %6.5f Y   + %6.5f = 0\n', ...
        Best_ABCD1 );
    
    fprintf('\n');
    fprintf('NOTES for human reader.\n');
    fprintf('This equation of a conic is in general form.  There are no parenthesis.\n');
    fprintf('\n');
    
    fprintf('[1]\n');
    fprintf('If this conic had only one squared term, then it would be a parabola aligned with one axis or another.\n');
    fprintf('\n');
    
    fprintf('[2]\n');
    fprintf('If this conic was a perfect line, the coefficients in front of the X^2 and Y^2 terms would both be zero.\n');

    fprintf('\n');
    fprintf('[3]\n');
    fprintf('If this conic was a perfect circle, the coefficients in front of the X^2 and Y^2 terms would both be equal.\n');

    fprintf('\n');
    fprintf('[4]\n');
    fprintf('If this conic was an ellipse, the coefficients in front of the X^2 and Y^2 terms would both have the same sign.\n');

    fprintf('\n');
    fprintf('[5]\n');
    fprintf('Otherwise, it must be a hyperbola.\n');


    % -------------------------------------------------------------------------------------
    %
    %  The  problem with a general conic form is that it is difficult to graph.
    %  Here we solve that problem by picking a bunch of X points, and then finding the 
    %  corresponding Y points for each X point.
    %
    %  In our case, each X point leads to two Y points.
    %
    %  Generate a bunch of points between the min X value used, and he max X value used.
    %  Then solve for each Y points associated with that x point:
    %
    %  
    %  And then we can do the reverse as well...
    %
    x_min           = min( xs(:) );
    x_max           = max( xs(:) );
    x_step          = ( x_max - x_min ) / 19;
    
    x_probes        = x_min : x_step : x_max;
    
    
    n_pts           = length(x_probes);             % The number of points we are fitting.
    
    %  Find the values of "a" for fitting the quadratic equation:
    as              = ones(1,n_pts);
    
    %  Find the values of "b" for fitting the quadratic equation:
    bs              = ones(1,n_pts) * Best_ABCD1(4);
    
    %  Find the values of "c" for fitting the quadratic equation:
    cs              = Best_ABCD1(1) * (x_probes.^2) + Best_ABCD1(3) * x_probes + Best_ABCD1(5);

    %  The part of the quadratic equation that is b^ - 4ac:
    b2_4ac          = bs.^2 - 4 * as .* cs;

    b_valid         = b2_4ac >= 0;
    pos_roots       = real( ( -bs + sqrt( b2_4ac ) ) ./ ( 2 * as ) );
    neg_roots       = real( ( -bs - sqrt( b2_4ac ) ) ./ ( 2 * as ) );
    
    fit_1_xs          = [ x_probes(b_valid)  x_probes(b_valid)  ];
    fit_1_ys          = [ pos_roots(b_valid) neg_roots(b_valid) ];
    
    % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %
    %  Now do the reverse to get more points -- these are X as a function of Y:
    %
    y_min           = min( ys(:) );
    y_max           = max( ys(:) );
    y_step          = ( y_max - y_min ) / 19;
    
    y_probes        = y_min : y_step : y_max;
    
    n_pts           = length(y_probes);             % The number of points we are fitting.
   
    %  Set up the quadratic equation to solve for the roots of f(x) = ax^2 + bx + c.
    %
    %  f(x) = Ax^2 + Cx + (By^2 + Dx + 1)    --> THIS IS ANOTHER QUADRATIC EQUATION.
    
    %  Find the values of "a" for fitting the quadratic equation:
    as              = Best_ABCD1(1) * ones(1,n_pts);

    %  Find the values of "b" for fitting the quadratic equation:
    bs              = Best_ABCD1(3) * ones(1,n_pts);
    
    %  Find the values of "c" for fitting the quadratic equation:
    cs              = Best_ABCD1(2) * (y_probes.^2) + Best_ABCD1(4) * y_probes + Best_ABCD1(5);

    %  The part of the quadratic equation that is b^ - 4ac:
    b2_4ac          = bs.^2 - 4 * as .* cs;

    b_valid         = b2_4ac >= 0;
    pos_roots       = real( ( -bs + sqrt( b2_4ac ) ) ./ ( 2 * as ) );
    neg_roots       = real( ( -bs - sqrt( b2_4ac ) ) ./ ( 2 * as ) );
    
    fit_2_xs          = [ pos_roots(b_valid) neg_roots(b_valid) ];
    fit_2_ys          = [ y_probes(b_valid)  y_probes(b_valid)  ];
    
    % Combine the two sets of fit points into one list:
    fit_xs          = [ fit_1_xs fit_2_xs ];
    fit_ys          = [ fit_1_ys fit_2_ys ];
    
    % Just for fun, sort them by some angle:
    fit_pt_angles   = atan2( fit_ys-mean(fit_ys), fit_xs-mean(fit_xs) );
    [~,sort_key]    = sort( fit_pt_angles );
    fit_xs          = fit_xs( sort_key );
    fit_ys          = fit_ys( sort_key );
    
    
    % ---------------------  PLOTTING  --------------------------------------    
    %
    %
    %  We can plot these raw data points with dark blue squares, and cyan faces:
    %
    figure('Position',[200 5 900 768], 'Color', 'w' );
    plot( xs_perfect, ys_perfect, 'b--', 'LineWidth', 1.5 );
    
    hold on;
    % Add the raw data above the perfect circle it was measured from:
    plot( xs, ys, 'bs', 'MarkerSize', MS+8, 'MarkerFaceColor', 'c' );

    axis( [0 1 0 1]*10 );
    grid on;

    hold on;

    % Now add all the fit points:
    plot( fit_xs, fit_ys, 'ro-', 'MarkerSize', MS-2, 'MarkerFaceColor', 'r'  );
    axis square;
    
    figure( gcf );

    legend( {'Perfect Circle', 'Raw data, Which the conic was fit to', 'Data on the Fit Conic', }, ...
        'Location', 'NorthWest', ...
        'FontSize', FFS );

    title('Using the Smallest Eigenvalue to fit an equation.', 'FontSize', FFS);
end

