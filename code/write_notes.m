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

function y = write_notes(fname, division, lead_notes, lead_dur, accomp_notes, accomp_dur, tempo, lead_chord)
  fd = fopen(fname, 'wt');
  rate = division/4;
  total_time = size(lead_notes, 2) * rate;
  % MTC (MIDI Time Code) = 1000 * 1000 * 60 / bpm

  % Data track
  fprintf(fd, '0, 0, Header, %d, %d, %d\r\n', 1, 4, division);
  fprintf(fd, '1, 0, Start_track, , , \r\n');
  fprintf(fd, '1, 0, Title_t, Data, , \r\n');
  for dummy = 1:size(tempo,1)
    fprintf(fd, '1, %s, %s, %s, %s, %s, %s \r\n', tempo{dummy, 2}, tempo{dummy, 3}, ...
      tempo{dummy, 4}, tempo{dummy, 5}, tempo{dummy, 6}, tempo{dummy, 7});
  end
  fprintf(fd, '1, %s, End_track, , , \r\n', tempo{size(tempo,1), 2});

  % Accompanying track
  fprintf(fd, '2, 0, Start_track \r\n');
  fprintf(fd, '2, 0, Title_t, Bass \r\n');
  %fprintf(fd, '2, 0, Control_c, 2, 0, 0\r\n');
  %fprintf(fd, '2, 0, Control_c, 2, 32, 0\r\n');
  fprintf(fd, '2, 0, Control_c, 2, 7, 127\r\n');
  fprintf(fd, '2, 0, Program_c, 2, 34\r\n'); % Program_c selects instrument. 34 is Electic Bass (finger)

  i = 1;

  while (i <= size(accomp_notes, 2))
    time = round(rate*(i-1));
    note = accomp_notes(i);
    if note ~= 0
      fprintf(fd, '2, %d, Note_on_c, 2, %d, 40\r\n', time, note);
    end

    i = i + accomp_dur(i);
    time = round(rate*(i-1));

    if note ~= 0
      fprintf(fd, '2, %d, Note_off_c, 2, %d, 0\r\n', min(time, total_time), note);
    end
  end
  fprintf(fd, '2, %d, End_track, , , \r\n', total_time);

  % Leading track
  fprintf(fd, '3, 0, Start_track, , , \r\n');
  fprintf(fd, '3, 0, Title_t, Electric_Guitar, , \r\n');
  fprintf(fd, '3, 0, Control_c, 3, 7, 60\r\n');
  fprintf(fd, '3, 0, Program_c, 3, 30\r\n'); % Program_c selects instrument. 30 is Distortion Electric Guitar
  i = 1;

  while(i <= size(lead_notes,2))
    time = round(rate*(i-1));
    note = lead_notes(i);

    if note ~= 0
      fprintf(fd, '3, %d, Note_on_c, 3, %d, 50\r\n', time, note);
    end

    i = i + lead_dur(i);
    time = round(rate*(i-1));

    if note ~= 0
      fprintf(fd, '3, %d, Note_off_c, 3, %d, 0\r\n', min(time, total_time), note);
    end
  end

  fprintf(fd,'3, %d, End_track, , , \r\n', total_time);

  % Leading track - chord
  fprintf(fd, '4, 0, Start_track, , , \r\n');
  fprintf(fd, '4, 0, Title_t, Guitar_chord, , \r\n');
  fprintf(fd, '4, 0, Control_c, 4, 7, 60\r\n');
  fprintf(fd, '4, 0, Program_c, 4, 30\r\n'); % Program_c selects instrument. 30 is Distortion Electric Guitar
  i = 1;

  while(i <= size(lead_chord,2))
    time = round(rate*(i-1));
    note = lead_chord(i);

    if note ~= 0
      fprintf(fd, '4, %d, Note_on_c, 4, %d, 50\r\n', time, note);
    end

    i = i + lead_dur(i);
    time = round(rate*(i-1));

    if note ~= 0
      fprintf(fd, '4, %d, Note_off_c, 4, %d, 0\r\n', min(time, total_time), note);
    end
  end

  fprintf(fd,'4, %d, End_track, , , \r\n', total_time);

  fprintf(fd,'0, 0, End_of_file, , , \r\n');

  y = fclose(fd);
end
