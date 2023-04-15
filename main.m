clear all
close all
clc

%% PARAMETERS

% Anthropometric measurements
global upper_leg_length lower_leg_length foot_length foot_mass resting_ne_pa
upper_leg_length = 0.594;
lower_leg_length = 0.455;
foot_length = 0.267;
foot_mass = 0.5;
resting_ne_pa = 9.4;
mvc_ne_pa = 14.3;

% Electrical stimulation input function
global f_max
f_max = 200;

global angle_error angle_too_low
angle_error = false;
angle_too_low = false;

optimal_of = 1000;
optimal_u = 0;
optimal_freq = 0;

% FES parameters from Alonso et al

% FES voltage parameters
u_threshold = 30;
u_saturation = 45;
u_steps = 10;

% FES frequency parameters
freq_cf = 20;
freq_steps = 10;

% FES pulse width parameter
pulse_width = 0.0001;

%% SETUP

% Get trajectory regressions (create as global variables)
global knee_height_regression leg_angle_regression
[knee_height_regression,leg_angle_regression] = get_leg_trajectories(upper_leg_length, lower_leg_length, foot_length);

% Get resting lengths
global resting_lm resting_lt
resting_lm = 0.5*lower_leg_length/cosd(resting_ne_pa);
resting_lt = (1/3)*lower_leg_length;

global force_length_regression force_velocity_regression
force_length_regression = get_muscle_force_length_regression();
force_velocity_regression = get_muscle_force_velocity_regression();

global ta_origin_height ta_moment_arm
ta_moment_arm = 0.04;
ta_origin_height = sqrt(((5/6)*lower_leg_length)^2 - (0.04)^2);

% From Buchanan et al, establishing activation function
global activation_fun
A = -0.5; % Experimental parameter between -3 and 0
activation_fun = @(u) (exp(A*u)-1)/(exp(A)-1);


%% OPTIMIZATION
num_solutions = 0;
for u = linspace(u_threshold, u_saturation, u_steps)
    for freq = linspace(0, freq_cf, freq_steps)
    
        toe_height = [];
        pennation_angle = [];
        global excitation
        excitation = get_excitation(u, freq, u_threshold, u_saturation, freq_cf);
    
        %% SIMULATION  
    
        f = @(t,x) mechanics(t,x);
        %disp("Angle_Error at simulation: " + angle_error);  
    
        tspan = [0 1];
        initial_conditions = [90,0,1];
        options = odeset('RelTol', 1e-6, 'AbsTol', 1e-8);
        
        tic

        [t,y] = ode45(f,tspan,initial_conditions,options);
    
        toc

        %disp("Angle_Error at simulation: " + angle_error);   
        
        % Stimulation function is a biphasic square wave, meaning positive
        % and then negative pulse of stated amplitude with given pulse
        % width
        power = 2*freq*(u^2)*pulse_width;
        
        %disp("Angle_Error Above power: " + angle_error);
    
        
        %polyval(knee_height_regression,t(i)) - lower_leg_length*sind(leg_angle) + ...
    
        final_leg_angle = polyval(leg_angle_regression, t(length(t)));
        final_knee_height = polyval(knee_height_regression, t(length(t)));
        final_ankle_angle = y(length(t),1);
        final_toe_height = final_knee_height - lower_leg_length*sind(final_leg_angle) + ...
            foot_length*sind(final_leg_angle-final_ankle_angle);

        if final_toe_height > 0 && angle_error == false
            num_solutions = num_solutions + 1;
            functional_solutions(num_solutions,:) = [power, final_toe_height];

            objective_function = 0.12*final_toe_height + power;
            if optimal_of > power
                optimal_solution_index = num_solutions;
                optimal_u = u;
                optimal_freq = freq;

                ankle_angle = y(:,1);
                norm_lm = y(:,3);
                
                for i = 1:length(t)
                    leg_angle = polyval(leg_angle_regression,t(i));
                    toe_height(i) = polyval(knee_height_regression,t(i)) - lower_leg_length*sind(leg_angle) + ...
                        foot_length*sind(leg_angle-ankle_angle(i));
                    pennation_angle(i) = instantaneous_pennation_angle(norm_lm(i));
                end
    
                %% PLOTS
                figure(7);
                subplot(2,2,1);
                plot(t,toe_height);
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
    
                % Pennation angle validation refers to data from Constantinos et al, 1999
                angles = [75,90,105,120]
                rest_pa = [13.13888888888889, 11.500000000000002, 10.61111111111112, 9.500000000000007];
                mvc_pa = [22.177110342840685, 19.747118985883027, 17.28932584269663, 15.702031114952462];
                
                % Scale factor is used to standardize resting pennation angles to different
                % populations based on resting pennation angles found in 
                rest_pa_factor = rest_pa(2)/resting_ne_pa;
                mvc_pa_factor = mvc_pa(2)/mvc_ne_pa;
                rest_pa = rest_pa./rest_pa_factor;
                mvc_pa = mvc_pa./mvc_pa_factor;
                
                figure(8);
                scatter(ankle_angle,pennation_angle,'b');
                hold on
                plot(angles,rest_pa,'k');
                hold on
                plot(angles,mvc_pa,'r');
                legend("Calculated pennation angle", "Resting pennation angle","MVC pennation angle");
                title("Pennation angle vs. Ankle angle");
                xlabel("Ankle angle (deg)");
                ylabel("Pennation angle (deg)");
            end
        end
    
        angle_error = false;
        if angle_too_low 
            angle_too_low = false;
            break
        end
    end
end

figure(9);
scatter(functional_solutions(:,1), functional_solutions(:,2), 'b');
hold on
scatter(functional_solutions(optimal_solution_index,1), functional_solutions(optimal_solution_index,2), 'r');
title("Functional Solutions, Final Angle Deviation vs. Power Consumption");
xlabel("Power");
ylabel("Final Ankle Angle Error");


