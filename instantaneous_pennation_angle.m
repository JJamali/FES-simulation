function [instantaneous_pa] = instantaneous_pennation_angle (instantaneous_lm) 
    global resting_ne_pa

    % Calculations derived from Poisson's ratio of muscle (0.47).
    numerator = (1.47/0.47)*cosd(resting_ne_pa)*sind(atand(0.47*tand(resting_ne_pa)));

    instantaneous_pa = 180 - atand(0.47*tand(resting_ne_pa)) - (180 - asind(numerator/instantaneous_lm));
    
    
end
