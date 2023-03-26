function [knee_height_regression,leg_angle_regression] = get_leg_trajectories(upper_leg_length, lower_leg_length, foot_length)
    hip_time_regression = get_hip_time_regression();
    knee_time_regression = get_knee_time_regression();

    full_gait_time = linspace(-1.5,1,251);
    for i = 1:length(full_gait_time)
        hip_angle(i) = polyval(hip_time_regression,full_gait_time(i));
        knee_angle(i) = polyval(knee_time_regression,full_gait_time(i));
    end

    hip_angle = [hip_angle(27:251) hip_angle(1:26)];
    knee_angle = [knee_angle(27:251) knee_angle(1:26)];

    swing_time = linspace(0,1,101);
    for i = 1:length(swing_time)
        swing_leg_length(i) = upper_leg_length*cosd(hip_angle(i + 150)) + ...
            lower_leg_length*(cosd(hip_angle(i + 150) - knee_angle(i + 150)));
        other_leg_length(i) = upper_leg_length*cosd(hip_angle(i + 25)) + ...
            lower_leg_length*(cosd(hip_angle(i + 25) - knee_angle(i + 25)));
        hip_height(i) = max([swing_leg_length(i) other_leg_length(i)]);
        knee_height(i) = hip_height(i)-upper_leg_length*cosd(hip_angle(i + 150));
        leg_angle(i) = 90 + hip_angle(i + 150) - knee_angle(i + 150);
    end

    figure(3);
    plot(swing_time,swing_leg_length);
    hold on
    plot(swing_time,other_leg_length);

    knee_height_regression = polyfit(swing_time.',knee_height.',7);
    leg_angle_regression = polyfit(swing_time.',leg_angle.',7);

    figure(4);
    subplot(2,2,1);
    plot(swing_time, knee_height);
    title("Unfitted knee height");
    subplot(2,2,2);
    plot(swing_time,polyval(knee_height_regression,swing_time));
    title("Fitted knee height");
    subplot(2,2,3);
    plot(swing_time, leg_angle);
    title("Unfitted leg angle");
    subplot(2,2,4);    
    plot(swing_time,polyval(leg_angle_regression,swing_time));
    title("Fitted leg angle");
end