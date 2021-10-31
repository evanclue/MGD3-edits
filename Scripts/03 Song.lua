function IsSongLife(songtit)

--Life challenge songs
local SongTable = {
	["The Seven Gates"] = true,
	["Cubed"] = true,
	["Happiness"] = true,
	["Relation"] = true,
	["Another Run"] = true,
	["Floridian Love Scene"] = true,
	["Freak Empire"] = true,
	["Rotterdom Nation 94.5"] = true,
	["Something Dreamy"] = true,
	["The Moon Breaks My Day"] = true
}

local SongVal = SongTable[songtit] or false
return SongVal;

end;

function IsSongEx(songtit)

--Ex stage songs
local SongTable = {
	["1995 EX"] = true,
	["I Love You Baby EX"] = true,
	["Killing Fields EX"] = true,
	["More Like You EX"] = true,
	["Rapture EX"] = true,
	["Infinite Blue EX"] = true,
	["All or Something EX"] = true,
	["Empire of the Sun EX"] = true,
	["Taito No Suika EX"] = true,
	["Mermaid EX"] = true,
	["Feel the Soul EX"] = true,
	["Machucando EX"] = true,
	["Freak on a Leash EX"] = true,
	["Lockjaw EX"] = true,
	["Love is More EX"] = true,
	["Concept of Love (Concept of Passion Mix) EX"] = true,
	["Amber Starlight EX"] = true
}

local SongVal = SongTable[songtit] or false
return SongVal;

end;

function IsSongBoss(songtit)

--Life challenge songs
local SongTable = {
	["Chaos Theory"] = true,
	["V^3"] = true,
	["Inkey$"] = true,
	["Lawn Wake IV"] = true,
	["Passage d"] = true,
	["Destination Helios"] = true,
	["Dis"] = true,
	["Due In One Hour"] = true,
	["Killing Fields"] = true,
	["Please EX."] = true,
	["Speak Sins"] = true,
	["The Daeva Suite"] = true,
	["Under Angel Wings"] = true,
	["Lune Noir"] = true,
	["Lune Noir EX"] = true,
	["Stratosphere"] = true,
	["Midnight Runner"] = true,
	["Pwnage U N00bs EX"] = true,
	["Contact"] = true,
	["Destination Unknown"] = true,
	["Destination of the Heart"] = true,
	["The Daeva Suite"] = true,
	["Boss Rush"] = true,
	["Speed Strike"] = true,
	["Reasons to Live"] = true
}

local SongVal = SongTable[songtit] or false
return SongVal;

end;

function IsSongDash(songtit)

--Dash song
local SongTable = {
	["Dash Hopes II"] = true,
	["Bag"] = true
}

local SongVal = SongTable[songtit] or false
return SongVal;

end;

function IsSongNonstop(songtit)

--Life challenge songs
local SongTable = {
	["The Seven Gates"] = true,
	["Cubed"] = true,
	["Happiness"] = true,
	["Relation"] = true,
}

local SongVal = SongTable[songtit] or false
return SongVal;

end;

function IsSongRemix(songtit)

--Life challenge songs
local SongTable = {
	["Another Run"] = true,
	["Floridian Love Scene"] = true,
	["Freak Empire"] = true,
	["Rotterdom Nation 94.5"] = true,
	["Something Dreamy"] = true,
	["The Moon Breaks My Day"] = true
}

local SongVal = SongTable[songtit] or false
return SongVal;

end;

function CalcDifficulty(Steps)
	local stepCounter = Steps:GetRadarValues(GAMESTATE:GetMasterPlayerNumber()):GetValue('RadarCategory_TapsAndHolds')
	local jumpCounter = Steps:GetRadarValues(GAMESTATE:GetMasterPlayerNumber()):GetValue('RadarCategory_Jumps')
	local handCounter = Steps:GetRadarValues(GAMESTATE:GetMasterPlayerNumber()):GetValue('RadarCategory_Hands') * 2
	local songInSeconds = 0
	local song = GAMESTATE:GetCurrentSong();
	local course = GAMESTATE:GetCurrentCourse();

	if song then
		songInSeconds = song:GetLastSecond() - song:GetFirstSecond()

		local mods = GAMESTATE:GetSongOptionsObject("ModsLevel_Song")
		local rate = mods:MusicRate()
		songInSeconds = songInSeconds / rate
	elseif course then
		--[[
		for entry in ivalues(course:GetCourseEntries()) do
			local firstsecond = entry:GetSong():GetFirstSecond()
			local lastsecond = entry:GetSong():GetLastSecond()
			songInSeconds = songInSeconds + (lastsecond - firstsecond)
		end
		]]--
		songInSeconds = TrailUtil.GetTotalSeconds(Steps);
	end

    return math.round( ( (stepCounter + jumpCounter + handCounter) / songInSeconds ) * 20 )
end;
