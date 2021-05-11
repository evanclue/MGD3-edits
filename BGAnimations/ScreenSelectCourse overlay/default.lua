local t = Def.ActorFrame {};
local file = "selcnormal";

if IsUsingWideScreen() == true then
	file = "selcwide";
end

t[#t+1] = Def.ActorFrame {
	LoadActor( "tile" )..{
		OnCommand=function(self) self:blend('BlendMode_Add'):diffusealpha(0.2) end;
	};
	LoadActor(file)..{
		InitCommand=function(self) self:Center() end;
	};
	LoadActor("data")..{
		InitCommand=function(self) self:Center():addx(106):addy(-12) end;
	};
	LoadActor("accel");
};

return t;