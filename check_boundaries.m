function [x_dot] = check_boundaries(theta, theta_dot, angular_accel, lm, vm)
    if theta_dot < -(180/pi)*8.0
        angular_accel = max([angular_accel 0]);
    else if theta_dot > (180/pi)*12.6
        angular_accel = min([angular_accel 0]);
    end
    end
    
    if theta > 106.5
        theta_dot = min([theta_dot 0]);
        angular_accel = min([angular_accel 0]);
    else if theta < 55
        theta_dot = max([theta_dot 0]);
        angular_accel = max([angular_accel 0]);
    end
    end

    global resting_pa;
    if lm < (1.47/0.47)*cosd(resting_pa)*sind(atand(0.47*sind(resting_pa)/cosd(resting_pa)))
        vm = max([vm 0]);
    else if lm > (1.47/0.47)*cosd(resting_pa)
        vm = min([vm 0]);
    end
    end

    x_dot = [theta_dot; angular_accel; vm];
end