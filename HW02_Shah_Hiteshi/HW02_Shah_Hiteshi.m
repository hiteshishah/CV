% Name: Hiteshi Shah (hss7374)
% Homework 2
%

% initializing the value of lambda
lambda = 128;

% initializing the values of x, ranging from 0 to 768
x = 0:768;

% initializing the array that stores the sine wave
sine_wave = zeros(size(x));

% initializing the array that stores the final sum of all 11 sine waves
final_wave = zeros(size(x));

% initializing the aray of colors for each of the 11 sine waves
colors = [1.0, 0.0, 0.0;
          0.0, 1.0, 0.0;
          0.0, 0.0, 1.0;
          1.0, 1.0, 0.0;
          0.0, 1.0, 1.0;
          1.0, 0.0, 1.0;
          0.5, 0.0, 0.0;
          0.0, 0.5, 0.0;
          0.0, 0.0, 0.5;
          0.5, 0.5, 0.0;
          0.0, 0.5, 0.5];
      
% for odd integers of k ranging from 1 to 21, calculate ths sine wave for
% each k, plot it and add it to the final wave
for k = 1:2:21
    sine_wave = (4 / pi / k) * sin(k * pi * x / lambda);
    plot(sine_wave, 'Color', colors(round(k / 2),:), 'DisplayName', strcat('Component ', num2str(round(k / 2))), 'LineWidth', 1); hold on;
    final_wave = final_wave + sine_wave;
end

% plot the final wave in black
plot(final_wave, 'Color', [0.0, 0.0, 0.0], 'DisplayName', 'Total', 'LineWidth', 1);

% display legend
legend('show');

% label the x axis
xlabel('Sample Number');

% title the graph
title('Adding sine waves to get a square waveform')