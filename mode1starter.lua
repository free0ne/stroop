local composer = require( "composer" )
local widget = require( "widget" )
local toast = require('plugin.toast')
local translations = require("translations")
local lang
local scene = composer.newScene()

--local firstback = true
local bgcolor = {235/255, 235/255, 235/255}
local colorButton = {120/255, 0/255, 64/255}
local labeltextcolor = {1, 1, 1}
local textcolor = {0, 0, 0}
--local font = "geometos.ttf"
local font = "altridge.ttf"



display.setStatusBar( display.HiddenStatusBar )
display.setDefault( "background", unpack( bgcolor ) )
-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------




-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------
--[[local function backTimer( event )
    firstback = true
end]]--

local function onKeyEvent( event )
	if (event.phase == "down" and event.keyName == "back" ) then
		if ( system.getInfo("platform") == "android" ) then
			--if firstback == true then
			--	firstback = false
			--	timer.performWithDelay( 1500, backTimer )
			--	toast.show('Нажмите ещё раз, чтобы выйти в меню')
			--	return true
			--else
			--	firstback = true
				composer.gotoScene( "tutorials" )
			--	return true
			--end

			return true
		end
	end
	return false
end
-- Add the key event listener
Runtime:addEventListener( "key", onKeyEvent )

local function gameStart( event )
	Runtime:removeEventListener( "key", onKeyEvent )
	composer.gotoScene( "mode1" )
end

local function toMenu( event )
	Runtime:removeEventListener( "key", onKeyEvent )
	composer.gotoScene( "tutorials" )
end
-- create()
function scene:create( event )
	local sceneGroup = self.view
	lang = composer.getVariable( "settingsTable" )[2]
	firstback = true
	local startGame = display.newRoundedRect( sceneGroup, display.contentCenterX, display.contentHeight - 110, display.contentWidth-120, 130, 50 )
	startGame:setFillColor( unpack (colorButton) )
	startGame:addEventListener( "tap", gameStart )
	local tutorialLabel = display.newText( sceneGroup,
    	translations["color_tutorial"][lang],
    	display.contentCenterX, display.contentCenterY-40, display.contentWidth-120, 550, font, 35 )
	tutorialLabel:setFillColor( unpack(textcolor) )
	local startLabel = display.newText( sceneGroup, translations["okgo"][lang], display.contentCenterX, display.contentHeight - 110, font, 40 )
	startLabel:setFillColor( unpack(labeltextcolor) )

	local backRect = display.newRect( sceneGroup, 40, 40, 80, 80 )
	backRect:setFillColor( unpack(bgcolor) )
	backRect:addEventListener( "tap", toMenu )
	backImage = display.newImage( sceneGroup, "back.png", 35, 35 )
	backImage:setFillColor( 0, 0, 0 )
	backImage:scale(0.7, 0.7)


end


-- show()
function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is still off screen (but is about to come on screen)

	elseif ( phase == "did" ) then
		-- Code here runs when the scene is entirely on screen
	end
end


-- hide()
function scene:hide( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is on screen (but is about to go off screen)
		--print("mode1starterwill")
		Runtime:removeEventListener( "key", onKeyEvent )
	elseif ( phase == "did" ) then
		-- Code here runs immediately after the scene goes entirely off screen
		--print("mode1starterdid")
		composer.removeScene( "mode1starter" )
	end
end


-- destroy()
function scene:destroy( event )

	local sceneGroup = self.view
	-- Code here runs prior to the removal of scene's view

end


-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
-- -----------------------------------------------------------------------------------

return scene
