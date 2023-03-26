function [knee_height_regression,leg_angle_regression] = get_leg_trajectories(upper_leg_length, lower_leg_length, foot_length)
    hip_time_regression = get_hip_time_regression();
    knee_time_regression = get_knee_time_regression();

    time = linspace(0,1,101);
    hip_height = upper_leg_length*cosd(polyval(hip_time_regression,0)) + ...
        lower_leg_length*cosd(polyval(hip_time_regression,0)-polyval(knee_time_regression,0)) + ...
        foot_length*cosd(polyval(hip_time_regression,0)-polyval(knee_time_regression,0) + 90);
    
    for i = 1:length(time)
        knee_height(i) = hip_height-(upper_leg_length*cosd(polyval(hip_time_regression,time(i))));
        leg_angle(i) = 90+polyval(hip_time_regression,time(i))-polyval(knee_time_regression,time(i));
    end

    knee_height_regression = polyfit(time.',knee_height.',7);
    leg_angle_regression = polyfit(time.',leg_angle.',7);

    figure(3);
    subplot(2,2,1);
    plot(time, knee_height);
    title("Unfitted knee height");
    subplot(2,2,2);
    plot(time,polyval(knee_height_regression,time));
    title("Fitted knee height");
    subplot(2,2,3);
    plot(time, leg_angle);
    title("Unfitted leg angle");
    subplot(2,2,4);    
    plot(time,polyval(leg_angle_regression,time));
    title("Fitted leg angle");
end