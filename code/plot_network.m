%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Matlab code 'plot_network' %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% plotting
rep = {'pitch', 'chroma_x', 'chroma_y', 'circle_x', 'circle_y', 'duration'};
ts_in = size(u_normalized, 1)/1000;
ts_win = size(W_in, 1)/100;
ts_w = size(W,1)/100;
ts_x = size(X,1)/1000;
ts_x_col = size(X,2)/100;
ts_wout = size(W_out,2)/100;
%ts_output = size(original_bass, 1);

%% input units - u(timesteps, 2:7) - bass track
ucoeff = 1000;
urange = 250;
%
% plot raw data vs. normalized data
% set ts to plot different time intervals of length 100
set(0,'DefaultFigureWindowStyle','docked');
for ts = 4:4 %ts_in-1
  for k = 2:7
    figure('Name',['input_unit_bass_' cell2mat(rep(k-1)) '_' num2str(ts*ucoeff)], 'NumberTitle', 'off');
    plot(u(ts*ucoeff:ts*ucoeff + urange, k));
    hold on
    plot(u_normalized(ts*ucoeff:ts*ucoeff + urange, k));
    hold off
    axis([0 inf -1 1]);
    xlabel(['timesteps ' num2str(ts*ucoeff) ' - ' num2str(ts*ucoeff + urange)]);
    legend('raw', 'normalized');
    title(['input unit bass ' cell2mat(rep(k-1))]);
  end
end
set(0,'DefaultFigureWindowStyle','normal');
%}


%% input units - u(timesteps, 8:13) - lead track
%
% plot raw data vs. normalized data
% set ts to plot different time intervals of length 100
set(0,'DefaultFigureWindowStyle','docked');
for ts = 4:4 %ts_in-1
  for k = 8:13
    figure('Name',['input_unit_guitar_' cell2mat(rep(k-7)) '_' num2str(ts*ucoeff)], 'NumberTitle', 'off');
    plot(u(ts*ucoeff:ts*ucoeff + urange, k));
    hold on
    plot(u_normalized(ts*ucoeff:ts*ucoeff + urange, k));
    hold off
    axis([0 inf -1 1]);
    xlabel(['timesteps ' num2str(ts*ucoeff) ' - ' num2str(ts*ucoeff + urange)]);
    legend('raw', 'normalized');
    title(['input unit guitar ' cell2mat(rep(k-7))]);
  end
end
set(0,'DefaultFigureWindowStyle','normal');
%}


%% input units - u(timesteps, 14) - beat
%
% plot raw data vs. normalized data
% set ts to plot different time intervals of length 100
set(0,'DefaultFigureWindowStyle','docked');
for ts = 4:4 %ts_in-1
  figure('Name',['input_unit_beat_' num2str(ts*ucoeff)], 'NumberTitle', 'off');
  plot(u(ts*ucoeff:ts*ucoeff + urange, 14));
  hold on
  plot(u_normalized(ts*ucoeff:ts*ucoeff + urange, 14));
  hold off
  axis([0 inf -1 1]);
  xlabel(['timesteps ' num2str(ts*ucoeff) ' - ' num2str(ts*ucoeff + urange)]);
  legend('raw', 'normalized');
  title(['input unit beat ']);
end
set(0,'DefaultFigureWindowStyle','normal');
%}


%% W_in first column - bias column - uniformly distributed
wincoeff = 1;
winrange = 99;
%{
set(0,'DefaultFigureWindowStyle','docked');
for k = 1:1 %ts_win-1
  figure('Name',['W_in_bias_' num2str(k*wincoeff)], 'NumberTitle', 'off');
  plot(W_in(k*wincoeff:k*wincoeff + winrange, 1));
  axis([0 inf -1 1]);
  xlabel(['timesteps ' num2str(k*wincoeff) ' - ' num2str(k*wincoeff + winrange)]);
  title(['W^{in} bias']);
end
set(0,'DefaultFigureWindowStyle','normal');
%}


%% W_in last column
%{
set(0,'DefaultFigureWindowStyle','docked');
for k = 1:1 %ts_win-1
  figure('Name',['W_in_beat_' num2str(k*wincoeff)], 'NumberTitle', 'off');
  plot(W_in(k*wincoeff:k*wincoeff + winrange, 14));
  axis([0 inf -1 1]);
  xlabel(['timesteps ' num2str(k*wincoeff) ' - ' num2str(k*wincoeff + winrange)]);
  title(['W^{in} beat']);
end
set(0,'DefaultFigureWindowStyle','normal');
%}


%% W_in(timesteps, 2:7) - accomp columns
%{
pick_col_accomp = 2;
set(0,'DefaultFigureWindowStyle','docked');
for k = 1:1 % ts_win-1
  figure('Name',['W_in_accomp_' num2str(k*100)], 'NumberTitle', 'off');
  plot(W_in(k*wincoeff:k*wincoeff + winrange, pick_col_accomp));
  axis([0 inf -1 1]);
  xlabel(['timesteps ' num2str(k*wincoeff) ' - ' num2str(k*wincoeff + winrange)]);
  title(['W^{in} accomp column: ' num2str(pick_col_accomp)]);
end
set(0,'DefaultFigureWindowStyle','normal');
%}


%% W_in(timesteps, 8:13) - lead columns
%{
pick_col_lead = 8;
set(0,'DefaultFigureWindowStyle','docked');
for k = 1:1 % ts_win-1
  figure('Name',['W_in_lead_' num2str(k*wincoeff)], 'NumberTitle', 'off');
  plot(W_in(k*wincoeff:k*wincoeff + winrange, pick_col_lead));
  axis([0 inf -1 1]);
  xlabel(['timesteps ' num2str(k*wincoeff) ' - ' num2str(k*wincoeff + winrange)]);
  title(['W^{in} lead column: ' num2str(pick_col_lead)]);
end
set(0,'DefaultFigureWindowStyle','normal');
%}


%% W_in(timesteps, 14:19) - chord columns
%{
pick_col_chord = 14;
set(0,'DefaultFigureWindowStyle','docked');
for k = 1:1 % ts_win-1
  figure('Name',['W_in_chord_' num2str(k*wincoeff)], 'NumberTitle', 'off');
  plot(W_in(k*wincoeff:k*wincoeff + winrange, pick_col_chord));
  axis([0 inf -1 1]);
  xlabel(['timesteps ' num2str(k*wincoeff) ' - ' num2str(k*wincoeff + winrange)]);
  title(['W^{in} lead column: ' num2str(pick_col_chord)]);
end
set(0,'DefaultFigureWindowStyle','normal');
%}


%% internal weights W
%{
wcoeff = 1;
wrange = 99;
% set col_w to plot different columns
set(0,'DefaultFigureWindowStyle','docked');
for col_w = 25:25:network_size % ts_w
  for k = 1:1 %5:5:ts_w-5
    figure('Name',['W_column_' num2str(col_w) '_t' num2str(k*wcoeff)], 'NumberTitle', 'off');
    plot(W(k*wcoeff:k*wcoeff + wrange, col_w));
    %axis([0 inf -1 1]);
    xlabel(['timesteps ' num2str(k*wcoeff) ' - ' num2str(k*wcoeff + wrange)]);
    title(['W column: ' num2str(col_w)]);
  end
end
set(0,'DefaultFigureWindowStyle','normal');
%}


%% internal units X

xcoeff = 1000;
xnewcoeff = 100;
xrange = 200;
%{
% set ts to plot different time intervals of length 100
set(0,'DefaultFigureWindowStyle','docked');
for ts =  10:5:ts_x-1
  for k = 25:25:100 %1:ts_x_col-1
    figure('Name',['x_' num2str(k) '_t' num2str(ts*xcoeff)], 'NumberTitle', 'off');
    plot(X(ts*xcoeff:ts*xcoeff + xrange, k));
    axis([0 inf -1 1]);
    xlabel(['timesteps ' num2str(ts*xcoeff) ' - ' num2str(ts*xcoeff + xrange)]);
    title(['X - internal units nr.' num2str(k) ]);
  end
end
set(0,'DefaultFigureWindowStyle','normal');
%}
%{
set(0,'DefaultFigureWindowStyle','docked');
for ts =  5:5:10
  for k = 25:25:100 %1:ts_x_col-1
    figure('Name',['x_new_' num2str(k) '_t' num2str(ts*xnewcoeff)], 'NumberTitle', 'off');
    plot(X_new(ts*xnewcoeff:ts*xnewcoeff + xrange, k));
    axis([0 inf -1 1]);
    xlabel(['timesteps ' num2str(ts*xnewcoeff) ' - ' num2str(ts*xnewcoeff + xrange)]);
    title(['X_{new} - internal units nr.' num2str(k) ]);
  end
end
set(0,'DefaultFigureWindowStyle','normal');
%}


%% teacher output
%{
set(0,'DefaultFigureWindowStyle','docked');
for ts = 5:5:ts_output
  for k = 1:num_notes+1
    figure('Name',['teacher_note_' num2str(k-1) '_t' num2str(ts*100)  ], 'NumberTitle', 'off');
    plot(original_bass(ts*100:ts*100+500, k ));
    %axis([0 inf -1 1]);
    xlabel(['timesteps ' num2str(ts*100) ' - ' num2str(ts*100+100) ]);
    title(['teacher input note ' num2str(k-1)]);
  end
end
set(0,'DefaultFigureWindowStyle','normal');
%}
%{
real_blob = zeros(1,ts_output);
fake_blob = zeros(1,ts_output);
for ts = 1:ts_output-100
    real_blob(1,ts) = find(original_bass(ts, 1:num_notes+1))-1;
    fake_blob(1,ts) = find(output_bass(ts, 1:num_notes+1))-1;
end

set(0,'DefaultFigureWindowStyle','docked');
figure('Name',['output_1'], 'NumberTitle', 'off');
plot( real_blob(1,250:500), 'b' );
hold on
plot( fake_blob(1,250:500), 'r' );
hold off
axis([0 inf 0 num_notes+1]);
xlabel(['timesteps 250:500']);
legend('original', 'network')
title(['network output vs. teacher output ']);
set(0,'DefaultFigureWindowStyle','normal');

set(0,'DefaultFigureWindowStyle','docked');
figure('Name',['output_2'], 'NumberTitle', 'off');
plot( real_blob(1,500:750), 'b' );
hold on
plot( fake_blob(1,500:750), 'r' );
hold off
axis([0 inf 0 num_notes+1]);
xlabel(['timesteps 500:750']);
legend('original', 'network')
title(['network output vs. teacher output ']);
set(0,'DefaultFigureWindowStyle','normal');

set(0,'DefaultFigureWindowStyle','docked');
figure('Name',['output_3'], 'NumberTitle', 'off');
plot( real_blob(1,750:1000), 'b' );
hold on
plot( fake_blob(1,750:1000), 'r' );
hold off
axis([0 inf 0 num_notes+1]);
xlabel(['timesteps 750:1000']);
legend('original', 'network')
title(['network output vs. teacher output ']);
set(0,'DefaultFigureWindowStyle','normal');

set(0,'DefaultFigureWindowStyle','docked');
figure('Name',['output_4'], 'NumberTitle', 'off');
plot( real_blob(1,1000:1250), 'b' );
hold on
plot( fake_blob(1,1000:1250), 'r' );
hold off
axis([0 inf 0 num_notes+1]);
xlabel(['timesteps 1000:1250']);
legend('original', 'network')
title(['network output vs. teacher output ']);
set(0,'DefaultFigureWindowStyle','normal');
%}
%% W_out (1:num_notes+1, timesteps) - output weights for notes
tsp_wout = transpose(W_out);
%{
set(0,'DefaultFigureWindowStyle','docked');
for nt = 4:4:num_notes+1
  for k = 1:1 %ts_wout-1
    figure('Name',['W_out_note_' num2str(nt-1) '_t' num2str(k*100)], 'NumberTitle', 'off');
    plot(tsp_wout(k:100, nt));
    %axis([0 inf -1 1]);
    xlabel(['timesteps ' num2str(k) ' - ' num2str(100)]);
    title(['W^{out} note: ' num2str(nt-1)]);
  end
end
set(0,'DefaultFigureWindowStyle','normal');
%}


%% W_out (num_notes+2:output_length, timesteps) - output weights for duration
%{
set(0,'DefaultFigureWindowStyle','docked');
for nt = num_notes+2:output_length
  for k = 1:ts_wout-1
    figure('Name',['W_out_dur_' num2str(nt-num_notes-1) '_t' num2str(k*100)], 'NumberTitle', 'off');
    plot(tsp_wout(k*100:k*100+100, nt));
    %axis([0 inf -1 1]);
    xlabel(['timesteps ' num2str(k*100) ' - ' num2str(k*100+100)]);
    title(['W^{out} dur: ' num2str(nt-num_notes-1)]);
  end
end
set(0,'DefaultFigureWindowStyle','normal');
%}

set(0,'DefaultFigureWindowStyle','docked');
for ts = 4:4 %ts_in-1
  for k = 2:7
    figure('Name',['blabla_bass_' cell2mat(rep(k-1)) '_' num2str(ts*ucoeff)], 'NumberTitle', 'off');
    plot(u(ts*ucoeff:ts*ucoeff + urange, k));
    hold on
    plot(blabla(ts*ucoeff:ts*ucoeff + urange, k));
    hold off
    axis([0 inf -1 1]);
    xlabel(['timesteps ' num2str(ts*ucoeff) ' - ' num2str(ts*ucoeff + urange)]);
    legend('raw', 'normalized');
    title(['input unit bass ' cell2mat(rep(k-1))]);
  end
end
set(0,'DefaultFigureWindowStyle','normal');
%}


%% input units - u(timesteps, 8:13) - lead track
%
% plot raw data vs. normalized data
% set ts to plot different time intervals of length 100
set(0,'DefaultFigureWindowStyle','docked');
for ts = 4:4 %ts_in-1
  for k = 8:13
    figure('Name',['blabla_guitar_' cell2mat(rep(k-7)) '_' num2str(ts*ucoeff)], 'NumberTitle', 'off');
    plot(u(ts*ucoeff:ts*ucoeff + urange, k));
    hold on
    plot(blabla(ts*ucoeff:ts*ucoeff + urange, k));
    hold off
    axis([0 inf -1 1]);
    xlabel(['timesteps ' num2str(ts*ucoeff) ' - ' num2str(ts*ucoeff + urange)]);
    legend('raw', 'normalized');
    title(['input unit guitar ' cell2mat(rep(k-7))]);
  end
end
set(0,'DefaultFigureWindowStyle','normal');
%}


%% input units - u(timesteps, 14) - beat
%
% plot raw data vs. normalized data
% set ts to plot different time intervals of length 100
set(0,'DefaultFigureWindowStyle','docked');
for ts = 4:4 %ts_in-1
  figure('Name',['blabla_beat_' num2str(ts*ucoeff)], 'NumberTitle', 'off');
  plot(u(ts*ucoeff:ts*ucoeff + urange, 14));
  hold on
  plot(blabla(ts*ucoeff:ts*ucoeff + urange, 14));
  hold off
  axis([0 inf -1 1]);
  xlabel(['timesteps ' num2str(ts*ucoeff) ' - ' num2str(ts*ucoeff + urange)]);
  legend('raw', 'normalized');
  title(['input unit beat ']);
end
set(0,'DefaultFigureWindowStyle','normal');
%}

%% save all plots as .png
%{
h = get(0,'children');
%h = sort(h);
for i=1:length(h)
  saveas(h(i), get(h(i),'Name'), 'png');
end
%}
