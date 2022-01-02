function GetLives(player)
	local song, steps = nil, nil;
	local stepCounter, holdCounter, songInSeconds = 0, 0, 0;
	local lives = 1;

	if GAMESTATE:IsCourseMode() then
		songs = GAMESTATE:GetCurrentCourse()
		steps = GAMESTATE:GetCurrentTrail(player)
		for entry in ivalues(steps:GetTrailEntries()) do
			stepCounter = stepCounter + entry:GetSteps():GetRadarValues(player):GetValue('RadarCategory_TapsAndHolds')
			holdCounter = holdCounter + entry:GetSteps():GetRadarValues(player):GetValue('RadarCategory_Holds')
			songInSeconds = songInSeconds + (entry:GetSong():GetLastSecond() - entry:GetSong():GetFirstSecond())
		end
	else
		songs = GAMESTATE:GetCurrentSong()
		steps = GAMESTATE:GetCurrentSteps(player)
		stepCounter = steps:GetRadarValues(player):GetValue('RadarCategory_TapsAndHolds')
		holdCounter = steps:GetRadarValues(player):GetValue('RadarCategory_Holds')
		songInSeconds = songInSeconds + (songs:GetLastSecond() - songs:GetFirstSecond())
	end

	if not GAMESTATE:IsCourseMode() then
		-- Insane
		if steps:GetDifficulty() == "Difficulty_Challenge" then
			lives = 70;
		end
		-- Nonstop
		if steps:GetDescription() == 'Nonstop' then
			lives = 5;
		end
	end

	if lives < 5 then
		if holdCounter >= 15 and holdCounter < 25 then
			lives = 25;
		elseif holdCounter >= 25 and holdCounter < 50 then
			lives = 20;
		elseif holdCounter >= 50 and holdCounter < 100 then
			lives = 10;
		elseif holdCounter >= 100 then
			lives = 5;
		else
			local calc = songInSeconds / stepCounter * 100;
			lives = math.ceil( calc / 5 ) * 5;

			if lives < 10 then
				lives = 10;
			end;
			if lives > 60 then
				lives = 60;
			end
		end
	end

	return lives;
end