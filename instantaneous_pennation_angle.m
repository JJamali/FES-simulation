function [instantaneous_pa] = instantaneous_pennation_angle (instantaneous_lm) 

    global resting_pa

    numerator = (sind(resting_pa)/0.47 + cosd(resting_pa))*sind(atand(0.47));

    instantaneous_pa = 180 - atand(0.47) - (180 - asind(numerator/instantaneous_lm))
    
    
end
