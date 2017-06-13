%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Matlab code exploiting the network %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% This is the second main code where the trained network is exploited on testing
% data.

clear main2_test_network.m;

%% coefficients
start_time = timesteps+1;
end_time = total_timesteps;

%% flags
flag_read_test_data = 1;
flag_write_notes    = 1;

%% read test data
if (flag_read_test_data == 1)
  test_lead_notes = lead_data(1, start_time:end_time);
  test_lead_chord = lead_data(3, start_time:end_time);
  test_lead_dur = lead_data(2, start_time:end_time);
  test_accomp_notes = accomp_data(1, start_time:end_time);
  test_accomp_dur = accomp_data(2, start_time:end_time);
  test_total_time = size(test_lead_notes, 2);
end

vecinput = zeros(test_total_time-1, 7);
for i = 1:test_total_time-1
  vecinput(i, 1:5) = note_to_vector(test_lead_notes(i), offset, lead_num_notes);
  vecinput(i, 6) = test_lead_dur(i);
  vecinput(i, 7) = beat(i);
end

% normalize input matrix - range [-1 1]
vecinput_normalized = vecinput;
vecinput_normalized = 2 * ( (vecinput_normalized - max_input) ./ (max_input - min_input) ) - 1;

test_output_notes = zeros(1, test_total_time);
test_output_dur(1:test_total_time) = 1;

selected_note = test_accomp_notes(2);
selected_duration = test_accomp_dur(2);

X_new(1, 1:network_size) = X(timesteps, :);
ct = 0;
output_prob = zeros(test_total_time, output_length);

for i = 1:test_total_time-1
  u_test(2:6) = note_to_vector(selected_note, offset, num_notes);
  u_test(7) = selected_duration;
  u_test(8:12) = vecinput_normalized(i, 1:5);
  u_test(13) = vecinput_normalized(i, 6);
  u_test(14) = vecinput_normalized(i, 7);

  test_output_notes(i+1) = selected_note;
  test_output_dur(i+1) = selected_duration;

  X_new(i+1, :) = (1-a_leak) * X_new(i, :)' + a_leak * tanh(W * X_new(i, :)' + W_in * u_test' ); % + W_fb * Y_out

  if ct == 0
    Y_out = tanh(W_out * X_new(i+1, :)');
    output_prob(i+1, 1:num_notes+1) = out_to_prob(Y_out(1:num_notes+1));
    output_prob(i+1, num_notes+2:end) = out_to_prob(Y_out(num_notes+2:end));

    selected_note = select(Y_out(1:num_notes+1), offset, 1);

    if selected_note < offset % selected the first neuron (rest)
      selected_note = 0;
    end

    selected_duration = select(Y_out(num_notes+2:output_length), 1, 1) + 1;
    ct = selected_duration;
  end

  % Next input
  if ct > 0
    ct = ct - 1;
  end
end

test_offset = min(test_accomp_notes(test_accomp_notes > 0));
test_nr_notes = max(test_accomp_notes) - offset + 1;
test_out_length = test_nr_notes + 16 + 1;

original_bass = zeros(test_total_time, output_length);
output_bass = zeros(test_total_time, output_length);
for i = 1:test_total_time-1
  %original_bass(i, 1:num_notes + 1) = teach_note(test_accomp_notes(i), offset, num_notes);
  %original_bass(i, num_notes + 2:output_length) = teach_dur(test_accomp_dur(i), num_dur);

  output_bass(i, 1:num_notes + 1) = teach_note(test_output_notes(i), offset, num_notes);
  output_bass(i, num_notes + 2:output_length) = teach_dur(test_output_dur(i), num_dur);
end



test_bass_start = str2double(char(data(start_time, 2)));
test_bass_end = test_bass_start + size(test_lead_notes,2)*120 + 1;

for dummy = 1:size(tempo_data, 1)
  if ( str2double(char(tempo_data(dummy, 2))) <= test_bass_start && strcmp(tempo_data(dummy, 3) , 'Time_signature') )
    pstart = dummy;
  end
  if ( str2double(char(tempo_data(dummy, 2))) <  test_bass_end) %&& strcmp(tempo_data(dummy, 3) , 'Tempo'))
    pend = dummy;
  end
end

test_tempo(1:pend-pstart+1, :) = tempo_data(pstart:pend, :);
test_tempo_offset = str2double( char(test_tempo{1,2}) );
for dummy = 1:size(test_tempo,1)
  test_tempo{dummy, 2} = int2str( abs( str2double( char(test_tempo{dummy, 2}) ) - test_tempo_offset ) );
end

%% Write output into a csv file
if (flag_write_notes == 1)
  write_notes('/home/aulon/jacobs/6th_semester/thesis/music/samples/n10original.csv', ...
     480, test_lead_notes, test_lead_dur, test_accomp_notes, test_accomp_dur, test_tempo, test_lead_chord);
end
