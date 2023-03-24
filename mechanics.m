function [x_dot] = mechanics(x)
    global leg_angle_regression knee_height_regression

    theta = x(1);
    theta_dot = x(2);
    norm_lm = x(3);

    ta_vel = get_muscle_velocity(norm_lm);
    
    ta_torque = get_muscle_force(norm_lm,ta_vel)*ta_moment_arm;

    angular_accel = 9.81*(foot_length/2)-ta_torque/foot_mass;

    x_dot = [theta_dot,angular_accel,ta_vel];
end