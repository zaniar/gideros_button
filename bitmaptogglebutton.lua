--[[

 Bismillahirrahmanirrahim
 
 Multi-State Bitmap Button Class
 by: Edwin Zaniar Putra (zaniar@nightspade.com)
 Version: 2012.11.0

 This code is MIT licensed, see http://www.opensource.org/licenses/mit-license.php
 Copyright © 2012 Nightspade (http://nightspade.com)

--]]

BitmapToggleButton = gideros.class(Bitmap)

function BitmapToggleButton:init(texture, ...)
	self.textures = arg
	table.insert(self.textures, 1, texture)
	self.currentState = defaultState or 1
	
	self.focus = false

	self:setTextureRegion(self.textures[self.currentState])

	self:addEventListener(Event.MOUSE_DOWN, self.onMouseDown, self)
	self:addEventListener(Event.MOUSE_MOVE, self.onMouseMove, self)
	self:addEventListener(Event.MOUSE_UP, self.onMouseUp, self)

	self:addEventListener(Event.TOUCHES_BEGIN, self.onTouchesBegin, self)
	self:addEventListener(Event.TOUCHES_MOVE, self.onTouchesMove, self)
	self:addEventListener(Event.TOUCHES_END, self.onTouchesEnd, self)
	self:addEventListener(Event.TOUCHES_CANCEL, self.onTouchesCancel, self)
end

function BitmapToggleButton:onMouseDown(event)
	if self:hitTestPoint(event.x, event.y) then
		self.focus = true
		self.currentState = self.currentState + 1
		if self.currentState > #self.textures then
			self.currentState = 1
		end
		self:setTextureRegion(self.textures[self.currentState])
		self:dispatchEvent(Event.new("press"))
		event:stopPropagation()
	end
end

function BitmapToggleButton:onMouseMove(event)
	if self.focus then
		if not self:hitTestPoint(event.x, event.y) then
			self.focus = false;
			
			self.currentState = self.currentState - 1
			if self.currentState < 1 then
				self.currentState = #self.textures
			end
			self:setTextureRegion(self.textures[self.currentState])
			
			self:dispatchEvent(Event.new("leave"))
		end
		event:stopPropagation()
	end
end

function BitmapToggleButton:onMouseUp(event)
	if self.focus then
		if self:hitTestPoint(event.x, event.y) then
			self.focus = false;
			if self.sfx then
				audio:sfxPlay(self.sfx)
			end

			local toggleEvent = Event.new("toggle")
			toggleEvent.state = currentState
			self:dispatchEvent(toggleEvent)			
		end
		event:stopPropagation()
	end
end

-- if button is on focus, stop propagation of touch events
function BitmapToggleButton:onTouchesBegin(event)
	if self.focus then
		event:stopPropagation()
	end
end

-- if button is on focus, stop propagation of touch events
function BitmapToggleButton:onTouchesMove(event)
	if self.focus then
		event:stopPropagation()
	end
end

-- if button is on focus, stop propagation of touch events
function BitmapToggleButton:onTouchesEnd(event)
	if self.focus then
		event:stopPropagation()
	end
end

-- if touches are cancelled, reset the state of the button
function BitmapToggleButton:onTouchesCancel(event)
	if self.focus then
		self.focus = false;
		self:setTextureRegion(self.upTexture)
		event:stopPropagation()
	end
end