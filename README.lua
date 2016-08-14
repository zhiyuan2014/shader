	self.hpBar = Helper:seekWidgetByName(self,"hpbar")
	local sprite = cc.Sprite:createWithSpriteFrame(self.hpBar:getVirtualRenderer():getSprite():getSpriteFrame())
	GUI.setProgramForSprite(sprite,GUI.PROGRAM_KEYS.GRAY)
	sprite:setAnchorPoint(self.hpBar:getAnchorPoint())
	sprite:setPosition(self.hpBar:getPositionX(), self.hpBar:getPositionY())
	sprite:setLocalZOrder(self.hpBar:getLocalZOrder()+1)
	sprite:setVisible(false)
	self.hpBar:getParent():addChild(sprite)
	self.grayHpBar = sprite

