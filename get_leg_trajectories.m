function [knee_height_regression,leg_angle_regression] = get_leg_trajectories(upper_leg_length, lower_leg_length)
    global hip_time_regression
    global knee_time_regression

    time = linspace(0,1);
    hip_height = upper_leg_length*cosd(feval(hip_time_regression,0)) + ...
        lower_leg_length*(feval(hip_time_regression,0)-feval(knee_time_regression,0));
    
    for i = time
        knee_height(i) = hip_height-(upper_leg_length*cosd(feval(hip_time_regression,i)));
        leg_angle(i) = 90+feval(hip_time_regression,50*i+50)-feval(knee_time_regression,i);
    end

    knee_height_regression = fit(time,knee_height,'gauss2');
    leg_angle_regression = fit(time,leg_angle,'gauss2');
end