--[[

 Bismillahirrahmanirrahim
 
 Bitmap Button Class
 by: Edwin Zaniar Putra (zaniar@nightspade.com)
 Version: 2012.11.0

 This code is MIT licensed, see http://www.opensource.org/licenses/mit-license.php
 Copyright © 2012 Nightspade (http://nightspade.com)
 
--]]

BitmapButton = gideros.class(Bitmap)

function BitmapButton:init(upTexture, downTexture)
	self.upTexture = upTexture
	self.downTexture = downTexture
	
	self.focus = false

	if self.toggle then
		if self.down then
			self:setTextureRegion(self.downTexture)
		end
	end

	self:addEventListener(Event.MOUSE_DOWN, self.onMouseDown, self)
	self:addEventListener(Event.MOUSE_MOVE, self.onMouseMove, self)
	self:addEventListener(Event.MOUSE_UP, self.onMouseUp, self)

	self:addEventListener(Event.TOUCHES_BEGIN, self.onTouchesBegin, self)
	self:addEventListener(Event.TOUCHES_MOVE, self.onTouchesMove, self)
	self:addEventListener(Event.TOUCHES_END, self.onTouchesEnd, self)
	self:addEventListener(Event.TOUCHES_CANCEL, self.onTouchesCancel, self)
end

function BitmapButton:onMouseDown(event)
	if self:hitTestPoint(event.x, event.y) then
		self.focus = true
		self:setTextureRegion(self.downTexture)
		self:dispatchEvent(Event.new("press"))
		event:stopPropagation()
	end
end

function BitmapButton:onMouseMove(event)
	if self.focus then
		if not self:hitTestPoint(event.x, event.y) then
			self.focus = false;
			self:setTextureRegion(self.upTexture)
			self:dispatchEvent(Event.new("leave"))
		end
		event:stopPropagation()
	end
end

function BitmapButton:onMouseUp(event)
	if self.focus then
		self.focus = false;
		if self.sfx then
			audio:sfxPlay(self.sfx)
		end
		self:setTextureRegion(self.upTexture)
		self:dispatchEvent(Event.new("click"))
		event:stopPropagation()
	end
end

-- if button is on focus, stop propagation of touch events
function BitmapButton:onTouchesBegin(event)
	if self.focus then
		event:stopPropagation()
	end
end

-- if button is on focus, stop propagation of touch events
function BitmapButton:onTouchesMove(event)
	if self.focus then
		event:stopPropagation()
	end
end

-- if button is on focus, stop propagation of touch events
function BitmapButton:onTouchesEnd(event)
	if self.focus then
		event:stopPropagation()
	end
end

-- if touches are cancelled, reset the state of the button
function BitmapButton:onTouchesCancel(event)
	if self.focus then
		self.focus = false;
		self:setTextureRegion(self.upTexture)
		event:stopPropagation()
	end
end