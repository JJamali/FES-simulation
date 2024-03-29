function force = get_muscle_force(a, lm, vm, pa)
    % Force calculated using equation from Millard
    global f_max force_length_regression force_velocity_regression
    fl = feval(force_length_regression, lm);
    fv = polyval(force_velocity_regression, vm);
    fp = force_length_parallel(lm);

    force = f_max*(a*fl*fv + fp)*cosd(pa);
end