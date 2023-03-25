function [normalize_tendon_tension] = force_length_tendon(instantaneous_lt)

% Input Parameters
% instantaneous_lt: normalized length of tendon (series elastic element)
% Output
% normalized tension produced by tendon

       %functions for normalized force-length of the SE
   if instantaneous_lt < 1
       normalize_tendon_tension = 0;
   else
       normalize_tendon_tension = 10*(instantaneous_lt-1)+240*(instantaneous_lt-1)^2;
   end
end
