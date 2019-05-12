local composer = require( "composer" )
local translations = require("translations")
local lang
local widget = require( "widget" )
local toast = require('plugin.toast')
local scene = composer.newScene()

--local firstback = true
local bgcolor = {235/255, 235/255, 235/255}
local colorButton = {2/255, 218/255, 197/255}
local labeltextcolor = {1, 1, 1}
local textcolor = {0, 0, 0}
local purColor = {88/255, 2/255, 109/255}
--local font = "geometos.ttf"
local font = "altridge"


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
				composer.gotoScene( "menu" )
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
	composer.gotoScene( "mode5" )
end

local function toMenu( event )
	Runtime:removeEventListener( "key", onKeyEvent )
	composer.gotoScene( "menu" )
end

local function openInstruction( event )
        composer.showOverlay( "instruction" , {
            isModal = true,
            effect = "fade",
            time = 400,
        } )
end
-- create()
function scene:create( event )
	local sceneGroup = self.view
    lang = composer.getVariable( "settingsTable" )[2]
	firstback = true

	local options =
    {
        text = translations["gamerules"][lang],
        x = display.contentWidth/2,
        y = display.contentHeight * 0.323,
        width = 420,
    	font = font,
        fontSize = 24,
        align = "left"  -- Alignment parameter
    }



    local helpText = display.newText( options )
    helpText:setFillColor( 0 )
    sceneGroup:insert(helpText)


    local instructionRect = display.newRoundedRect( sceneGroup, display.contentCenterX, display.contentHeight - 280, display.contentWidth-140, 130, 50 )
	instructionRect:setFillColor( unpack (purColor) )
	instructionRect:addEventListener( "tap", openInstruction )
	local instructionLabel = display.newText( sceneGroup, translations["detailed_instructions"][lang], display.contentCenterX, display.contentHeight - 280, font, 40 )
	instructionLabel:setFillColor( unpack(labeltextcolor) )


    local startGame = display.newRoundedRect( sceneGroup, display.contentCenterX, display.contentHeight - 110, display.contentWidth-140, 130, 50 )
	startGame:setFillColor( unpack (purColor) )
	startGame:addEventListener( "tap", gameStart )
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
		composer.removeScene( "hardcoreInfo" )
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
