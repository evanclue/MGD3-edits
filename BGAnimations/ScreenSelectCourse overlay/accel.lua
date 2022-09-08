local SpeedMods = {"0.5x", "1x", "1.5x", "2x", "2.5x", "3x", "3.5x", "4x", "4.5x", "5x", "5.5x", "6x"}
local sIdx = 2
local sMax = #SpeedMods
local invert = ThemePrefs.Get("InvertAccel") and -1 or 1

local questionMark = ""
local noteskin = GAMESTATE:GetPlayerState(PLAYER_1):GetPlayerOptions("ModsLevel_Preferred"):NoteSkin()

for pn in ivalues(GAMESTATE:GetEnabledPlayers()) do
	if GAMESTATE:GetPlayerState(pn):GetPlayerOptions("ModsLevel_Preferred"):ScrollSpeed() then
		sIdx = GAMESTATE:GetPlayerState(pn):GetPlayerOptions("ModsLevel_Preferred"):ScrollSpeed() * 2
	end
end

function DoesCourseHasX()
	local course = GAMESTATE:GetCurrentCourse()
	local filePath = course:GetCourseDir()
	local file = RageFileUtil.CreateRageFile()
	file:Open(filePath,1)
	file:Seek(0)
	local gLine = ""
	local line
	while true do
		line=file:GetLine()
		if string.find(line,"#NOTES:.*") or file:AtEOF() then break
		elseif (string.find(line,"^.*#MOD:.*") and (not string.find(line,"^%/%/.*"))) or gLine~="" then
			gLine=gLine..""..split("//",line)[1]
		end
	end
	if string.find(gLine,"[0-9]?[.]*[0-9]*[0-9]x") then questionMark = "?" else questionMark = "" end
	file:Close()
	file:destroy()
end

return Def.ActorFrame {
	Def.ActorFrame {
		OnCommand=function()
			GAMESTATE:ApplyGameCommand('mod,'..SpeedMods[sIdx])
			GAMESTATE:ApplyGameCommand('mod,'..noteskin)
		end,
		CodeMessageCommand = function(self, params)
			if params.Name == 'SpeedUp' then
				sIdx = sIdx - (1 * invert)
				if sIdx < 1 then sIdx = sMax elseif sIdx > sMax then sIdx = 1 end
				GAMESTATE:ApplyGameCommand('mod,'..SpeedMods[sIdx])
				self:playcommand("Speed")
			elseif params.Name == 'SpeedDown' then
				sIdx = sIdx + (1 * invert)
				if sIdx > sMax then sIdx = 1 elseif sIdx < 1 then sIdx = sMax end
				GAMESTATE:ApplyGameCommand('mod,'..SpeedMods[sIdx])
				self:playcommand("Speed")
			end
		end,
		LoadActor(THEME:GetPathS("ScreenSelectMusic","options"))..{
			OnCommand=function(self) self:stop() end,
			SpeedCommand=function(self) self:play() end
		},
		LoadFont("OptionIcon")..{
			OnCommand=function(self)
				DoesCourseHasX()
				self:x(SCREEN_CENTER_X+100):y(SCREEN_BOTTOM-50):settext(string.upper(SpeedMods[sIdx])..questionMark):diffuse(color('#BEC1C6')):zoom(0.76)
			end,
			SpeedCommand=function(self)
				self:settext(string.upper(SpeedMods[sIdx])..questionMark)
			end,
			CurrentCourseChangedMessageCommand=function(self)
				DoesCourseHasX()
				self:settext(string.upper(SpeedMods[sIdx])..questionMark)
			end
		}
	}
}