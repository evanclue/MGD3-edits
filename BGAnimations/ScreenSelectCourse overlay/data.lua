local t = Def.ActorFrame {};
local mPlayer = GAMESTATE:GetMasterPlayerNumber()

--Song Info
t[#t+1] = Def.ActorFrame {
	InitCommand=function(self) c = self:GetChildren(); end;
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
		local course = GAMESTATE:GetCurrentCourse();
		if course then
			--Course
			local title = course:GetDisplayFullTitle();
			c.Title:maxwidth(325);
			c.Title:settext(title);

			local artist = course:GetScripter();
			c.Artist:maxwidth(325);
			c.Artist:settext("Programmed by "..artist);

			local entries = course:GetCourseEntries()
			local seconds, trueseconds = 0, 0
			
			for entry in ivalues(course:GetCourseEntries()) do
				seconds = seconds + entry:GetSong():MusicLengthSeconds()
				local firstsecond = entry:GetSong():GetFirstSecond()
				local lastsecond = entry:GetSong():GetLastSecond()
				trueseconds = trueseconds + (lastsecond - firstsecond)
			end

			c.Artist:diffusealpha(1)
			c.Time:maxwidth(128):diffusealpha(1):settext(SecondsToMMSSMsMs(seconds))
			c.Time:effectclock('timer'):diffuseshift():effectcolor1(color("#FFFFFFFF")):effectcolor2(color("#00000000")):effectperiod(4)
			c.TrueTime:maxwidth(128):diffusealpha(1):settext(SecondsToMMSSMsMs(trueseconds))
			c.TrueTime:effectclock('timer'):diffuseshift():effectcolor1(color("#00000000")):effectcolor2(color("#FFFFFFFF")):effectperiod(4)

			c.Title:diffusealpha(1);
			c.Artist:diffusealpha(1);
		else
			--Not Course
			c.Title:diffusealpha(0);
			c.Artist:diffusealpha(0)
			c.Time:diffusealpha(0)
			c.TrueTime:diffusealpha(0)
		end;
	end;
	--BPM
	Def.BPMDisplay {
		File=THEME:GetPathF("BPM", "Display");
		Name="BPMDisplay";
		InitCommand=function(self) self:x(5):y(133):horizalign(left):zoom(0.62):maxwidth(210) end;-- LEFT
		SetCommand=function(self) self:SetFromGameState() end;
	};

	--Panel Names (Left Side)
	LoadFont("Panedisplay Blurred")..{
		InitCommand=function(self) self:zoom(0.35):horizalign(left):y(69):x(-132):maxwidth(160):diffusealpha(0.6):zoomx(0.37) end;
		SetCommand=function(self)
			local name = "STEPS"
			local trail = GAMESTATE:GetCurrentTrail(mPlayer)
			if trail then
				if GAMESTATE:GetNumPlayersEnabled() == 1 then
					local GetRadar = trail:GetRadarValues(mPlayer)
					if GetRadar:GetValue('RadarCategory_Fakes') > 0 then
						name = name .. "?"
					end
				else
					local GetRadarP1 = trail:GetRadarValues(PLAYER_1)
					local GetRadarP2 = trail:GetRadarValues(PLAYER_2)
					if GetRadarP1:GetValue('RadarCategory_Fakes') > 0 then
						name = name .. "?"
					end
					if GetRadarP2:GetValue('RadarCategory_Fakes') > 0 then
						name = name .. "?"
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
			local trail = GAMESTATE:GetCurrentTrail(mPlayer)
			if trail then
				if GAMESTATE:GetNumPlayersEnabled() == 1 then
					local GetRadar = trail:GetRadarValues(mPlayer)
					if GetRadar:GetValue('RadarCategory_Rolls') > 0 then
						name = name .. "+ROLLS"
					end
					if GetRadar:GetValue('RadarCategory_Lifts') > 0 then
						name = name .. "+LIFTS"
					end
				else
					local GetRadarP1 = trail:GetRadarValues(PLAYER_1)
					local GetRadarP2 = trail:GetRadarValues(PLAYER_2)
					if GetRadarP1:GetValue('RadarCategory_Rolls') > 0 or GetRadarP2:GetValue('RadarCategory_Rolls') > 0 then
						name = name .. "+ROLLS"
					end
					if GetRadarP1:GetValue('RadarCategory_Lifts') > 0 or GetRadarP2:GetValue('RadarCategory_Lifts') > 0 then
						name = name .. "+LIFTS"
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
		end;
	};

	--Panel Values (Right Side)
	LoadFont("Panedisplay Text")..{
		InitCommand=function(self) self:zoom(0.36):horizalign(right):y(70):x(-11):maxwidth(170) end;
		SetCommand=function(self)
			local name = ""
			local trail = GAMESTATE:GetCurrentTrail(mPlayer)
			if trail then
				if GAMESTATE:GetNumPlayersEnabled() == 1 then
					local GetRadar = trail:GetRadarValues(mPlayer)
					name = GetRadar:GetValue('RadarCategory_TapsAndHolds')
				else
					local GetRadarP1 = trail:GetRadarValues(PLAYER_1)
					local GetRadarP2 = trail:GetRadarValues(PLAYER_2)
					name = GetRadarP1:GetValue('RadarCategory_TapsAndHolds') .. " | " .. GetRadarP2:GetValue('RadarCategory_TapsAndHolds')
				end
			end
			self:settext(name)
		end;
	};
	LoadFont("Panedisplay Text")..{
		InitCommand=function(self) self:zoom(0.36):horizalign(right):y(91):x(-11):maxwidth(170) end;
		SetCommand=function(self)
			local name = ""
			local trail = GAMESTATE:GetCurrentTrail(mPlayer)
			if trail then
				if GAMESTATE:GetNumPlayersEnabled() == 1 then
					local GetRadar = trail:GetRadarValues(mPlayer)
					name = GetRadar:GetValue('RadarCategory_Jumps')
				else
					name = GetRadarP1:GetValue('RadarCategory_Jumps') .. " | " .. GetRadarP2:GetValue('RadarCategory_Jumps')
				end
			end
			self:settext(name)
		end;
	};
	LoadFont("Panedisplay Text")..{
		InitCommand=function(self) self:zoom(0.36):horizalign(right):y(112):x(-11):maxwidth(170) end;
		SetCommand=function(self)
			local name = ""
			local trail = GAMESTATE:GetCurrentTrail(mPlayer)
			if trail then
				if GAMESTATE:GetNumPlayersEnabled() == 1 then
					local GetRadar = trail:GetRadarValues(mPlayer)
					name = GetRadar:GetValue('RadarCategory_Hands')
				else
					local GetRadarP1 = trail:GetRadarValues(PLAYER_1)
					local GetRadarP2 = trail:GetRadarValues(PLAYER_2)
					name = GetRadarP1:GetValue('RadarCategory_Hands') .. " | " .. GetRadarP2:GetValue('RadarCategory_Hands')
				end
			end
			self:settext(name)
		end;
	};
	LoadFont("Panedisplay Text")..{
		InitCommand=function(self) self:zoom(0.36):horizalign(right):y(133):x(-11):maxwidth(170) end;
		SetCommand=function(self)
			local trail = GAMESTATE:GetCurrentTrail(mPlayer)
			if trail then
				if GAMESTATE:GetNumPlayersEnabled() == 1 then
					local GetRadar = trail:GetRadarValues(mPlayer)
					name = GetRadar:GetValue('RadarCategory_Holds')

					if GetRadar:GetValue('RadarCategory_Rolls') > 0 then
						name = name .. "+" .. GetRadar:GetValue('RadarCategory_Rolls')
					end

					if GetRadar:GetValue('RadarCategory_Lifts') > 0 then
						name = name .. "+" .. GetRadar:GetValue('RadarCategory_Lifts')
					end
				else
					local GetRadarP1 = trail:GetRadarValues(PLAYER_1)
					local GetRadarP2 = trail:GetRadarValues(PLAYER_2)
					statsP1 = GetRadarP1:GetValue('RadarCategory_Holds')
					statsP2 = GetRadarP2:GetValue('RadarCategory_Holds')

					if GetRadarP1:GetValue('RadarCategory_Rolls') > 0 or GetRadarP2:GetValue('RadarCategory_Rolls') > 0 then
						statsP1 = statsP1 .. "+" .. GetRadarP1:GetValue('RadarCategory_Rolls')
						statsP2 = statsP2 .. "+" .. GetRadarP2:GetValue('RadarCategory_Rolls')
					end

					if GetRadarP1:GetValue('RadarCategory_Lifts') > 0 or GetRadarP2:GetValue('RadarCategory_Lifts') > 0 then
						statsP1 = statsP1 .. "+" .. GetRadarP1:GetValue('RadarCategory_Lifts')
						statsP2 = statsP2 .. "+" .. GetRadarP2:GetValue('RadarCategory_Lifts')
					end
					name = statsP1 .. " | " .. statsP2
				end
			end
			self:settext(name)
		end;
	};

	Def.Sprite {
		Texture='../mine';
		Frames = Sprite.LinearFrames( 8, 1 );
		InitCommand=function(self) self:effectclock('beat'):addx(180):addy(12):visible(false) end;
		SetCommand=function(self)
			local trail = GAMESTATE:GetCurrentTrail(mPlayer)
			if trail and trails ~=nil then
				if GAMESTATE:GetNumPlayersEnabled() == 1 then
					local GetRadar = trail:GetRadarValues(mPlayer):GetValue('RadarCategory_Mines')

					if GetRadar > 0 then
						self:visible(true)
					else
						self:visible(false)
					end
				else
					local GetRadarP1 = trail:GetRadarValues(PLAYER_1):GetValue('RadarCategory_Mines')
					local GetRadarP2 = trail:GetRadarValues(PLAYER_2):GetValue('RadarCategory_Mines')

					if GetRadarP1 > 0 or GetRadarP2 > 0 then
						self:visible(true):cropleft(0):cropright(0)
						if GetRadarP1 == 0 and GetRadarP2 > 0 then
							self:cropleft(0.5)
						elseif GetRadarP1 > 0 and GetRadarP2 == 0 then
							self:cropright(0.5)
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

	CurrentSongChangedMessageCommand=function(self) self:queuecommand("Set") end;
	CurrentCourseChangedMessageCommand=function(self) self:queuecommand("Set") end;
	CurrentTrailP1ChangedMessageCommand=function(self) self:queuecommand("Set") end;
	CurrentTrailP2ChangedMessageCommand=function(self) self:queuecommand("Set") end;
};

return t;