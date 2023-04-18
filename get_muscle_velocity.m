function [vm] = get_muscle_velocity(a, lm, lt, pa)
    global force_length_regression force_velocity_regression

    % Evaluate all length-dependent scale factors
    fpe = force_length_parallel(lm);    % PE
    fl = feval(force_length_regression, lm);       % CE
    ft = force_length_tendon(lt);     % SE
    
    % If activation, cos(pa), or force-length scale factor are zero, assume
    % zero velocity. None of these should ever happen in our simulations.
    if a == 0 || cosd(pa) == 0 || fl == 0
        vm = 0;
    else
        % Velocity is obtained by determining the value of the
        % force-velocity scale factor, shifting the constant term in a copy
        % of the polynomial regression by the amount of the scale factor,
        % and using roots to solve for the velocity.
        fv = (ft/cosd(pa)-fpe)/(a*fl);
        
        % Make sure that scale factor is within proper bounds.
        if fv < polyval(force_velocity_regression, -1)
            fv = polyval(force_velocity_regression, -1);
        end

        if fv > polyval(force_velocity_regression, 1)
            fv = polyval(force_velocity_regression, 1);
        end

        this_regression = force_velocity_regression;
        this_regression(length(force_velocity_regression)) = ...
            force_velocity_regression(length(force_velocity_regression)) - fv;
        
        % Variable named roos to avoid conflict with roots function
        roos = roots(this_regression);
        num_real_roots = 0;
        for i = 1:length(roos)
            if isreal(roos(i)) && roos(i) >= -1 && roos(i) <= 1
                num_real_roots = num_real_roots + 1;
                real_roots(num_real_roots) = roos(i);
            end
        end
    
        % If no real roots are found, assume the velocity is zero. This
        % should never happen.
        if num_real_roots == 0
            vm = 0;
        else
            vm = real_roots(1);
        end
    end
end



