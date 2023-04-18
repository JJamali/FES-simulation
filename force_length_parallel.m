function [normalize_PE_force] = force_length_parallel(lm)
% COPIED FROM ASSIGNMENT 2

% Input Parameter
% lm: normalized length of muscle (contractile element)

% Output
% normalized force produced by parallel elastic element

%The objective here is to obtain normalized parallel elastic values to return to
%any function that requires the parallel elastic element
if lm < 1
    normalized_pe = 0;
else
    normalized_pe = (3 * ((lm - 1)^2)) / (0.6 + lm - 1);
end

normalize_PE_force = normalized_pe;
end
