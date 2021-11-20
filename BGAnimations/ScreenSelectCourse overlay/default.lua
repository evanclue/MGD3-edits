local t = Def.ActorFrame {};
local file1 = "selmnormal course.png";
local file2 = "../ScreenSelectMusic overlay/selmnormal folder.png";

if IsUsingWideScreen() == true then
	file1 = "selmwide course.png";
	file2 = "../ScreenSelectMusic overlay/selmwide folder.png";
end

t[#t+1] = Def.ActorFrame {
	InitCommand=function(self) cc = self:GetChildren(); end;
	LoadActor( "tile" )..{
		OnCommand=function(self) self:blend('BlendMode_Add'):diffusealpha(0.2) end;
	};
	LoadActor(file1)..{
		Name="BG1";
		InitCommand=function(self) self:Center() end;
	};
	LoadActor(file2)..{
		Name="BG2";
		InitCommand=function(self) self:Center() end;
	};
	LoadActor("../ScreenSelectMusic overlay/difflist")..{
		InitCommand=function(self) self:Center():addx(40):addy(-140) end;
	};
	LoadActor("../ScreenSelectMusic overlay/scoring")..{
		InitCommand=function(self) self:Center():addx(180):addy(-117) end;
	};
	LoadActor("data")..{
		InitCommand=function(self) self:Center():addx(106):addy(-12) end;
	};
	LoadActor("accel");
	SetCommand=function(self)
		local course = GAMESTATE:GetCurrentCourse();
		if course then
			--Course
			cc.BG1:diffusealpha(1);
			cc.BG2:diffusealpha(0);
		else
			--Folder
			cc.BG1:diffusealpha(0);
			cc.BG2:diffusealpha(1);
		end;
	end;

	CurrentSongChangedMessageCommand=function(self) self:queuecommand("Set") end;
	CurrentCourseChangedMessageCommand=function(self) self:queuecommand("Set") end;
	CurrentTrailP1ChangedMessageCommand=function(self) self:queuecommand("Set") end;
	CurrentTrailP2ChangedMessageCommand=function(self) self:queuecommand("Set") end;
};

return t;