function [initial_conditions] = get_initial_conditions()
    global leg_angle_regression
    initial_angle = feval(leg_angle_regression,0);

    initial_conditions = [90,0,]
end