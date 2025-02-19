function treasureHuntGame()

    % Initialize game parameters
    gridSize = 10;
    levels = 3; % Number of levels
    playerPosition = [1, 1];
    treasurePosition = [randi([1, gridSize]), randi([1, gridSize])];
    movesCount = 0;
    treasureFound = false; % Variable to track if treasure is found
    level = 1; % Initial level
    
    % Connect to the stimulation box
    %[rt, ~] = ctrlArduinoStim_hrc('init');
    
    % Create a figure for the game display
    fig = figure;
    set(fig, 'KeyPressFcn', @keyPressCallback, 'UserData', 'none');
    
    % Run the game loop
    while ishandle(fig) && level <= levels
        % Display the game grid
        drawGameGrid(gridSize, playerPosition, treasurePosition, movesCount, treasureFound, level);
        
        % Get user input
        direction = getUserInput(fig);
        
        % Update player position only if there's a valid direction
        if ~strcmp(direction, 'none') && ~treasureFound
            [playerPosition, hitObstacle] = updatePlayerPosition(playerPosition, direction, gridSize, level);
            movesCount = movesCount + 1;
            
            % Check for obstacle collision
            if hitObstacle
                disp('You hit an obstacle! Try a different path.');
                movesCount = movesCount - 1; % Don't count the move if it hits an obstacle
            end
        end
        
        % Calculate distance to the treasure
        distance = calculateDistance(playerPosition, treasurePosition);
        
        % Check if the player found the treasure
        if isTreasureFound(distance)
            treasureFound = true;
        end
        
        % Deliver stimulation based on distance
        %deliverStimulation(distance, rt);
        
        % Pause for a short duration to make the game visually appealing
        pause(0.1);
        
        
        % Check if the player completed the level
        if treasureFound && level <= levels
            disp(['Congratulations! You found the treasure in ', num2str(movesCount), ' moves.']);
            % Move to the next level
            level = level + 1;
            playerPosition = [1, 1];
            treasurePosition = [randi([1, gridSize]), randi([1, gridSize])];
            treasureFound = false;
            movesCount = 0;
            pause(2); % Pause for a moment before starting the next level
        end
    end

    % Display the final grid and message
    drawGameGrid(gridSize, playerPosition, treasurePosition, movesCount, treasureFound, level);
    
    % Close the connection to the stimulation box
    %ctrlArduinoStim_hrc('close');
    
    if ishandle(fig)
        disp(['Congratulations! You completed all levels in ', num2str(movesCount), ' moves.']);
    else
        disp('Game ended.');
    end

end

function drawGameGrid(gridSize, playerPosition, treasurePosition, movesCount, treasureFound, level)
    % Display the game grid with graphics for player, treasure, obstacles, and background
    
    % Create a blank grid as the background
    background = zeros(gridSize, gridSize, 3); % 3 channels for RGB
    
    % Set player position with a little person graphic (blue)
    background(playerPosition(1), playerPosition(2), :) = [0, 0, 1];
    
    % Set treasure position with a treasure chest graphic (yellow)
    background(treasurePosition(1), treasurePosition(2), :) = [1, 1, 0];
    
    % Set obstacles randomly on the grid (gray) with fewer obstacles
    obstacles = randi([0, 1], gridSize, gridSize);
    obstacles = obstacles & randi([0, 1], gridSize, gridSize);
    background(obstacles == 1) = 0.5;
    
    % Display the game grid using imshow
    imshow(background, 'InitialMagnification', 'fit');
    
    % Set title with current distance to the treasure and level
    title(['Level: ', num2str(level), ', Moves: ', num2str(movesCount), ', Distance to treasure: ', num2str(calculateDistance(playerPosition, treasurePosition))], 'FontSize', 14);
end

% (The rest of the functions remain unchanged)
function keyPressCallback(fig, ~)
    % Handle key presses for player movement
    
    % Store the direction in UserData
    switch fig.CurrentKey
        case 'leftarrow'
            fig.UserData = 'left';
        case 'rightarrow'
            fig.UserData = 'right';
        case 'uparrow'
            fig.UserData = 'up';
        case 'downarrow'
            fig.UserData = 'down';
    end
end

function direction = getUserInput(fig)
    % Get user input for movement
    
    % Retrieve the direction from UserData and reset it
    direction = fig.UserData;
    fig.UserData = 'none';
end

function newPosition = updatePlayerPosition(currentPosition, direction, gridSize)
    % Update player position based on the movement direction
    
    newPosition = currentPosition;
    
    switch direction
        case 'left'
            newPosition(2) = max(1, currentPosition(2) - 1);
        case 'right'
            newPosition(2) = min(gridSize, currentPosition(2) + 1);
        case 'up'
            newPosition(1) = max(1, currentPosition(1) - 1);
        case 'down'
            newPosition(1) = min(gridSize, currentPosition(1) + 1);
    end
end

function distance = calculateDistance(position1, position2)
    % Calculate Manhattan distance between two positions
    
    distance = abs(position1(1) - position2(1)) + abs(position1(2) - position2(2));
end

function result = isTreasureFound(distance)
    % Check if the player found the treasure
    
    % You can adjust the threshold for finding the treasure based on distance
    threshold = 1; % Adjust as needed
    
    result = distance <= threshold;
end

% function deliverStimulation(distance, rt)
%     % Deliver stimulation based on the distance to the treasure
% 
%     % Define stimulation parameters
%     maxAmplitude = 2; % Adjust as needed
%     maxDistance = 10; % Adjust as needed
% 
%     % Calculate amplitude based on the distance
%     amplitude = maxAmplitude * (1 - distance / maxDistance);
%     amplitude = max(0, amplitude); % Ensure amplitude is non-negative
% 
%     % Deliver stimulation
%     ctrlArduinoStim_hrc('stim', [amplitude, 200, 30, 1], rt);
% end
% 
% 
