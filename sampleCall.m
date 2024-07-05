
%sample call

fileNames = {'Ring02.wav', 'Windows Battery Critical.wav', 'nokia_03.wav'};
for i = 1:length(fileNames)
    [A, fs] = audioread(fileNames{i}); % get the sound

    R1 = sampleMap1(A);  
    R2 = sampleMap2(A);  
    
    % Determine the target size from R1 (assuming R1 is the reference size)
    targetSize = [size(R1, 1), size(R1, 2)];
    disp(['Target size: ', num2str(targetSize)]);
    
    R3 = sampleSolution(A, 100, targetSize);  
    disp(['R3 size: ', num2str(size(R3))]);
    
    figure(i);
    subplot(1, 4, 1); plot(A); title(['Audio Signal ' num2str(i)]);
    
    % Reset colormap to default and display "Map1"
    colormap('default');
    subplot(1, 4, 2); imshow(R1, 'DisplayRange', [0 255]); title('Map1');
    
    % Display "Map2"
    subplot(1, 4, 3); imshow(R2, 'DisplayRange', [0 255]); title('Map2');
    
    % Apply the 'jet' colormap and display "Map3"
    subplot(1, 4, 4); imshow(R3, 'DisplayRange', [0 255]); title('Map3 (Solution)');
    colormap(jet(256));
    colorbar;
end