function [x_dot] = mechanics(t,x)
    global leg_angle_regression 

    theta = x(1);
    theta_dot = x(2);
    norm_lm = x(3);

    global ta_origin_height
    mtu_length = sqrt((0.04)^2 + ta_origin_height^2 - 2*0.04*ta_origin_height*cosd(theta));

    pennation_angle = instantaneous_pennation_angle(norm_lm);
    
    global resting_lm resting_lt
    lm = norm_lm*resting_lm;
    lt = mtu_length - lm*cosd(pennation_angle);
    norm_lt = lt/resting_lt;

    global activation_fun excitation
    activation = feval(activation_fun, excitation);

    norm_vm = get_muscle_velocity(activation, norm_lm, norm_lt, pennation_angle);

    global ta_moment_arm foot_length foot_mass
    ta_torque = get_muscle_force(activation,norm_lm,norm_vm,pennation_angle)*ta_moment_arm;    
    angular_accel = (180/pi)*(foot_mass*9.81*(foot_length/2)* ...
        cosd(polyval(leg_angle_regression,t) - theta) - ta_torque)/...
        (foot_mass*(foot_length^2));
    
    x_dot = check_boundaries(theta, theta_dot, angular_accel, norm_lm, norm_vm);
end