function treasureHuntGame()

    % Initialize game parameters
    gridSize = 10;
    playerPosition = [1, 1];
    treasurePosition = randi([1, gridSize], 1, 2);
    movesCount = 0;
    treasureFound = false; % Variable to track if treasure is found
    
    % Create a figure for the game display
    fig = figure;
    set(fig, 'KeyPressFcn', @keyPressCallback, 'UserData', 'none');
    
    % Run the game loop
    while ishandle(fig) && calculateDistance(playerPosition, treasurePosition) > 1
        % Display the game grid
        drawGameGrid(gridSize, playerPosition, treasurePosition, movesCount, treasureFound);
        
        % Get user input
        direction = getUserInput(fig);
        
        % Update player position only if there's a valid direction
        if ~strcmp(direction, 'none') && ~treasureFound
            playerPosition = updatePlayerPosition(playerPosition, direction, gridSize);
            movesCount = movesCount + 1;
        end
        
        % Calculate distance to the treasure
        distance = calculateDistance(playerPosition, treasurePosition);
        
        % Check if the player found the treasure
        if isTreasureFound(distance)
            treasureFound = true;
        end
        
        % Pause for a short duration to make the game visually appealing
        pause(0.1);
    end

    % Display the final grid and message
    drawGameGrid(gridSize, playerPosition, treasurePosition, movesCount, treasureFound);
    
    if ishandle(fig)
        disp(['Congratulations! You found the treasure in ', num2str(movesCount), ' moves.']);
    else
        disp('Game ended.');
    end

end



function drawGameGrid(gridSize, playerPosition, treasurePosition, movesCount, treasureFound)
    % Display the game grid with images representing player, treasure, and background
    
    % Create a blank grid as the background
    background = zeros(gridSize, gridSize, 3); % 3 channels for RGB
    
    % Set player position
    background(playerPosition(1), playerPosition(2), :) = [1, 0, 0]; % player (red)
    
    % Set treasure position only if it's found
    if treasureFound
        background(treasurePosition(1), treasurePosition(2), :) = [1, 1, 0]; % treasure (yellow)
    end
    
    % Display the game grid using imshow
    imshow(background, 'InitialMagnification', 'fit');
    
    % Set title with current distance to the treasure
    title(['Moves: ', num2str(movesCount), ', Distance to treasure: ', num2str(calculateDistance(playerPosition, treasurePosition))], 'FontSize', 14);
end

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

function result = isAtTreasure(position, treasurePosition)
    % Check if the player is at the treasure position
    
    result = all(position == treasurePosition);
end






