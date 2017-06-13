%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Matlab function 'read_notes' %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% @parameters:
%   - data: file name of a csv file (as returned from read_mixed_csv)
%   - track: track number (bass or lead track in this case)
% @return:
%   - y: matrix (2 x timesteps) the first row filled with the notes of the
%        midi file represented by the csv, the second row with the duration of
%        each note

% CSV columns: Track - Time - Note_on_c - Channel - Note - Velocity
%                1      2         3          4       5        6

function y = read_notes(data, track)
  divisions = data(1, 6); % number of divisions per quarter note
  rate = 4/str2double(char(divisions)); % rate of conversion between midi time and network time
  d = data(char(data(:, 1)) == int2str(track), :); % data of the specified track
  timesteps = rate * str2double(d(end, 2)); % total timesteps of the song
  timesteps = round(timesteps);
  y = zeros(2, timesteps);
  i = 1;

  while i < size(d, 1) % find the length of the first dimension of d (nr of rows)
    % skip if NOT "Note_on_c" and increment i
    % in matlab 0 is false
    while (strcmp(char(d(i,3)), 'Note_on_c') == 0)
      i = i + 1;
      if i > size(d, 1)
        break;
      end
    end
    % stop the function
    if i > size(d, 1)
      break;
    end

    temp = i;
    start = round(rate * (str2double(char(d(i, 2))))) + 1; % beginning time of the song
    note = str2double(char(d(i, 5)));

    if note > y(1, start) && y(1, start) ~= 0
      i = i + 1;
      continue;
    end

    while (strcmp(char(d(i, 3)), 'Note_off_c') == 0 || str2double(char(d(i, 5))) ~= note)
      i = i + 1;
      if i > size(d, 1)
        break;
      end
    end

    if i > size(d, 1)
      break;
    end

    finish = round(rate * (str2double(char(d(i, 2))))) + 1;
    duration = finish - start;

    % first row of y is filled with all notes
    y(1, start:finish-1) = note;
    y(2, start:start + fix(duration/16) * 16 - 1) = 16;
    y(2, start + fix(duration/16) * 16: start + fix(duration/16) * 16 + mod(duration, 16) - 1) = mod(duration, 16);

    i = temp + 1;

  end

  i = 1;

  while (i < size(y, 2))
    while (y(1, i) ~= 0)
      i = i + 1;
      if i >= size(y, 2)
        break;
      end
    end

    if i > size(y, 2)
      break;
    end

    start = i;

    while (y(1, i) == 0)
      i = i + 1;
      if i >= size(y, 2)
        break;
      end
    end

    if i > size(y ,2)
      break;
    end

    finish = i;

    if i == size(y, 2)
      finish = i + 1;
    end

    duration = finish - start;

    y(2, start:start + fix(duration/16) * 16 - 1) = 16;
    y(2, start + fix(duration/16) * 16: start + fix(duration/16) * 16 + mod(duration, 16) - 1) = mod(duration, 16);
  end

end
