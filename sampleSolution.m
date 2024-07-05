function R = sampleSolution(A, win, targetSize)
    N = round(sqrt(length(A)/win)); % number of frames
    st = 1;
    x = zeros(N^2, 1); % preallocate x for efficiency
    for n = 1:N^2
        endIdx = min(st + win - 1, length(A)); % ensure endIdx doesn't exceed length of A
        e = Energy(A(st:endIdx), win);
        x(n) = e;
        st = st + win;
        if st > length(A) - win
            break; % exit loop if starting index exceeds the length of A
        end
    end
    minX = min(x);
    maxX = max(x);
    B = zeros(size(x)); % preallocate B for efficiency
    % map the value
    for i = 1:length(x)
        B(i) = round((x(i) - minX) * 255 / (maxX - minX));  % map the range between 0-255
    end

    R = reshape(B, [N, length(B) / N]); % reshape the value into an image
    R = R / 0.7;  % use of division to make contrast
    
    % Resize R to the target size
    R = imresize(R, targetSize);  % Resize R to the target size
    disp(['Resized R to target size: ', num2str(size(R))]);
end
