%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Matlab main code %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% This is the first main code where the network is generated and trained.

% CSV columns: Track - Time - Note_on_c - Channel - Note - Velocity
%                1      2         3          4       5        6

% u - teacher input
% D - teacher output (Y_target)

%% flags
flag_read_data   = 0;
flag_read_ts     = 1;
flag_rand        = 1;

%% network parameters
seed = 7;
rng(seed);
network_size = 100;
total_timesteps = 40000;
timesteps = round(total_timesteps * 0.7);
test_timesteps = total_timesteps - timesteps;
start = 1;

%% coefficients
spectral_radius = 0.95;
input_bias = 0.2;
a_leak = 0.9;
win_scale = 1;
wfb_scale = 0.05;

%% read data
if (flag_read_data == 1)
  data = read_mixed_csv('train.csv', ',');
  lead_data = read_notes_aulon(data, 2);
  accomp_data = read_notes(data, 3);
  beat = read_beat(data, 4);
  % read tempo and time signature information
  tempo_data = data(char(data(:,1)) == int2str(1), :);
end

if (flag_read_ts == 1)
  % lead - leading track (teaching)
  lead(start:start + timesteps - 1) = lead_data(1, start:start + timesteps - 1);
  lead_chord(start:start + timesteps - 1) = lead_data(3, start:start + timesteps - 1);
  lead_duration(start:start + timesteps - 1) = lead_data(2, start:start + timesteps - 1);
  % accomp - accompanying track (teaching)
  accomp(start:start + timesteps - 1) = accomp_data(1, start:start + timesteps - 1);
  accomp_duration(start:start + timesteps - 1) = accomp_data(2, start:start + timesteps - 1);
end
%{
for ii = 1:size(lead,2)
  if (lead_chord(ii) == 0)
    lead_chord(ii) = lead(ii);
  end
end
%}


%% setup training and teacher input
% u - teacher input
u(1, 1:20) = 0; % input for training
offset = min(accomp(accomp > 0)); % min element bigger than zero
num_notes = max(accomp) - offset + 1;
lead_num_notes = max(max(lead),max(lead_chord)) - offset + 1; % TODO: why bass offset?
num_dur = 16;
input_length = 3*5 + 3*1 + 2;
output_length = num_notes + num_dur + 1;
D = zeros(timesteps, output_length);

for i = 2:timesteps
  u(i, 1) = input_bias; % bias

  u(i, 2:6) = note_to_vector(accomp(i-1), offset, lead_num_notes);
  u(i, 7) = duration_to_vector(accomp_duration(i-1));

  u(i, 8:12) = note_to_vector(lead(i-1), offset, lead_num_notes);
  u(i, 13) = duration_to_vector(lead_duration(i-1));

  u(i, 14) = beat(i-1);

  u(i, 15:19) = note_to_vector(lead_chord(i-1), offset, lead_num_notes);
  u(i, 20) = duration_to_vector(lead_duration(i-1));

  D(i, 1:num_notes + 1) = teach_note(accomp(i), offset, num_notes);
  D(i, num_notes + 2:output_length) = teach_dur(accomp_duration(i), num_dur);
end

% normalize input matrix - range [-1 1]
max_input = max(u(:));
min_input = min(u(:));
u_normalized = u;
u_normalized = 2 * ( (u_normalized - min_input) ./ (max_input - min_input) ) - 1;

%% setup network weights W_in, W, W_fb
% randomly generate input-to-weight matrix W_in
% note that columns are scaled separately to increase performance
if (flag_rand == 1)
  W_in_raw(1:network_size, 1) = randi([-1 1], network_size, 1); % uniformly distibuted
  W_in_raw(1:network_size, 2:6) =  0.8 * (2 * rand(network_size, 5) - 1);
  W_in_raw(1:network_size, 7) =    0.8 * (2 * rand(network_size, 1) - 1);
  W_in_raw(1:network_size, 8:12) =  (2 * rand(network_size, 5) - 1);
  W_in_raw(1:network_size, 13) =  (2 * rand(network_size, 1) - 1);
  W_in_raw(1:network_size, 14) =  0.8 * (2 * rand(network_size, 1) - 1);
  W_in_raw(1:network_size, 15:20) =  1.5 * (2 * rand(network_size, 6) - 1);
  % randomly generate internal(reservoir)-weight matrix W
  W_raw = rand(network_size, network_size);
  % randomly generate feedback weights
  W_fb_raw =  rand(network_size, output_length);
end

lambda_max = max(abs(eig(W_raw))); % spectral radius
% normalize and scale
W = (spectral_radius/lambda_max) * W_raw; % Guarantee ESN property
W_in = win_scale * W_in_raw;
W_fb = wfb_scale * W_fb_raw;

%% train network
% randomly generate the initial state of internal units
X = zeros(timesteps, network_size); % internal units
X(1, 1:network_size) = 2 * rand(network_size, 1) - 1; % initial state
for i = 1:timesteps-1
  X(i+1, :) = (1-a_leak) * X(i,:)' + a_leak * tanh(W * X(i, :)' + W_in * u_normalized(i+1, :)' + W_fb * D(i, :)'); % +
end

%% Learn the output weights via ridge regression
R = X' * X;
P1 = X' * D(:, 1:num_notes + 1);
P2 = X' * D(:, num_notes + 2:end);
W_out = zeros(output_length, network_size);
W_out(1:num_notes + 1, :) = ((R + 1.5 * eye(network_size))\P1)';
W_out(num_notes + 2:end, :) = ((R + 1 * eye(network_size))\P2)';
