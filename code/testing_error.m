%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Matlab code 'error' %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% This code computes the error between the correct duration of the accompanying
% track (bass track in our case, found in our data), and the network output
% duration of the accompanying track. Simply put, it computes the MSE between
% the original bass track of the testing dat, and the network-generated bass
% track of the RNN.

e_dur = 0;
n = length(test_output_notes);
for i = 1:n
  correct_dur = note_to_vector(test_accomp_dur(i), offset, lead_num_notes);
  out_dur = note_to_vector(test_output_dur(i), offset, lead_num_notes);
  d_dur = norm(correct_dur - out_dur);
  if d_dur > 0
    e_dur = e_dur + d_dur;
  end
end
e_dur = e_dur/n

% This code computes the error between the correct melody of the accompanying
% track (bass track in our case, found in our data), and the network output
% melody of the accompanying track. Simply put, it computes the MSE between
% the original bass track of the testing dat, and the network-generated bass
% track of the RNN.

e_melody = 0;
for i = 1:n
  correct_melody = note_to_vector(test_accomp_notes(i), offset, lead_num_notes);
  out_melody = note_to_vector(test_output_notes(i), offset, lead_num_notes);
  d_melody = norm(correct_melody - out_melody);
  if d_melody > 0
    e_melody = e_melody + d_melody;
  end
end
e_melody = e_melody/n
