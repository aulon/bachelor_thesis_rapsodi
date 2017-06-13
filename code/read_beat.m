%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Matlab function 'read_beat' %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% @parameters:
%   - data: file name of a csv file (as returned from read_mixed_csv)
%   - track: track number (drums in this case)
% @return:
%   - y: array (1 x timesteps) filled with 1 if a note is present at that time,
%        or filled with a 0 if no note is present at that time.

% CSV columns: Track - Time - Note_on_c - Channel - Note - Velocity
%                1      2         3          4       5        6

function y = read_beat(data, track)
  divisions = data(1, 6); % number of divisions per quarter note
  rate = 4/str2double(char(divisions)); % rate of conversion between midi time and network time
  d = data(char(data(:, 1)) == int2str(track), :);
  timesteps = rate * str2double(d(end, 2));
  timesteps = round(timesteps);
  y = zeros(1, timesteps);
  i = 1;

  while i < size(d, 1)
    while (strcmp(char(d(i, 3)), 'Note_on_c') == 0)
      i = i + 1;
      if i > size(d, 1)
        break;
      end
    end

    if i > size(d, 1)
      break;
    end

    start = round(rate * (str2double(char(d(i, 2))))) + 1;
    note = str2double(char(d(i, 5)));

    if note < y(start)
      i = i + 1;
      continue;
    end

    y(start) = 1;

    i = i + 1;
  end

end
