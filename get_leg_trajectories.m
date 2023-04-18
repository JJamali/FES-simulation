function [knee_height_regression,leg_angle_regression] = get_leg_trajectories(upper_leg_length, lower_leg_length, foot_length)
    % Get hip and knee angle regressions
    hip_time_regression = get_hip_time_regression();
    knee_time_regression = get_knee_time_regression();

    % Get hip and knee angles at regular intervals for full gait cycle.
    full_gait_time = linspace(-1.5, 1, 251);
    for i = 1:length(full_gait_time)
        hip_angle(i) = polyval(hip_time_regression,full_gait_time(i));
        knee_angle(i) = polyval(knee_time_regression,full_gait_time(i));
    end

    % Reorder data to properly center swing phase with 0-1 s.
    hip_angle = [hip_angle(27:251) hip_angle(1:26)];
    knee_angle = [knee_angle(27:251) knee_angle(1:26)];

    swing_time = linspace(0,1,101);
    for i = 1:length(swing_time)
        % Vertical component of both legs taken throughout swing phase,
        % maximum kept as hip height.
        swing_leg_length(i) = upper_leg_length*cosd(hip_angle(i + 150)) + ...
            lower_leg_length*(cosd(hip_angle(i + 150) - knee_angle(i + 150)));
        other_leg_length(i) = upper_leg_length*cosd(hip_angle(i + 25)) + ...
            lower_leg_length*(cosd(hip_angle(i + 25) - knee_angle(i + 25)));
        hip_height(i) = max([swing_leg_length(i) other_leg_length(i)]);

        % Knee height and lower leg angle for the leg in swing calculated
        % geometrically.
        knee_height(i) = hip_height(i)-upper_leg_length*cosd(hip_angle(i + 150));
        leg_angle(i) = 90 + hip_angle(i + 150) - knee_angle(i + 150);
    end

    % Plot hip height trajectory
    figure(3);
    plot(swing_time,swing_leg_length);
    title("Hip Height vs. Time");
    xlabel("Time (s)");
    ylabel("Height (m)");


    % Fit knee height and lower leg angle to polynomial regressions.
    knee_height_regression = polyfit(swing_time.',knee_height.',7);
    leg_angle_regression = polyfit(swing_time.',leg_angle.',7);

    % Plot knee height and lower leg angle.
    figure(4);
    subplot(1,2,1);
    scatter(swing_time, knee_height, 'r', '.');
    hold on
    plot(swing_time,polyval(knee_height_regression,swing_time), 'b');
    title("Knee Height vs. Time");
    xlabel("Time (s)");
    ylabel("Knee height (m)");
    legend("Unfitted data", "Polynomial fit");

    subplot(1,2,2);
    scatter(swing_time, leg_angle, 'r', '.');
    hold on
    plot(swing_time,polyval(leg_angle_regression,swing_time), 'b');
    title("Lower Leg Angle vs. Time");
    xlabel("Time (s)");
    ylabel("Lower leg angle relative to horizontal (deg)");
    lgd = legend("Unfitted data", "Polynomial fit");
    lgd.Location = "southeast";
end