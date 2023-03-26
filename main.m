clear
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
input_fun = @(t) 0.054;
f_max = 200;

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

%% SIMULATION

f = @(t,x) mechanics(t,x);

tspan = [0 1];
initial_conditions = [90,0,1];
options = odeset('RelTol', 1e-6, 'AbsTol', 1e-8);

[t,y] = ode45(f,tspan,initial_conditions,options);

ankle_angle = y(:,1);


for i = 1:length(t)
    leg_angle = polyval(leg_angle_regression,t(i));
    toe_height(i) = polyval(knee_height_regression,t(i)) - lower_leg_length*sind(leg_angle) + ...
        foot_length*sind(leg_angle-ankle_angle(i));
end

%polyval(knee_height_regression,t(i)) - lower_leg_length*sind(leg_angle) + ...
        
%% PLOTS

figure(7);
subplot(2,2,1);
plot(t,toe_height);
title("Toe height");
subplot(2,2,2);
plot(t,y(:,1));
title("Ankle angle");
subplot(2,2,3);
plot(t,y(:,2));
title("Ankle angular velocity");
subplot(2,2,4);
plot(t,y(:,3));
title("Normalized muscle length");