function [instantaneous_pa] = instantaneous_pennation_angle (instantaneous_lm) 

% male 9.4 female 8.7
resting_pennation_angle [8.7, 9.4];
%Female and Male

resultant_lm = instantaneous_lm - global resting_LM;

width = 0.47*resultant_lm;

initial_vertical_reference_lm = global resting_LM * cos(resting_pennation_angle);
%AB

final_vertical_reference_lm = resultant_lm + vertical_reference_lm;
%AC

instantaneous_pa = arctan(width/final_vertical_reference_lm);

return instantaneous_pa;

end
