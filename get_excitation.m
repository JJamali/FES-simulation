function excitation = get_excitation(u, freq, u_threshold, u_saturation, freq_cf)
    if u < u_threshold
        S_u = 0;
    elseif u > u_saturation
        S_u = 1;
    else
        S_u = (u-u_threshold)/(u_saturation-u_threshold);
    end

    % Experimental parameters from Alonso and Watanabe
    R = 15;
    a2 = 3;
    
    f0 = R*log((a2-1)*exp(freq_cf/R)-a2);
    a1 = -a2*exp(-f0/R);

    S_f = (a1-a2)/(1+exp((freq-f0)/R))+a2;

    excitation =S_u*S_f;
end