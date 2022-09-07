local mPlayer = GAMESTATE:GetMasterPlayerNumber()

local steps,stepsP1,stepsP2 = 0,0,0
local fakes,fakesP1,fakesP2 = 0,0,0
local jumps,jumpsP1,jumpsP2 = 0,0,0
local hands,handsP1,handsP2 = 0,0,0
local holds,holdsP1,holdsP2 = 0,0,0
local rolls,rollsP1,rollsP2 = 0,0,0
local lifts,liftsP1,liftsP2 = 0,0,0
local mines,minesP1,minesP2 = 0,0,0

return Def.ActorFrame {
	Def.ActorFrame {
		InitCommand=function(self) c = self:GetChildren() end,
		LoadFont("MusicList titles")..{
			Name="Title",
			InitCommand=function(self) self:horizalign(left):zoom(0.82):x(-134):y(2) end
		},
		LoadFont("MusicList titles")..{
			Name="Artist",
			InitCommand=function(self) self:horizalign(left):zoom(0.82):x(-134):y(24) end
		},
		LoadFont("ScreenSelectMusic total time")..{
			Name="Time",
			InitCommand=function(self) self:horizalign(center):y(88):x(69) end
		},
		LoadFont("ScreenSelectMusic total time")..{
			Name="TrueTime",
			InitCommand=function(self) self:horizalign(center):y(88):x(69) end
		},
		SetCommand=function(self)
			if GAMESTATE:IsCourseMode() then
				local trail = GAMESTATE:GetCurrentTrail(mPlayer)
				steps, fakes, jumps, hands, holds, rolls, lifts, mines = 0,0,0,0,0,0,0,0
				if trail then
					if GAMESTATE:GetNumPlayersEnabled() == 1 then
						for entry in ivalues(trail:GetTrailEntries()) do
							steps = steps + entry:GetSteps():GetRadarValues(mPlayer):GetValue('RadarCategory_TapsAndHolds')
							fakes = fakes + entry:GetSteps():GetRadarValues(mPlayer):GetValue('RadarCategory_Fakes')
							jumps = jumps + entry:GetSteps():GetRadarValues(mPlayer):GetValue('RadarCategory_Jumps')
							hands = hands + entry:GetSteps():GetRadarValues(mPlayer):GetValue('RadarCategory_Hands')
							holds = holds + entry:GetSteps():GetRadarValues(mPlayer):GetValue('RadarCategory_Holds')
							rolls = rolls + entry:GetSteps():GetRadarValues(mPlayer):GetValue('RadarCategory_Rolls')
							lifts = lifts + entry:GetSteps():GetRadarValues(mPlayer):GetValue('RadarCategory_Lifts')
							mines = mines + entry:GetSteps():GetRadarValues(mPlayer):GetValue('RadarCategory_Mines')
						end
					else
						stepsP1, fakesP1, jumpsP1, handsP1, holdsP1, rollsP1, liftsP1, minesP1 = 0,0,0,0,0,0,0,0
						stepsP2, fakesP2, jumpsP2, handsP2, holdsP2, rollsP2, liftsP2, minesP2 = 0,0,0,0,0,0,0,0
						for entry in ivalues(trail:GetTrailEntries()) do
							stepsP1 = stepsP1 + entry:GetSteps():GetRadarValues(PLAYER_1):GetValue('RadarCategory_TapsAndHolds')
							fakesP1 = fakesP1 + entry:GetSteps():GetRadarValues(PLAYER_1):GetValue('RadarCategory_Fakes')
							jumpsP1 = jumpsP1 + entry:GetSteps():GetRadarValues(PLAYER_1):GetValue('RadarCategory_Jumps')
							handsP1 = handsP1 + entry:GetSteps():GetRadarValues(PLAYER_1):GetValue('RadarCategory_Hands')
							holdsP1 = holdsP1 + entry:GetSteps():GetRadarValues(PLAYER_1):GetValue('RadarCategory_Holds')
							rollsP1 = rollsP1 + entry:GetSteps():GetRadarValues(PLAYER_1):GetValue('RadarCategory_Rolls')
							liftsP1 = liftsP1 + entry:GetSteps():GetRadarValues(PLAYER_1):GetValue('RadarCategory_Lifts')
							minesP1 = minesP1 + entry:GetSteps():GetRadarValues(PLAYER_1):GetValue('RadarCategory_Mines')
							stepsP2 = stepsP2 + entry:GetSteps():GetRadarValues(PLAYER_2):GetValue('RadarCategory_TapsAndHolds')
							fakesP2 = fakesP2 + entry:GetSteps():GetRadarValues(PLAYER_2):GetValue('RadarCategory_Fakes')
							jumpsP2 = jumpsP2 + entry:GetSteps():GetRadarValues(PLAYER_2):GetValue('RadarCategory_Jumps')
							handsP2 = handsP2 + entry:GetSteps():GetRadarValues(PLAYER_2):GetValue('RadarCategory_Hands')
							holdsP2 = holdsP2 + entry:GetSteps():GetRadarValues(PLAYER_2):GetValue('RadarCategory_Holds')
							rollsP2 = rollsP2 + entry:GetSteps():GetRadarValues(PLAYER_2):GetValue('RadarCategory_Rolls')
							liftsP2 = liftsP2 + entry:GetSteps():GetRadarValues(PLAYER_2):GetValue('RadarCategory_Lifts')
							minesP2 = minesP2 + entry:GetSteps():GetRadarValues(PLAYER_2):GetValue('RadarCategory_Mines')
						end
					end
					local course = GAMESTATE:GetCurrentCourse()
					local title = course:GetDisplayFullTitle()
					c.Title:maxwidth(325)
					c.Title:settext(title)

					local artist = course:GetScripter()
					c.Artist:maxwidth(325)
					c.Artist:settext("Programmed by "..artist)

					local entries = course:GetCourseEntries()
					local seconds, trueseconds = 0, 0

					for entry in ivalues(course:GetCourseEntries()) do
						if entry:GetSong() then
							seconds = seconds + entry:GetSong():MusicLengthSeconds()
							local firstsecond = entry:GetSong():GetFirstSecond()
							local lastsecond = entry:GetSong():GetLastSecond()
							trueseconds = trueseconds + (lastsecond - firstsecond)
						end
					end

					c.Artist:diffusealpha(1)
					c.Time:maxwidth(128):diffusealpha(1):settext(SecondsToMMSSMsMs(seconds))
					c.Time:effectclock('timer'):diffuseshift():effectcolor1(color("#FFFFFFFF")):effectcolor2(color("#00000000")):effectperiod(4)
					c.TrueTime:maxwidth(128):diffusealpha(1):settext(SecondsToMMSSMsMs(trueseconds))
					c.TrueTime:effectclock('timer'):diffuseshift():effectcolor1(color("#00000000")):effectcolor2(color("#FFFFFFFF")):effectperiod(4)

					c.Title:diffusealpha(1)
					c.Artist:diffusealpha(1)
				end
			else
				c.Title:diffusealpha(0)
				c.Artist:diffusealpha(0)
				c.Time:diffusealpha(0)
				c.TrueTime:diffusealpha(0)
			end
		end,
		Def.BPMDisplay {
			File=THEME:GetPathF("BPM", "Display"),
			Name="BPMDisplay",
			InitCommand=function(self) self:x(5):y(133):horizalign(left):zoom(0.62):maxwidth(210) end,
			SetCommand=function(self) self:SetFromGameState() end
		},
		LoadFont("Panedisplay Blurred")..{
			InitCommand=function(self) self:zoom(0.35):horizalign(left):y(69):x(-132):maxwidth(160):diffusealpha(0.6):zoomx(0.37) end,
			SetCommand=function(self)
				local name = "STEPS"
				local trail = GAMESTATE:GetCurrentTrail(mPlayer)
				if trail then
					if GAMESTATE:GetNumPlayersEnabled() == 1 then
						if fakes > 0 then name = name .. "?" end
					else
						if fakesP1 > 0 or fakesP2 > 0 then name = name .. "?" end
					end
				end
				self:settext(name)
			end
		},
		LoadFont("Panedisplay Blurred")..{
			InitCommand=function(self) self:zoom(0.35):horizalign(left):y(90):x(-132):maxwidth(160):diffusealpha(0.6) end,
			SetCommand=function(self)
				self:settext("JUMPS")
			end
		},
		LoadFont("Panedisplay Blurred")..{
			InitCommand=function(self) self:zoom(0.35):horizalign(left):y(111):x(-132):maxwidth(160):diffusealpha(0.6) end,
			SetCommand=function(self)
				self:settext("HANDS")
			end
		},
		LoadFont("Panedisplay Blurred")..{
			InitCommand=function(self) self:zoom(0.35):horizalign(left):y(132):x(-132):maxwidth(160):diffusealpha(0.6) end,
			SetCommand=function(self)
				local name = "HOLDS"
				local trail = GAMESTATE:GetCurrentTrail(mPlayer)
				if trail then
					if GAMESTATE:GetNumPlayersEnabled() == 1 then
						if rolls > 0 then name = name .. "+ROLLS" end
						if lifts > 0 then name = name .. "+LIFTS" end
					else
						if GetRadarP1:GetValue('RadarCategory_Rolls') > 0 or GetRadarP2:GetValue('RadarCategory_Rolls') > 0 then name = name .. "+ROLLS" end
						if GetRadarP1:GetValue('RadarCategory_Lifts') > 0 or GetRadarP2:GetValue('RadarCategory_Lifts') > 0 then name = name .. "+LIFTS" end
					end
				end
				self:settext(name)
			end
		},
		LoadFont("Panedisplay Blurred")..{
			InitCommand=function(self) self:zoom(0.35):horizalign(left):y(70):x(10):diffusealpha(0.6):zoomx(0.33) end,
			SetCommand=function(self)
				self:settext("S O N G   L E N G T H"):maxwidth(360)
				self:effectclock('timer'):diffuseshift():effectcolor1(color("#FFFFFFFF")):effectcolor2(color("#00000000")):effectperiod(4)
			end
		},
		LoadFont("Panedisplay Blurred")..{
			InitCommand=function(self) self:zoom(0.35):horizalign(left):y(70):x(10):diffusealpha(0.6):zoomx(0.33) end,
			SetCommand=function(self)
				self:settext("T R U E   L E N G T H"):maxwidth(360)
				self:effectclock('timer'):diffuseshift():effectcolor1(color("#00000000")):effectcolor2(color("#FFFFFFFF")):effectperiod(4)
			end
		},
		LoadFont("Panedisplay Blurred")..{
			InitCommand=function(self) self:zoom(0.35):horizalign(left):y(115):x(10):diffusealpha(0.6):zoomx(0.34) end,
			SetCommand=function(self)
				self:settext("B P M")
			end
		},
		LoadFont("Panedisplay Text")..{
			InitCommand=function(self) self:zoom(0.36):horizalign(right):y(70):x(-11):maxwidth(170) end,
			SetCommand=function(self)
				local name = ""
				local trail = GAMESTATE:GetCurrentTrail(mPlayer)
				if trail then
					if GAMESTATE:GetNumPlayersEnabled() == 1 then name = steps else name = stepsP1 .. " | " .. stepsP2 end
				end
				self:settext(name)
			end
		},
		LoadFont("Panedisplay Text")..{
			InitCommand=function(self) self:zoom(0.36):horizalign(right):y(91):x(-11):maxwidth(170) end,
			SetCommand=function(self)
				local name = ""
				local trail = GAMESTATE:GetCurrentTrail(mPlayer)
				if trail then
					if GAMESTATE:GetNumPlayersEnabled() == 1 then name = jumps else name = jumpsP1 .. " | " .. jumpsP2 end
				end
				self:settext(name)
			end
		},
		LoadFont("Panedisplay Text")..{
			InitCommand=function(self) self:zoom(0.36):horizalign(right):y(112):x(-11):maxwidth(170) end,
			SetCommand=function(self)
				local name = ""
				local trail = GAMESTATE:GetCurrentTrail(mPlayer)
				if trail then
					if GAMESTATE:GetNumPlayersEnabled() == 1 then name = hands else name = handsP1 .. " | " .. handsP2 end
				end
				self:settext(name)
			end
		},
		LoadFont("Panedisplay Text")..{
			InitCommand=function(self) self:zoom(0.36):horizalign(right):y(133):x(-11):maxwidth(170) end,
			SetCommand=function(self)
				local name = ""
				local trail = GAMESTATE:GetCurrentTrail(mPlayer)
				if trail then
					if GAMESTATE:GetNumPlayersEnabled() == 1 then
						name = holds
						if rolls > 0 then name = name .. "+" .. rolls end
						if lifts > 0 then name = name .. "+" .. lifts end
					else
						statsP1 = holdsP1
						statsP2 = holdsP2
						if rollsP1 > 0 or rollsP2 > 0 then
							statsP1 = statsP1 .. "+" .. rollsP1
							statsP2 = statsP2 .. "+" .. rollsP2
						end
						if liftsP1 > 0 or liftsP2 > 0 then
							statsP1 = statsP1 .. "+" .. liftsP1
							statsP2 = statsP2 .. "+" .. liftsP2
						end
						name = statsP1 .. " | " .. statsP2
					end
				end
				self:settext(name)
			end
		},
		Def.Sprite {
			Texture='../mine',
			Frames = Sprite.LinearFrames( 8, 1 ),
			InitCommand=function(self) self:effectclock('beat'):addx(180):addy(12):visible(false) end,
			SetCommand=function(self)
				local trail = GAMESTATE:GetCurrentTrail(mPlayer)
				if trail and trails ~=nil then
					if GAMESTATE:GetNumPlayersEnabled() == 1 then
						if mines > 0 then self:visible(true) else self:visible(false) end
					else
						if minesP1 > 0 or minesP2 > 0 then
							self:visible(true):cropleft(0):cropright(0)
							if minesP1 == 0 and minesP2 > 0 then
								self:cropleft(0.5)
							elseif minesP1 > 0 and minesP2 == 0 then
								self:cropright(0.5)
							end
						else
							self:visible(false)
						end
					end
				else
					self:visible(false)
				end
			end
		},
		CurrentSongChangedMessageCommand=function(self) self:queuecommand("Set") end,
		CurrentCourseChangedMessageCommand=function(self) self:queuecommand("Set") end,
		CurrentTrailP1ChangedMessageCommand=function(self) self:queuecommand("Set") end,
		CurrentTrailP2ChangedMessageCommand=function(self) self:queuecommand("Set") end
	}
}