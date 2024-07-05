% function [R] = sampleMap_solution(A, fs)
%     % This function converts audio data values into spatial data values and displays them
%     % A is the input audio signal
%     % fs is the sampling frequency
% 
%     % Get the length and values of the audio data
%     len = length(A);
% 
%     % Normalize the audio data to the range [0, 255]
%     minA = min(A);  % Find minimum value
%     maxA = max(A);  % Find maximum value
%     B = ((A - minA) / (maxA - minA)) * 255;  % Normalize to [0, 255]
% 
%     % Decide the image dimensions
%     RC = floor(sqrt(len));  % Calculate size for square image
% 
%     % Reshape the normalized data into a 2D array (grayscale image)
%     B = B(1:RC^2);  % Use only the first RC^2 samples to form a square image
%     R = reshape(B, [RC, RC]);
% 
%     % Calculate the energy of the audio signal in windows
%     win_size = round(length(A) / 16);  % Window size for energy calculation
%     N = round(len / win_size);  % Number of frames
%     energy = zeros(1, N);  % Preallocate energy array
%     for n = 1:N
%         st = (n-1) * win_size + 1;
%         ed = min(n * win_size, len);
%         energy(n) = Energy(A(st:ed), win_size);
%     end
% 
%     % Normalize the energy to [0, 255]
%     minE = min(energy);  % Find minimum energy
%     maxE = max(energy);  % Find maximum energy
%     energy = ((energy - minE) / (maxE - minE)) * 255;  % Normalize to [0, 255]
% 
%     % Use energy to modify the grayscale image
%     for i = 1:RC
%         for j = 1:RC
%             idx = (i-1) * RC + j;
%             if idx <= length(energy)
%                 R(i, j) = energy(idx);  % Assign energy value to the image
%             end
%         end
%     end
% end


function [RGB] = sampleMap_solution(A, fs)
    % This function converts audio data values into spatial data values and displays them
    % A is the input audio signal
    % fs is the sampling frequency

    % Get the length and values of the audio data
    len = length(A);

    % Normalize the audio data to the range [0, 255]
    minA = min(A);  % Find minimum value
    maxA = max(A);  % Find maximum value
    B = ((A - minA) / (maxA - minA)) * 255;  % Normalize to [0, 255]

    % Decide the image dimensions
    RC = floor(sqrt(len));  % Calculate size for square image
    B = B(1:RC^2);  % Use only the first RC^2 samples to form a square image
    R = reshape(B, [RC, RC]);

    % Calculate the energy of the audio signal in windows
    win_size = round(len / 16);  % Window size for energy calculation
    N = round(len / win_size);  % Number of frames
    energy = zeros(1, N);  % Preallocate energy array
    for n = 1:N
        st = (n-1) * win_size + 1;
        ed = min(n * win_size, len);
        energy(n) = Energy(A(st:ed), win_size);
    end

    % Normalize the energy to [0, 255]
    minE = min(energy);  % Find minimum energy
    maxE = max(energy);  % Find maximum energy
    energy = ((energy - minE) / (maxE - minE)) * 255;  % Normalize to [0, 255]

    % Reshape energy to match image dimensions
    energy_resized = imresize(energy, [RC, RC]);

    % Create RGB image and map energy values to RGB channels
    RGB = zeros(RC, RC, 3);
    RGB(:, :, 1) = R;  % Red channel
    RGB(:, :, 2) = R;  % Green channel
    RGB(:, :, 3) = energy_resized;  % Blue channel

    % Optionally, you can modify the mapping to create different color effects
    % Example: Uncomment to apply energy to red and green channels as well
    % RGB(:, :, 1) = energy_resized;  % Red channel
    % RGB(:, :, 2) = energy_resized;  % Green channel

    % Display the RGB image
    imshow(RGB, 'DisplayRange', [0 255]);
    title('RGB Image: Energy-based Color Mapping from Audio Data');
end

function [E] = Energy(Y, P)
    % This function calculates the energy of a given speech frame
    % Y is the signal to be calculated
    % P is the window size
    E = sum(abs(Y(1:P)));
end
