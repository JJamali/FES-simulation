clear all
close all
clc

%% PARAMETERS

% Anthropometric measurements
global upper_leg_length lower_leg_length foot_length foot_mass resting_pa
upper_leg_length = 0.594;
lower_leg_length = 0.455;
foot_length = 0.267;
foot_mass = 0.5;
resting_pa = 9.4;

% Electrical stimulation input function
global input_fun f_max
f_max = 200;

global angle_error;
angle_error = false;

global optimized_power optimized_A
optimized_B = 90;
optimized_power = 1000;

%% SETUP

% Get trajectory regressions (create as global variables)
global knee_height_regression leg_angle_regression
[knee_height_regression,leg_angle_regression] = get_leg_trajectories(upper_leg_length, lower_leg_length, foot_length);

% Get resting lengths
global resting_lm resting_lt
resting_lm = 0.5*lower_leg_length/cosd(resting_pa);
resting_lt = (1/3)*lower_leg_length;

global force_length_regression force_velocity_regression
force_length_regression = get_muscle_force_length_regression();
force_velocity_regression = get_muscle_force_velocity_regression();

global ta_origin_height ta_moment_arm
ta_moment_arm = 0.04;
ta_origin_height = sqrt(((5/6)*lower_leg_length)^2 - (0.04)^2);

% From Buchanan et al, establishing activation function
global activation_fun
A = -1.5; % Experimental parameter between -3 and 0
activation_fun = @(u) (exp(A*u)-1)/(exp(A)-1);


 %% OPTIMIZATION 
 
 B = linspace(0.03,0.05,21);
 for j = 1:21

     input_fun = @(t) B(j);

    %% SIMULATION
    disp("Angle_Error before simulation: " + angle_error);    

    f = @(t,x) mechanics(t,x);
    %disp("Angle_Error at simulation: " + angle_error);  

    tspan = [0 1];
    initial_conditions = [90,0,1];
    options = odeset('RelTol', 1e-6, 'AbsTol', 1e-8);
    
    [t,y] = ode45(f,tspan,initial_conditions,options);

    %disp("Angle_Error at simulation: " + angle_error);   
    
    ankle_angle = y(:,1);
    
    
    for i = 1:length(t)
        leg_angle = polyval(leg_angle_regression,t(i));
        toe_height(i) = polyval(knee_height_regression,t(i)) - lower_leg_length*sind(leg_angle) + ...
            foot_length*sind(leg_angle-ankle_angle(i));
    end
    
    
    %disp("Angle_Error Above power: " + angle_error);


    power = @(t) input_fun(t).*input_fun(t);
    TOTAL_POWER = integral(power, 1, 2, 'arrayvalued', true)
    
    %polyval(knee_height_regression,t(i)) - lower_leg_length*sind(leg_angle) + ...
    disp("Angle_Error: " + angle_error);

    if toe_height(length(toe_height)) > 0 && angle_error == false
        if optimized_power > TOTAL_POWER
            optimized_power = TOTAL_POWER;
            optimized_B = B(j);

            disp("Time to plot!!")

            %% PLOTS
            figure(7);
            subplot(2,2,1);
            plot(t,toe_height(1:length(t)));
            title("Toe height");
            xlabel("Time (s)");
            ylabel("Height (m)");
            subplot(2,2,2);
            plot(t,y(:,1));
            title("Ankle angle");
            xlabel("Time (s)");
            ylabel("Angle (deg)");
            subplot(2,2,3);
            plot(t,y(:,2));
            title("Ankle angular velocity");
            xlabel("Time (s)");
            ylabel("Angular velocity (deg/s)");
            subplot(2,2,4);
            plot(t,y(:,3));
            title("Normalized muscle length");
            xlabel("Time (s)");
            ylabel("Normalized muscle length");

        end
    end
    
    %disp("Angle_Error: " + angle_error);
    %disp("Optimized A: " + optimized_A);
    %disp("Optimized Power: "+ optimized_power);

    angle_error = false;
end

disp("Optimized B: " + optimized_B);
disp("Optimized Power: "+ optimized_power);
