local t = Def.ActorFrame{}

for pn in ivalues(GAMESTATE:GetEnabledPlayers()) do
	local batLives = ThemePrefs.Get("DefLives")
	if batLives == -1 then
		batLives = GetLives(pn)
	end
	if GAMESTATE:IsCourseMode() then
		GAMESTATE:GetPlayerState(pn):GetPlayerOptions('ModsLevel_Stage'):BatteryLives(batLives)
		GAMESTATE:GetPlayerState(pn):GetPlayerOptions('ModsLevel_Stage'):AttackMines(true)
		GAMESTATE:GetPlayerState(pn):GetPlayerOptions('ModsLevel_Stage'):FailSetting('FailType_Immediate')
	else
		GAMESTATE:GetPlayerState(pn):GetPlayerOptions('ModsLevel_Preferred'):LifeSetting('LifeType_Battery')
		GAMESTATE:GetPlayerState(pn):GetPlayerOptions('ModsLevel_Preferred'):BatteryLives(batLives)
		GAMESTATE:GetPlayerState(pn):GetPlayerOptions('ModsLevel_Preferred'):AttackMines(true)
		GAMESTATE:GetPlayerState(pn):GetPlayerOptions('ModsLevel_Preferred'):FailSetting('FailType_Immediate')
	end
end

if GAMESTATE:IsCourseMode() then
	t[#t+1] = Def.ActorFrame {
		LoadActor("course")
	}
else
	local Song = GAMESTATE:GetCurrentSong()
	local SongTit = Song:GetDisplayMainTitle()
	if SongTit == "I'm an Idiot" then
		t[#t+1] = Def.ActorFrame {
			LoadActor("windeu")
		}
	elseif SongTit == "What Do You Really Want" or SongTit == "What Do You Really Want EX" then
		t[#t+1] = Def.ActorFrame {
			LoadActor("crash")
		}
	elseif IsSongBoss(SongTit) then
		t[#t+1] = Def.ActorFrame {
			LoadActor("boss")
		}
	elseif IsSongEx(SongTit) then
		t[#t+1] = Def.ActorFrame {
			LoadActor("ex")
		}
	elseif IsSongDash(SongTit) then
		t[#t+1] = Def.ActorFrame {
			LoadActor("dash")
		}
	elseif IsSongNonstop(SongTit) then
		t[#t+1] = Def.ActorFrame {
			LoadActor("nonstop")
		}
	elseif IsSongRemix(SongTit) then
		t[#t+1] = Def.ActorFrame {
			LoadActor("remix")
		}
	else
		t[#t+1] = Def.ActorFrame {
			LoadActor( "normal" )..{
				OnCommand=function(self) self:play() end
			}
		}
	end
end

return t