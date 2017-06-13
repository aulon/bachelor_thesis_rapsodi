%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Matlab function 'write_notes' %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% @parameters:
%   - fname: file name where information will be Written
%   - division: division information retrieved from MIDI
%   - lead_notes: leading notes from data
%   - lead_dur: leading duration of the notes from data
%   - accomp_notes: bass notes produced by the network
%   - accomp_dur: duration of bass notes produced by the network
% @return:
%   - y: file with MIDI information

function y = write_notes(fname, division, fdata1, fdata3, accomp_notes, accomp_dur)
  fd = fopen(fname, 'wt');
  rate = division/4;
  total_time = size(accomp_notes, 2) * rate;
  % MTC (MIDI Time Code) = 1000 * 1000 * 60 / bpm

  % Data track
  fprintf(fd, '0, 0, Header, %d, %d, %d\r\n', 1, 3, division);
  for dummy = 1:size(fdata1, 1)
    fprintf(fd, '1, %s, %s, %s, %s, %s, %s \r\n', fdata1{dummy, 2}, fdata1{dummy, 3}, ...
      fdata1{dummy, 4}, fdata1{dummy, 5}, fdata1{dummy, 6}, fdata1{dummy, 7});
  end

  % Accompanying track
  fprintf(fd, '2, 0, Start_track \r\n');
  fprintf(fd, '2, 0, Title_t, Bass \r\n');
  fprintf(fd, '2, 0, Control_c, 8, 7, 127\r\n');
  fprintf(fd, '2, 0, Program_c, 8, 34\r\n'); % Program_c selects instrument. 34 is Electic Bass (finger)

  i = 1;

  while (i <= size(accomp_notes, 2))
    time = round(rate*(i-1));
    note = accomp_notes(i);
    if note ~= 0
      fprintf(fd, '2, %d, Note_on_c, 8, %d, 40\r\n', time, note);
    end

    i = i + accomp_dur(i);
    time = round(rate*(i-1));

    if note ~= 0
      fprintf(fd, '2, %d, Note_off_c, 8, %d, 0\r\n', min(time, total_time), note);
    end
  end
  fprintf(fd, '2, %d, End_track, , , \r\n', total_time);

  for dummy = 1:size(fdata3, 1)
    fprintf(fd, '3, %s, %s, %s, %s, %s, %s \r\n', fdata3{dummy, 2}, fdata3{dummy, 3}, ...
      fdata3{dummy, 4}, fdata3{dummy, 5}, fdata3{dummy, 6}, fdata3{dummy, 7});
  end

  fprintf(fd,'0, 0, End_of_file, , , \r\n');

  y = fclose(fd);
end
