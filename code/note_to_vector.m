%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Matlab function 'note_to_vector' %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% @parameters:
%   - x: MIDI representation of a note
%   - offset: the number corresponding to the lowest note in the network data
%   - total: the number of notes that will be represented
% @return:
%   - y: 5 dimensional vector that will be used as input for the DR

% This function takes a MIDI representation of a note (integer, where 60
% represents the middle C, and the distance between any two consecutive
% numbers is a half tone), and converts it into a 5 dimensional vector,
% which will be used as input:

% The 1st coordinate will have values proportional to the log of the
% frequency of the note being represented.
% The 2nd and 3rd coordinates will be x,y coordinates in the chroma circle
% The 4th and 5th coordinates will be x,y coordinates in the circle of fifths.

function y = note_to_vector(x, offset, total)
  % min_note (max_note) is the lowest (highest) note that we want to represent
  if x == 0
    y = [0,0,0,0,0];
  else
    min_note = offset;
    max_note = offset + total - 1;

    % chroma contains the position of each note in the chroma circle (numbered 1:12)
    % They are given in natural oder, i.e the first element specifies the order of C
    % in the circle, the second that of C#, and so on.
    chroma = [1,2,3,4,5,6,7,8,9,10,11,12];
    radius_chroma = 1;
    % in the same way as chroma, c5 contains the position of each note on the
    % circle of fifths
    c5 = [1,8,3,10,5,12,7,2,9,4,11,6];
    radius_circle_5 = 1;

    note = mod(x-55, 12) + 1; % TODO: G3 = 55; C4 = 60
    chroma_angle = (chroma(note) - 1) * (360/12);
    c5_angle = (c5(note) - 1) * (360/12);
    chroma_x = radius_chroma * sind(chroma_angle);
    chroma_y = radius_chroma * cosd(chroma_angle);
    c5_x = radius_circle_5 * sind(c5_angle);
    c5_y = radius_circle_5 * cosd(c5_angle);

    % n is the distance (in semitones) of the note from A4 (69 in MIDI), whose
    % frequency os 440 Hz. fx is the frequency of the note
    n = x - 69;
    fx = 2^(n/12)*440;
    % p is the pitch representation in our vector
    min_p = 2 * log2(2^((min_note - 69)/12) * 440);
    max_p = 2 * log2(2^((max_note - 69)/12) * 440);

    % we scale the representation of pitch in such a way that a pitch distance
    % of 1 octave in the first dimension, is equal to the distance of notes on
    % the opposite sides on the chroma circle or the circle of fifths
    pitch = 2 * log2(fx) - max_p + (max_p - min_p)/2;
    y = [pitch, chroma_x, chroma_y, c5_x, c5_y];

end
