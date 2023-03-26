function [vm] = get_muscle_velocity(activation, norm_lm, norm_lt, pennation_angle)

%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

vm = finverse((force_length_tendon(norm_lt)/cos(pennation_angle)-force_length_parallel(norm_lm))/(activation*force_length_muscle(norm_lm)));

end
