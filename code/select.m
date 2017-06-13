%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Matlab function 'select' %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% @parameters:
%   - output: vector that will be interpreted as a probability distribution
%             of the possible outputs
%   - offset: the integer representing the note that corresponds to the
%             first element of the output
%   - det:    whether the choice should be deterministic or not
% @return:
%   - y: network output with the selected note

% This function selects the note from the output vector of the network.

function y = select(output,offset,det)
    F = 4;   % favor factor
    if (det == 0) % non-deterministic
        for i=1:length(output)
            if output(i) < 0
                output(i) = 0;
            else
                output(i) = output(i)^F;
            end
        end
        s = sum(output(:));
        output(:) = (1/s)*output(:);
        total = 0;
        i = 1;
        seed = rand(1);
        while total <= 1
            total = total + output(i);
            if seed <= total
                y = offset + i - 2;
                break;
            end
            i = i+1;
        end

    else % deterministic choice
        max = output(1);
        maxIdx = 1;
        for i = 1:length(output)
            if (output(i) > max)
                max = output(i);
                maxIdx = i;
            end
        end
        y = offset + maxIdx - 2;
    end
end
