local player = ...
assert( player )

return Def.BitmapText{
	Font="Combo numbers",
	Name="SurvivalTime",
	Text="0:00:00",
	InitCommand=function(self)
		self:horizalign(center):zoom(0.6)
		self:x( _screen.cx ):y(20)

		self:shadowlength(1)
		self:settext(SecondsToMSSMsMs( STATSMAN:GetCurStageStats():GetPlayerStageStats( player ):GetLifeRemainingSeconds() ))
		self:queuecommand('Update')
	end,
	OnCommand=function(self) self:addy(-100):sleep(0.5):decelerate(0.8):addy(100) end,
	OffCommand=function(self) self:accelerate(0.8):addy(-100) end,
	UpdateCommand=function(self)
		local sec = STATSMAN:GetCurStageStats():GetPlayerStageStats( player ):GetLifeRemainingSeconds()
		local hex = string.format("%02x", sec * 255 / 15)
		if sec < 15 then
			self:diffuse(color("#FF"..hex..hex))
		else
			self:diffuse(color("#FFFFFF"))
		end
		self:settext(SecondsToMSSMsMs( STATSMAN:GetCurStageStats():GetPlayerStageStats( player ):GetLifeRemainingSeconds() ))
		self:sleep(0.01666)
		self:queuecommand('Update')
	end
}