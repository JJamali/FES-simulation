function [vm] = get_muscle_velocity(a, lm, lt, pa)

% Input Parameters
% a: activation (between 0 and 1)
% lm: normalized length of muscle (contractile element)
%  lt: normalized length of tendon (series elastic element)

% Output
% root: normalized lengthening velocity of muscle (contractile element)


% damping coefficient (see damped model in Millard et al.)
% WRITE CODE HERE TO CALCULATE VELOCITY
    global force_length_regression force_velocity_regression

    fpe = force_length_parallel(lm);    % PE
    fl = feval(force_length_regression, lm);       % CE
    ft = force_length_tendon(lt);     % SE
    
    if a == 0 || cosd(pa) == 0 || fl == 0
        vm = 0;
    else
        fv = (ft/cosd(pa)-fpe)/(a*fl);
        
        if fv < polyval(force_velocity_regression, -1)
            fv = polyval(force_velocity_regression, -1);
        end

        if fv > polyval(force_velocity_regression, 1)
            fv = polyval(force_velocity_regression, 1);
        end

        force_velocity_regression(length(force_velocity_regression)) = ...
            force_velocity_regression(length(force_velocity_regression)) - fv;
        roos = roots(force_velocity_regression);
        num_real_roots = 0;
        for i = 1:length(roos)
            if isreal(roos(i)) && roos(i) >= -1 && roos(i) <= 1
                num_real_roots = num_real_roots + 1;
                real_roots(num_real_roots) = roos(i);
            end
        end
    
        if num_real_roots == 0
            vm = 0;
        else
            vm = real_roots(1);
        end
    end
end



