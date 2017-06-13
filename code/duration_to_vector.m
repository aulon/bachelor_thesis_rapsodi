%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Matlab function 'duration_to_vector' %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% @parameters:
%     - x: duration as a number of 16th notes
% @return:
%     - y: the log of the duration
% Duration is measured in 16th notes.

function y = duration_to_vector(x)
    if x == 0
        y = 0;
    else
        y = (4/log2(16))*log2(x) + 1;
    end
end
