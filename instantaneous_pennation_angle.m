function [instantaneous_pa] = instantaneous_pennation_angle (instantaneous_lm) 

    instantaneous_lm = 1.01
    resting_lm = 1
    resting_pa = 9.4
    % male 9.4

    numerator = (sind(resting_pa)/0.47 + cosd(resting_pa))*sind(atand(0.47));

    instantaneous_pa = 180 - atand(0.47) - (180 - asind(numerator/instantaneous_lm))
    
end
