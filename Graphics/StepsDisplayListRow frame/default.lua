local t = Def.ActorFrame{};

local CustomDifficultyToState = {
	Beginner	= "EASY",
	Easy		= "MED",
	Medium		= "HARD",
	Hard		= "PRO",
	Challenge	= "INSANE",
	Edit		= "ANOTHER",
};

t[#t+1] = Def.ActorFrame{
	LoadFont("Panedisplay Text")..{
		Name="tmeter";
		InitCommand=function(self)
			self:horizalign(center):zoom(0.36)
			if #GAMESTATE:GetHumanPlayers()==2 then
				self:x(26):maxwidth(110)
			else
				self:x(31.5)
			end;
		end;
		PlayerJoinedMessageCommand=function(self, params) self:queuecommand("Init") end,
		PlayerUnjoinedMessageCommand=function(self, params) self:queuecommand("Init") end,
	};

	LoadFont("Panedisplay Text")..{
		Name="dname";
		InitCommand=function(self) self:x(-68):horizalign(left):zoom(0.36):maxwidth(170) end;
	};

	SetCommand=function(self, param)
		local tmeter = self:GetChild('tmeter');
		local dname = self:GetChild('dname');
		local song = GAMESTATE:GetCurrentSong();
		local step;
		local meter;
		local cdiff;
		self:stoptweening();
		dname:visible(false);
		tmeter:visible(false);
		if song then
			if param then
				step = param.Steps;
				meter = param.Meter;
				cdiff = param.CustomDifficulty;
				dname:visible(true);
				dname:settext(CustomDifficultyToState[cdiff]);
				if cdiff == "Challenge" then
					dname:diffuse(Color("Red"));
					tmeter:diffuse(Color("Red"));
				else
					dname:diffuse(Color("White"));
					tmeter:diffuse(Color("White"));
				end;
			end;

			if song and cdiff then
				if cdiff ~= "Edit" then
					if ThemePrefs.Get("DefDifficulties") then
						meter = CalcDifficulty(song:GetOneSteps(0,"Difficulty_" .. cdiff));
					else
						meter = GetConvertDifficulty(song,"Difficulty_"..cdiff);
					end
				else
					if ThemePrefs.Get("DefDifficulties") then
						meter = CalcDifficulty(song:GetOneSteps(0,"Difficulty_Edit"));
					else
						meter = GetConvertDifficulty(song,"Difficulty_Edit",step);
					end
				end;
			end;

			song = "";

			if meter then
				tmeter:visible(true);
				tmeter:settextf("%d",meter);
			end;
		end;
	end;
	PlayerJoinedMessageCommand=function(self) self:queuecommand("Set") end;
	PlayerUnjoinedMessageCommand=function(self) self:queuecommand("Set") end;
};

return t;