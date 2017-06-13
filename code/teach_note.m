%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Matlab function 'teach_note' %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% @parameters:
%   - note: MIDI representation of a note
%   - offset: the number corresponding to the lowest note in the network data
%   - total: the number of notes that will be represented
% @return:
%   - y: output vector as explained in the thesis

% This function takes a note and converts it into the representation used
% in the output signal.

function y = teach_note(note, offset, total)
  if (note > total + offset - 1)
      err = MException('NoteChk:OutOfRange', ...
          'The note is out of range (too high)');
      throw(err);
  end

  if (note < offset && note ~= 0)
      err = MException('NoteChk:OutOfRange', ...
          'The note is out of range (too low)');
      throw(err);
  end

  if note == 0
      y(1) = 1;
      y(2:total+1) = 0;
  else
    y(1:note-offset+1) = 0;
    y(note-offset+2) = 1;
    y(note-offset+3:total + 1) = 0;
  end
end
