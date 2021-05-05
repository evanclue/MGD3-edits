local player = Var "Player"
local curLives = 0;

local t = Def.ActorFrame{
	LoadFont("Combo numbers")..{
		BeginCommand=function(self)
			local screen = SCREENMAN:GetTopScreen();
			local glifemeter = screen:GetLifeMeter(player);
			if glifemeter:GetTotalLives() <= 5 then
				self:diffuseshift();
				self:effectcolor1(1,1,1,1);
				self:effectcolor2(1,0,0,1);
			end;
			curLives = glifemeter:GetTotalLives()
			self:settext(glifemeter:GetTotalLives());
			self:zoom(0.6);
			self:horizalign(center);
		end;
		LifeChangedMessageCommand=function(self,params)
			if params.Player == player then
				if curLives ~= params.LivesLeft then
					curLives = params.LivesLeft;
					self:stoptweening();
					self:settext(params.LivesLeft);
					if params.LivesLeft <= 5 then
						self:diffuseshift();
						self:effectcolor1(1,1,1,1);
						self:effectcolor2(1,0,0,1);
					else
						self:stopeffect();
					end;
					self:zoom(0.75);
					self:linear(0.1);
					self:zoom(0.6);
				end;
			end;
		end;
	};
};

return t;