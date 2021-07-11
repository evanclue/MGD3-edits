local t = Def.ActorFrame{};
local Center1Player = PREFSMAN:GetPreference('Center1Player');
local NumPlayers = GAMESTATE:GetNumPlayersEnabled();
local NumSides = GAMESTATE:GetNumSidesJoined();
local st = GAMESTATE:GetCurrentStyle():GetStepsType();
local Song = GAMESTATE:GetCurrentSong();

local function GetPosition(pn)
	if st == "StepsType_Dance_Solo" then
		if Center1Player then
			return SCREEN_WIDTH/2;
		elseif pn == PLAYER_1 then
			return SCREEN_WIDTH/4;
		elseif pn == PLAYER_2 then
			return SCREEN_WIDTH/4*3;
		end;
	elseif st == "StepsType_Dance_Double" then
		if pn == PLAYER_1 then
			return SCREEN_WIDTH/4;
		elseif pn == PLAYER_2 then
			return SCREEN_WIDTH/4*3;
		end;
	else
		local strPlayer = (NumPlayers == 1) and "OnePlayer" or "TwoPlayers";
		local strSide = (NumSides == 1) and "OneSide" or "TwoSides";
		return THEME:GetMetric("ScreenGameplay","Player".. ToEnumShortString(pn) .. strPlayer .. strSide .."X");
	end;
end;

if Song then
	if GAMESTATE:PlayerIsUsingModifier(PLAYER_1,'StaticBG') or GAMESTATE:PlayerIsUsingModifier(PLAYER_2,'StaticBG') or Song:HasBGChanges() then
	else
		t[#t+1] = Def.ActorFrame {
			Def.Sprite{
				BeginCommand=function(self) self:scale_or_crop_background() end;
				InitCommand=function(self)
					if Song then
						if Song:HasBackground() then
								self:LoadBackground(Song:GetBackgroundPath());
							else
								self:Load(THEME:GetPathG("Common fallback", "background"));
						end;
					end;
				end;
				OnCommand=function(self) self:diffusealpha(0.5) end;
			};
		};
	end;
end;

local moved = (GAMESTATE:GetNumPlayersEnabled() == 1) and true or false;
local centered = (GAMESTATE:GetNumPlayersEnabled() == 1) and true or false;

for player in ivalues(GAMESTATE:GetHumanPlayers()) do
	t[#t+1] = LoadActor("playerfilter")..{
		InitCommand=function(self)
			self:x(GetPosition(player));
			self:CenterY();
		end;
		HealthStateChangedMessageCommand=function(self, param)
			if param.HealthState == 'HealthState_Dead' then --If player dies
				if param.PlayerNumber == PLAYER_1 and player == PLAYER_1 and not moved then --Move P1's filter if P1 dies
					self:linear(0.5):x(SCREEN_LEFT-SCREEN_WIDTH);
					moved = true;
				elseif param.PlayerNumber == PLAYER_2 and player == PLAYER_2 and not moved then --Move P2's filter if P2 dies
					self:linear(0.5):x(SCREEN_RIGHT+SCREEN_WIDTH);
					moved = true;
				elseif param.PlayerNumber == PLAYER_1 and player == PLAYER_2 and not centered then --Move P1's filter to center if P2 dies
					self:linear(0.5):CenterX();
					centered = true;
				elseif param.PlayerNumber == PLAYER_2 and player == PLAYER_1 and not centered then --Move P2's filter to center if P1 dies
					self:linear(0.5):CenterX();
					centered = true;
				end
			end
		end
	}
end

return t;