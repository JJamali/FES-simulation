function [normalize_tendon_tension] = force_length_tendon(instantaneous_lt)
%%%% TASK 1
% Input Parameters
% instantaneous_lt: normalized length of tendon (series elastic element)
% Output
% normalized tension produced by tendon

       %functions for normalized force-length of the SE
   if instantaneous_lt(i)<1
       normalize_tendon_tension(i)=0;
   else
       normalize_tendon_tension(i)=10*(instantaneous_lt(i)-1)+240*(instantaneous_lt(i)-1)^2;
   end
end