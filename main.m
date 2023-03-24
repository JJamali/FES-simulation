clear
clc

%% PARAMETERS

% Anthropometric measurements
upper_leg_length = ;
lower_leg_length = ;
foot_length = ;
foot_mass = ;

% Electrical stimulation input function
input_fun = define_input_function();

%% SETUP

% Get trajectory regressions (create as global variables)
global knee_time_regression hip_time_regression
knee_time_regression = get_knee_time_regression;
hip_time_regression = get_hip_time_regression;

global knee_height_regression leg_angle_regression
[knee_height_regression,leg_angle_regression] = get_leg_trajectories(upper_leg_length,lower_leg_length);

% Get resting lengths
global resting_lm resting_lt
resting_lm = 0.5*lower_leg_length;
resting_lt = (1/3)*lower_leg_length;

%% SIMULATION

f = @(t,x) mechanics(x);

tspan = [0 1];
initial_conditions = get_initial_conditions();
options = odeset('RelTol', 1e-6, 'AbsTol', 1e-8);

%% PLOTS

