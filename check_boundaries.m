function [x_dot] = check_boundaries(theta, theta_dot, angular_accel, lm, vm)
    % Check if angular velocity is outside bounds, and restrict angular
    % acceleration if so.
    if theta_dot < -(180/pi)*8.0
        angular_accel = max([angular_accel 0]);
    elseif theta_dot > (180/pi)*12.6
        angular_accel = min([angular_accel 0]);
    end
    
    global angle_error angle_too_low

    % Check if angle is outside of bounds. Simulation is terminated if so.
    if theta > 106.5
        angle_error = true;
    elseif theta < 55
        angle_error = true;

        % If the angle gets too low, excitation is too high and it is
        % dorsiflexing too much. This flag will cause the optimization
        % algorithm to break from the inner for loop to skip all higher
        % frequency values for a given amplitude.
        angle_too_low = true;
    end

    % Check if normalized muscle length is outside allowable bounds, and
    % limit muscle velocity if so.
    global resting_ne_pa;
    if lm < (1.47/0.47)*cosd(resting_ne_pa)*sind(atand(0.47*sind(resting_ne_pa)/cosd(resting_ne_pa)))
        vm = max([vm 0]);
    elseif lm > (1.47/0.47)*cosd(resting_ne_pa)
        vm = min([vm 0]);
    end

    % Output error-checked state derivatives.
    x_dot = [theta_dot; angular_accel; vm];
end