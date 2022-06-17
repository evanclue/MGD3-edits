local SpeedMods = {"0.5x", "1x", "1.5x", "2x", "2.5x", "3x", "3.5x", "4x", "4.5x", "5x", "5.5x", "6x"}
local sIdx = 2
local sMax = #SpeedMods
local invert = ThemePrefs.Get("InvertAccel") and -1 or 1
local t = Def.ActorFrame {}

local questionMark = ""
local noteskin = GAMESTATE:GetPlayerState(PLAYER_1):GetPlayerOptions("ModsLevel_Preferred"):NoteSkin()

for pn in ivalues(GAMESTATE:GetEnabledPlayers()) do
	if GAMESTATE:GetPlayerState(pn):GetPlayerOptions("ModsLevel_Preferred"):ScrollSpeed() then
		sIdx = GAMESTATE:GetPlayerState(pn):GetPlayerOptions("ModsLevel_Preferred"):ScrollSpeed() * 2
	end
end

function DoesCourseHasX()
	local course = GAMESTATE:GetCurrentCourse()
		if course then
		local file = course:GetCourseDir()
		local f=OpenFile(file)
		if f then
			--get all #MODS:
			local opt=GetFileParameter(f,"mods")
			--check if X is set
			if string.find(opt,"[0-9]?[.]*[0-9]*[0-9]x") then
				questionMark = "?"
			else
				questionMark = ""
			end
			CloseFile(f)
		end
	end
end

function OpenFile(filePath)
	if not FILEMAN:DoesFileExist(filePath) then
		return nil
	end
	local f=RageFileUtil.CreateRageFile()
	f:Open(filePath,1)
	return f
end

function CloseFile(f)
	if f then
		f:Close()
		f:destroy()
		return true
	else
		return false
	end
end

function GetFileParameter(f,prm)
	if not f then
		return ""
	end
	f:Seek(0)
	local gl=""
	local pl=string.lower(prm)
	local l
	while true do
		l=f:GetLine()
		local ll=string.lower(l)
		if string.find(ll,"#notes:.*") or f:AtEOF() then
			break
		elseif (string.find(ll,"^.*#"..pl..":.*") and (not string.find(ll,"^%/%/.*"))) or gl~="" then
			gl=gl..""..split("//",l)[1]
		end
	end
	return gl
end

t[#t+1] = Def.ActorFrame {
	OnCommand=function()
		--force apply both on start since they aren't applied on unchanged (re)start
		GAMESTATE:ApplyGameCommand('mod,'..SpeedMods[sIdx])
		GAMESTATE:ApplyGameCommand('mod,'..noteskin)
	end;
	CodeMessageCommand = function(self, params)
		if params.Name == 'SpeedUp' then
			sIdx = sIdx - (1 * invert)
			if sIdx < 1 then
				sIdx = sMax
			elseif sIdx > sMax then
				sIdx = 1
			end
			GAMESTATE:ApplyGameCommand('mod,'..SpeedMods[sIdx])
			self:playcommand("Speed");
		elseif params.Name == 'SpeedDown' then
			sIdx = sIdx + (1 * invert)
			if sIdx > sMax then
				sIdx = 1
			elseif sIdx < 1 then
				sIdx = sMax
			end
			GAMESTATE:ApplyGameCommand('mod,'..SpeedMods[sIdx])
			self:playcommand("Speed")
		end
	end;
	LoadActor(THEME:GetPathS("ScreenSelectMusic","options"))..{
		OnCommand=function(self) self:stop() end;
		SpeedCommand=function(self) self:play() end;
	};
	LoadFont("OptionIcon")..{
		OnCommand=function(self)
			DoesCourseHasX()
			self:x(SCREEN_CENTER_X+100):y(SCREEN_BOTTOM-50):settext(string.upper(SpeedMods[sIdx])..questionMark):diffuse(color('#BEC1C6')):zoom(0.76)
		end;
		SpeedCommand=function(self)
			self:settext(string.upper(SpeedMods[sIdx])..questionMark)
		end;
		CurrentCourseChangedMessageCommand=function(self)
			DoesCourseHasX()
			self:settext(string.upper(SpeedMods[sIdx])..questionMark)
		end;
	}
}

return t