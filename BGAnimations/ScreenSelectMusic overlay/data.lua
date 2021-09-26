local t = Def.ActorFrame {}

local mPlayer = GAMESTATE:GetMasterPlayerNumber()

local getSMVersion = function()
	local version = ProductVersion()
	if type(version) ~= "string" then return {} end

	version = version:gsub("-.*", "")

	local v = {}
	for i in version:gmatch("[^%.]+") do
		table.insert(v, tonumber(i))
	end

	return v
end

function IsSMVersion(...)
	local version = getSMVersion()

	for i = 1, select('#', ...) do
		if select(i, ...) ~= version[i] then
			return false
		end
	end

	return true
end

local diff = ""

if IsSMVersion(5, 0, 12) or IsSMVersion(5, 1) then
	diff = "diff 1x6"
else
	diff = "diff 1x15"
end

local function DifficultyIcons(pn)
	local function set(self, player)
		if player and player ~= pn then return end
		local Selection = GAMESTATE:GetCurrentSteps(pn) or GAMESTATE:GetCurrentTrail(pn)

		if not Selection then
			self:Unset()
			return
		end
		local dc = Selection:GetDifficulty()
		self:SetFromDifficulty( dc )
	end

	local t = Def.DifficultyIcon {
		File=diff;
		InitCommand=function(self)
			self:player( pn )
			self:SetPlayer( pn )
		end;

		CurrentStepsP1ChangedMessageCommand=function(self) set(self, PLAYER_1) end;
		CurrentStepsP2ChangedMessageCommand=function(self) set(self, PLAYER_2) end;
		CurrentTrailP1ChangedMessageCommand=function(self) set(self, PLAYER_1) end;
		CurrentTrailP2ChangedMessageCommand=function(self) set(self, PLAYER_2) end;
	};
	return t;
end

--Song Info
t[#t+1] = Def.ActorFrame {
	InitCommand=function(self)
		cs = self:GetChildren();
	end;
	--Title
	LoadFont("MusicList titles")..{
		Name="Title";
		InitCommand=function(self) self:horizalign(left):zoom(0.82):x(-134):y(2) end;
	};
	--Artist
	LoadFont("MusicList titles")..{
		Name="Artist";
		InitCommand=function(self) self:horizalign(left):zoom(0.82):x(-134):y(24) end;
	};
	--Time
	LoadFont("ScreenSelectMusic total time")..{
		Name="Time";
		InitCommand=function(self) self:horizalign(center):y(88):x(69) end;
	};
	--True Time
	LoadFont("ScreenSelectMusic total time")..{
		Name="TrueTime";
		InitCommand=function(self) self:horizalign(center):y(88):x(69) end;
	};

	SetCommand=function(self)
		local song = GAMESTATE:GetCurrentSong()
		if song then
			--Song
			local title
			if song:GetDisplaySubTitle() == "" then
				title = song:GetDisplayMainTitle()
			else
				title = song:GetDisplayFullTitle()
			end;
			cs.Title:maxwidth(325)
			cs.Title:settext(title)

			local artist = song:GetDisplayArtist()
			cs.Artist:maxwidth(325)
			cs.Artist:settext(artist)

			local seconds = song:MusicLengthSeconds()
			local firstsecond = song:GetFirstSecond()
			local lastsecond = song:GetLastSecond()
			local trueseconds = lastsecond - firstsecond
			cs.Artist:diffusealpha(1)
			cs.Time:maxwidth(128):diffusealpha(1):settext(SecondsToMMSSMsMs(seconds))
			cs.Time:effectclock('timer'):diffuseshift():effectcolor1(color("#FFFFFFFF")):effectcolor2(color("#00000000")):effectperiod(4)
			cs.TrueTime:maxwidth(128):diffusealpha(1):settext(SecondsToMMSSMsMs(trueseconds))
			cs.TrueTime:effectclock('timer'):diffuseshift():effectcolor1(color("#00000000")):effectcolor2(color("#FFFFFFFF")):effectperiod(4)

			--Insane
			local insane = song:HasStepsTypeAndDifficulty(0,4)
			if insane then
				cs.Title:diffuse(Color("Red"))
			else
				cs.Title:diffuse(Color("White"))
			end;

		else
			--Not Song
			cs.Title:settext("No Song Selected")
			cs.Title:diffuse(Color("White"))
			cs.Artist:diffusealpha(0)
			cs.Time:diffusealpha(0)
			cs.TrueTime:diffusealpha(0)
		end
	end;
	--BPM
	Def.BPMDisplay {
		File=THEME:GetPathF("BPM", "Display");
		Name="BPMDisplay";
		InitCommand=function(self)
			self:x(5):y(133):horizalign(left):zoom(0.62):maxwidth(210)
		end;-- LEFT
		SetCommand=function(self)
			self:SetFromGameState()
			local song = GAMESTATE:GetCurrentSong()
			if song then
				local timingdata = song:GetTimingData()
				local bpms = song:GetDisplayBpms()
				local truebpms = timingdata:GetActualBPM()
				if bpms[1] == truebpms[1] and bpms[2] == truebpms[2] then
					self:stopeffect():diffuse(Color("White"))
				else
					local sets = timingdata:GetBPMsAndTimes()
					local currentSet, lastSet, duration
					local first = true
					local redCheck, orangeCheck, greenCheck = false, false, false

					for set in ivalues(sets) do
						currentSet = split("=",set)
						currentSet[2]=math.round( currentSet[2] * 1000 ) / 1000
						if first then first = false else
							duration = (currentSet[1]-lastSet[1]) / lastSet[2] * 60
							if duration > 5 then
								if bpms[1] < tonumber(lastSet[2]) and bpms[2] < tonumber(lastSet[2]) then
									-- FASTER THAN DISPLAYBPM
									redCheck = true
								elseif bpms[1] < tonumber(lastSet[2]) and bpms[2] > tonumber(lastSet[2]) then
									-- WITHIN DISPLAYBPM
								elseif bpms[1] > tonumber(lastSet[2]) and bpms[2] > tonumber(lastSet[2]) then
									-- SLOWER THAN DISPLAYBPM
									greenCheck = true
								end
							else
								if bpms[1] < tonumber(lastSet[2]) and bpms[2] < tonumber(lastSet[2]) then
									-- FASTER THAN DISPLAYBPM
									orangeCheck = true
								end
							end
						end
						lastSet = currentSet
					end

					duration = (song:GetLastBeat()-lastSet[1]) / lastSet[2] * 60
					if duration > 5 then
						if bpms[1] < tonumber(lastSet[2]) and bpms[2] < tonumber(lastSet[2]) then
							-- FASTER THAN DISPLAYBPM
							redCheck = true
						elseif bpms[1] < tonumber(lastSet[2]) and bpms[2] > tonumber(lastSet[2]) then
							-- WITHIN DISPLAYBPM
						elseif bpms[1] > tonumber(lastSet[2]) and bpms[2] > tonumber(lastSet[2]) then
							-- SLOWER THAN DISPLAYBPM
							greenCheck = true
						end
					else
						if bpms[1] < tonumber(lastSet[2]) and bpms[2] < tonumber(lastSet[2]) then
							-- FASTER THAN DISPLAYBPM
							orangeCheck = true
						end
					end

					if redCheck then
						self:effectclock('beat'):diffuseshift():effectcolor1(color("#FF0000FF")):effectcolor2(color("#FF000080")):effectperiod(1)
					elseif orangeCheck then
						self:effectclock('beat'):diffuseshift():effectcolor1(color("#FF8800FF")):effectcolor2(color("#FF880080")):effectperiod(1)
					elseif greenCheck then
						self:effectclock('beat'):diffuseshift():effectcolor1(color("#00FF00FF")):effectcolor2(color("#00FF0080")):effectperiod(1)
					else
						self:stopeffect():diffuse(Color("White"))
					end
				end
			end
		end;
	};

	-- difficulty icons
	DifficultyIcons(PLAYER_1) .. {
		BeginCommand=function(self)
			if not GAMESTATE:IsHumanPlayer(PLAYER_2) then
				self:x(76):y(-52):zoom(0.8)
			else
				self:x(76-32):y(-52):zoom(0.8):setsize(90,55)
			end
		end;
		SetCommand=function(self)
			self:queuecommand("Begin")
			if not GAMESTATE:GetCurrentSong() or not GAMESTATE:IsHumanPlayer(PLAYER_1) then self:visible(false)
			else self:visible(true)
			end
		end;
	};
	DifficultyIcons(PLAYER_2) .. {
		BeginCommand=function(self)
			if not GAMESTATE:IsHumanPlayer(PLAYER_1) then
				self:x(76):y(-52):zoom(0.8)
			else
				self:x(76+32):y(-52):zoom(0.8):setsize(90,55)
			end
		end;
		SetCommand=function(self)
			self:queuecommand("Begin")
			if not GAMESTATE:GetCurrentSong() or not GAMESTATE:IsHumanPlayer(PLAYER_2) then self:visible(false)
			else self:visible(true)
			end
		end;
	};

--Panel Names (Left Side)
LoadFont("Panedisplay Blurred")..{
	InitCommand=function(self) self:zoom(0.35):horizalign(left):y(69):x(-132):maxwidth(160):diffusealpha(0.6):zoomx(0.37) end;
	SetCommand=function(self)
		local name = "STEPS"
		steps = GAMESTATE:GetCurrentSteps(mPlayer)
		local song = GAMESTATE:GetCurrentSong()
		if song and steps ~=nil then
			if GAMESTATE:GetNumPlayersEnabled() == 1 then
				local GetRadar = GAMESTATE:GetCurrentSteps(mPlayer):GetRadarValues(mPlayer)
				if GetRadar:GetValue('RadarCategory_Fakes') > 0 then
					name = name .. "?"
				end
			else
				stepsP1 = GAMESTATE:GetCurrentSteps(PLAYER_1)
				stepsP2 = GAMESTATE:GetCurrentSteps(PLAYER_2)
				if stepsP1 ~=nil and stepsP2 ~=nil then
					local GetRadarP1 = GAMESTATE:GetCurrentSteps(PLAYER_1):GetRadarValues(PLAYER_1)
					local GetRadarP2 = GAMESTATE:GetCurrentSteps(PLAYER_2):GetRadarValues(PLAYER_2)
					if GetRadarP1:GetValue('RadarCategory_Fakes') > 0 or GetRadarP2:GetValue('RadarCategory_Fakes') > 0 then
						name = name .. "?"
					end
				end
			end
		end
		self:settext(name)
	end;
};
LoadFont("Panedisplay Blurred")..{
	InitCommand=function(self) self:zoom(0.35):horizalign(left):y(90):x(-132):maxwidth(160):diffusealpha(0.6) end;
	SetCommand=function(self)
		self:settext("JUMPS")
	end;
};
LoadFont("Panedisplay Blurred")..{
	InitCommand=function(self) self:zoom(0.35):horizalign(left):y(111):x(-132):maxwidth(160):diffusealpha(0.6) end;
	SetCommand=function(self)
		self:settext("HANDS")
	end;
};
LoadFont("Panedisplay Blurred")..{
	InitCommand=function(self) self:zoom(0.35):horizalign(left):y(132):x(-132):maxwidth(160):diffusealpha(0.6) end;
	SetCommand=function(self)
		local name = "HOLDS"
		steps = GAMESTATE:GetCurrentSteps(mPlayer)
		local song = GAMESTATE:GetCurrentSong()
		if song and steps ~=nil then
			if GAMESTATE:GetNumPlayersEnabled() == 1 then
				local GetRadar = GAMESTATE:GetCurrentSteps(mPlayer):GetRadarValues(mPlayer)
				if GetRadar:GetValue('RadarCategory_Rolls') > 0 then
					name = name .. "+ROLLS"
				end
				if GetRadar:GetValue('RadarCategory_Lifts') > 0 then
					name = name .. "+LIFTS"
				end
			else
				stepsP1 = GAMESTATE:GetCurrentSteps(PLAYER_1)
				stepsP2 = GAMESTATE:GetCurrentSteps(PLAYER_2)
				if stepsP1 ~=nil and stepsP2 ~=nil then
					local GetRadarP1 = GAMESTATE:GetCurrentSteps(PLAYER_1):GetRadarValues(PLAYER_1)
					local GetRadarP2 = GAMESTATE:GetCurrentSteps(PLAYER_2):GetRadarValues(PLAYER_2)
					if GetRadarP1:GetValue('RadarCategory_Rolls') > 0 or GetRadarP2:GetValue('RadarCategory_Rolls') > 0 then
						name = name .. "+ROLLS"
					end
					if GetRadarP1:GetValue('RadarCategory_Lifts') > 0 or GetRadarP2:GetValue('RadarCategory_Lifts') > 0 then
						name = name .. "+LIFTS"
					end
				end
			end
		end
		self:settext(name)
	end;
};

--Panel Names (Right Side)
	LoadFont("Panedisplay Blurred")..{
		InitCommand=function(self) self:zoom(0.35):horizalign(left):y(70):x(10):diffusealpha(0.6):zoomx(0.33) end;
		SetCommand=function(self)
			self:settext("S O N G   L E N G T H"):maxwidth(360)
			self:effectclock('timer'):diffuseshift():effectcolor1(color("#FFFFFFFF")):effectcolor2(color("#00000000")):effectperiod(4)
		end;
	};
	LoadFont("Panedisplay Blurred")..{
		InitCommand=function(self) self:zoom(0.35):horizalign(left):y(70):x(10):diffusealpha(0.6):zoomx(0.33) end;
		SetCommand=function(self)
			self:settext("T R U E   L E N G T H"):maxwidth(360)
			self:effectclock('timer'):diffuseshift():effectcolor1(color("#00000000")):effectcolor2(color("#FFFFFFFF")):effectperiod(4)
		end;
	};
	LoadFont("Panedisplay Blurred")..{
		InitCommand=function(self) self:zoom(0.35):horizalign(left):y(115):x(10):diffusealpha(0.6):zoomx(0.34) end;
		SetCommand=function(self)
			self:settext("B P M")
			local song = GAMESTATE:GetCurrentSong()
			if song then
				local timingdata = song:GetTimingData()
				local bpms = song:GetDisplayBpms()
				local truebpms = timingdata:GetActualBPM()
				if bpms[1] == truebpms[1] and bpms[2] == truebpms[2] then else
					self:settext("D I S P L A Y B P M"):maxwidth(350)
				end
			end
		end;
	};

--Panel Values (Right Side)
	LoadFont("Panedisplay Text")..{
		InitCommand=function(self) self:zoom(0.36):horizalign(right):y(70):x(-11):maxwidth(170) end;
		SetCommand=function(self)
			local name = ""
			steps = GAMESTATE:GetCurrentSteps(mPlayer)
			local song = GAMESTATE:GetCurrentSong()
			if song and steps ~=nil then
				if GAMESTATE:GetNumPlayersEnabled() == 1 then
					local GetRadar = GAMESTATE:GetCurrentSteps(mPlayer):GetRadarValues(mPlayer)
					name = GetRadar:GetValue('RadarCategory_TapsAndHolds')
				else
					stepsP1 = GAMESTATE:GetCurrentSteps(PLAYER_1)
					stepsP2 = GAMESTATE:GetCurrentSteps(PLAYER_2)
					if stepsP1 ~=nil and stepsP2 ~=nil then
						local GetRadarP1 = GAMESTATE:GetCurrentSteps(PLAYER_1):GetRadarValues(PLAYER_1)
						local GetRadarP2 = GAMESTATE:GetCurrentSteps(PLAYER_2):GetRadarValues(PLAYER_2)
						local statsP1 = GetRadarP1:GetValue('RadarCategory_TapsAndHolds')
						local statsP2 = GetRadarP2:GetValue('RadarCategory_TapsAndHolds')
						name = statsP1 .. " | " .. statsP2
					end
				end
			end
			self:settext(name)
		end;
	};
	LoadFont("Panedisplay Text")..{
		InitCommand=function(self) self:zoom(0.36):horizalign(right):y(91):x(-11):maxwidth(170) end;
		SetCommand=function(self)
			local name = ""
			steps = GAMESTATE:GetCurrentSteps(mPlayer)
			local song = GAMESTATE:GetCurrentSong()
			if song and steps ~=nil then
				if GAMESTATE:GetNumPlayersEnabled() == 1 then
					local GetRadar = GAMESTATE:GetCurrentSteps(mPlayer):GetRadarValues(mPlayer)
					name = GetRadar:GetValue('RadarCategory_Jumps')
				else
					stepsP1 = GAMESTATE:GetCurrentSteps(PLAYER_1)
					stepsP2 = GAMESTATE:GetCurrentSteps(PLAYER_2)
					if stepsP1 ~=nil and stepsP2 ~=nil then
						local GetRadarP1 = GAMESTATE:GetCurrentSteps(PLAYER_1):GetRadarValues(PLAYER_1)
						local GetRadarP2 = GAMESTATE:GetCurrentSteps(PLAYER_2):GetRadarValues(PLAYER_2)
						local statsP1 = GetRadarP1:GetValue('RadarCategory_Jumps')
						local statsP2 = GetRadarP2:GetValue('RadarCategory_Jumps')
						name = statsP1 .. " | " .. statsP2
					end
				end
			end
			self:settext(name)
		end;
	};
	LoadFont("Panedisplay Text")..{
		InitCommand=function(self) self:zoom(0.36):horizalign(right):y(112):x(-11):maxwidth(170) end;
		SetCommand=function(self)
			local name = ""
			steps = GAMESTATE:GetCurrentSteps(mPlayer)
			local song = GAMESTATE:GetCurrentSong()
			if song and steps ~=nil then
				if GAMESTATE:GetNumPlayersEnabled() == 1 then
					local GetRadar = GAMESTATE:GetCurrentSteps(mPlayer):GetRadarValues(mPlayer)
					name = GetRadar:GetValue('RadarCategory_Hands')
				else
					stepsP1 = GAMESTATE:GetCurrentSteps(PLAYER_1)
					stepsP2 = GAMESTATE:GetCurrentSteps(PLAYER_2)
					if stepsP1 ~=nil and stepsP2 ~=nil then
						local GetRadarP1 = GAMESTATE:GetCurrentSteps(PLAYER_1):GetRadarValues(PLAYER_1)
						local GetRadarP2 = GAMESTATE:GetCurrentSteps(PLAYER_2):GetRadarValues(PLAYER_2)
						local statsP1 = GetRadarP1:GetValue('RadarCategory_Hands')
						local statsP2 = GetRadarP2:GetValue('RadarCategory_Hands')
						name = statsP1 .. " | " .. statsP2
					end
				end
			end
			self:settext(name)
		end;
	};
	LoadFont("Panedisplay Text")..{
		InitCommand=function(self) self:zoom(0.36):horizalign(right):y(133):x(-11):maxwidth(170) end;
		SetCommand=function(self)
			local name = ""
			steps = GAMESTATE:GetCurrentSteps(mPlayer)
			local song = GAMESTATE:GetCurrentSong()
			if song and steps ~=nil then
				if GAMESTATE:GetNumPlayersEnabled() == 1 then
					local GetRadar = GAMESTATE:GetCurrentSteps(mPlayer):GetRadarValues(mPlayer)
					name = GetRadar:GetValue('RadarCategory_Holds')
					if GetRadar:GetValue('RadarCategory_Rolls') > 0 then
						name = name .. "+" .. GetRadar:GetValue('RadarCategory_Rolls')
					end
					if GetRadar:GetValue('RadarCategory_Lifts') > 0 then
						name = name .. "+" .. GetRadar:GetValue('RadarCategory_Lifts')
					end
				else
					stepsP1 = GAMESTATE:GetCurrentSteps(PLAYER_1)
					stepsP2 = GAMESTATE:GetCurrentSteps(PLAYER_2)
					if stepsP1 ~=nil and stepsP2 ~=nil then
						local GetRadarP1 = GAMESTATE:GetCurrentSteps(PLAYER_1):GetRadarValues(PLAYER_1)
						local GetRadarP2 = GAMESTATE:GetCurrentSteps(PLAYER_2):GetRadarValues(PLAYER_2)
						local statsP1 = GetRadarP1:GetValue('RadarCategory_Holds')
						local statsP2 = GetRadarP2:GetValue('RadarCategory_Holds')
						if GetRadarP1:GetValue('RadarCategory_Rolls') > 0 then
							statsP1 = statsP1 .. "+" .. GetRadarP1:GetValue('RadarCategory_Rolls')
						end
						if GetRadarP2:GetValue('RadarCategory_Rolls') > 0 then
							statsP2 = statsP2 .. "+" .. GetRadarP2:GetValue('RadarCategory_Rolls')
						end
						if GetRadarP1:GetValue('RadarCategory_Lifts') > 0 then
							statsP1 = statsP1 .. "+" .. GetRadarP1:GetValue('RadarCategory_Lifts')
						end
						if GetRadarP2:GetValue('RadarCategory_Lifts') > 0 then
							statsP2 = statsP2 .. "+" .. GetRadarP2:GetValue('RadarCategory_Lifts')
						end
						name = statsP1 .. " | " .. statsP2
					end
				end
			end
			self:settext(name)
		end;
	};

	Def.Sprite {
		Texture='mine';
		Frames = Sprite.LinearFrames( 8, 1 );
		InitCommand=function(self) self:effectclock('beat'):addx(180):addy(12):visible(false) end;
		SetCommand=function(self)
			local mPlayer = GAMESTATE:GetMasterPlayerNumber()
			steps = GAMESTATE:GetCurrentSteps(mPlayer)
			local song = GAMESTATE:GetCurrentSong()
			if song and steps ~=nil then
				if GAMESTATE:GetNumPlayersEnabled() == 1 then
					local GetRadar = GAMESTATE:GetCurrentSteps(mPlayer):GetRadarValues(mPlayer)
					if GetRadar:GetValue('RadarCategory_Mines') > 0 then
						self:visible(true)
					else
						self:visible(false)
					end
				else
					stepsP1 = GAMESTATE:GetCurrentSteps(PLAYER_1)
					stepsP2 = GAMESTATE:GetCurrentSteps(PLAYER_2)
					if stepsP1 ~=nil and stepsP2 ~=nil then
						local GetRadarP1 = GAMESTATE:GetCurrentSteps(PLAYER_1):GetRadarValues(PLAYER_1)
						local GetRadarP2 = GAMESTATE:GetCurrentSteps(PLAYER_2):GetRadarValues(PLAYER_2)
						if GetRadarP1:GetValue('RadarCategory_Mines') > 0 or GetRadarP2:GetValue('RadarCategory_Mines') > 0 then
							self:visible(true):cropleft(0):cropright(0)
							if GetRadarP1:GetValue('RadarCategory_Mines') == 0 and GetRadarP2:GetValue('RadarCategory_Mines') > 0 then
								self:cropleft(0.5)
							elseif GetRadarP1:GetValue('RadarCategory_Mines') > 0 and GetRadarP2:GetValue('RadarCategory_Mines') == 0 then
								self:cropright(0.5)
							end
						else
							self:visible(false)
						end
					else
						self:visible(false)
					end
				end
			else
				self:visible(false)
			end
		end;
	};

	CurrentSongChangedMessageCommand=function(self) self:playcommand("Set") end;
	CurrentCourseChangedMessageCommand=function(self) self:playcommand("Set") end;
	CurrentStepsP1ChangedMessageCommand=function(self) self:playcommand("Set") end;
	CurrentStepsP2ChangedMessageCommand=function(self) self:playcommand("Set") end;
};

return t;