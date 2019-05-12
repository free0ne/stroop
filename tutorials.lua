local composer = require( "composer" )
local widget = require( "widget" )
local toast = require('plugin.toast')
local scene = composer.newScene()

--local firstback = true
local bgcolor = {235/255, 235/255, 235/255}
local labelrectcolor = {120/255, 0/255, 64/255}
local labeltextcolor = {1, 1, 1}
local textcolor = {11/255, 0/255, 69/255}
local translations = require("translations")
--local font = "geometos.ttf"
local font = "altridge.ttf"
local settingsTable

local mode1Rect
local mode1Label
local mode2Rect
local mode2Label
local mode3Rect
local mode3Label
local mode3Label2
local mode4Rect
local mode4Label

local helpImg
local closeImg

local emptyVisible = false
local emptyRect1
local emptyRect2
local emptyRect3
local emptyRect4
local emptyLabel1
local emptyLabel2
local emptyLabel3
local emptyLabel4

local menuImg

if display.contentHeight/display.contentWidth > 2 then display.setStatusBar( display.DefaultStatusBar )
   else display.setStatusBar( display.HiddenStatusBar ) end
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

local function toMenu( event )
	Runtime:removeEventListener( "key", onKeyEvent )
	composer.gotoScene( "menu" )
end

local function goToGame1( event )
    composer.gotoScene( "mode1starter" )
end

local function goToGame2( event )
    composer.gotoScene( "mode2starter" )
end

local function goToGame3( event )
	composer.gotoScene( "mode3" )
end

local function goToGame4( event )
	composer.gotoScene( "mode4" )
end

local function showHelp( event )
	if emptyVisible == false then
		emptyRect1.isVisible = true
		emptyLabel1.isVisible = true
		emptyRect2.isVisible = true
		emptyLabel2.isVisible = true
		emptyRect3.isVisible = true
		emptyLabel3.isVisible = true
		emptyRect4.isVisible = true
		emptyLabel4.isVisible = true
		helpImg.isVisible = false
		closeImg.isVisible = true
		emptyVisible = true
	else
		emptyRect1.isVisible = false
		emptyLabel1.isVisible = false
		emptyRect2.isVisible = false
		emptyLabel2.isVisible = false
		emptyRect3.isVisible = false
		emptyLabel3.isVisible = false
		emptyRect4.isVisible = false
		emptyLabel4.isVisible = false
		closeImg.isVisible = false
		helpImg.isVisible = true
		emptyVisible = false
	end
end

-- create()
function scene:create( event )
	local sceneGroup = self.view
	settingsTable = composer.getVariable( "settingsTable" )
	local labelRect = display.newRect( sceneGroup, display.contentCenterX, display.contentHeight*0.057291, display.contentWidth, display.contentHeight*0.078125*2 )
    labelRect:setFillColor( unpack (labelrectcolor) )
    local label = display.newText( sceneGroup, translations["Tutorial"][settingsTable[2]], display.contentCenterX, display.contentHeight*0.0677, font, 48 )
    label:setFillColor( unpack(labeltextcolor) )

	mode1Rect = display.newRoundedRect( sceneGroup, display.contentCenterX, display.contentHeight*0.28, 420, display.contentHeight*0.14, 50 )
    mode1Rect:setFillColor(1)
    mode1Rect:addEventListener( "tap", goToGame1 )
    mode1Label = display.newImage( sceneGroup, "rgb.png", display.contentCenterX,display.contentHeight*0.28 )

	mode2Rect = display.newRoundedRect( sceneGroup, display.contentCenterX, display.contentHeight*0.45, 420, display.contentHeight*0.14, 50 )
    mode2Rect:setFillColor(1)
    mode2Rect:addEventListener( "tap", goToGame2 )
    mode2Label = display.newText( sceneGroup,"Tт", display.contentCenterX, display.contentHeight*0.45, font, 62 )
    mode2Label:setFillColor( unpack(labelrectcolor) )

	mode3Rect = display.newRoundedRect( sceneGroup, display.contentCenterX, display.contentHeight*0.62, 420, display.contentHeight*0.14, 50 )
    mode3Rect:setFillColor(1)
    mode3Rect:addEventListener( "tap", goToGame3 )
    mode3Label = display.newImage( sceneGroup, "rgb.png", display.contentCenterX - 50,display.contentHeight*0.62 )
	mode3Label2 = display.newText( sceneGroup,"Tт", display.contentCenterX + 50, display.contentHeight*0.62, font, 62 )
    mode3Label2:setFillColor( unpack(labelrectcolor) )

	mode4Rect = display.newRoundedRect( sceneGroup, display.contentCenterX, display.contentHeight*0.79, 420, display.contentHeight*0.14, 50 )
    mode4Rect:setFillColor(1)
    mode4Rect:addEventListener( "tap", goToGame4 )
    mode4Label = display.newText( sceneGroup,"RANDOM", display.contentCenterX, display.contentHeight*0.79, font, 50 )
    mode4Label:setFillColor( unpack(labelrectcolor) )

	helpImg = display.newImage( sceneGroup, "help.png", display.contentWidth-50,display.contentHeight-50 )
	helpImg:setFillColor(unpack(labelrectcolor))
    helpImg:scale(0.75, 0.75)
	helpImg:addEventListener( "tap", showHelp )
	closeImg = display.newImage( sceneGroup, "cancel.png", display.contentWidth-50,display.contentHeight-50 )
	closeImg:setFillColor(unpack(labelrectcolor))
    closeImg:scale(0.75, 0.75)
	closeImg:addEventListener( "tap", showHelp )
	closeImg.isVisible = false

	emptyRect1 = display.newRoundedRect( sceneGroup, display.contentCenterX, display.contentHeight*0.28, 420, display.contentHeight*0.14, 50 )
	emptyRect1:setFillColor(1, 1, 1, 0.85)
	emptyRect1.strokeWidth = 4
	emptyRect1:setStrokeColor( unpack(labelrectcolor) )
	emptyRect1.isVisible = false
	emptyLabel1 = display.newText( sceneGroup,translations["mode1"][settingsTable[2]], display.contentCenterX, display.contentHeight*0.28, font, 34 )
    emptyLabel1:setFillColor( unpack(textcolor) )
	emptyLabel1.isVisible = false

	emptyRect2 = display.newRoundedRect( sceneGroup, display.contentCenterX, display.contentHeight*0.45, 420, display.contentHeight*0.14, 50 )
	emptyRect2:setFillColor(1, 1, 1, 0.85)
	emptyRect2.strokeWidth = 4
	emptyRect2:setStrokeColor( unpack(labelrectcolor) )
	emptyRect2.isVisible = false
	emptyLabel2 = display.newText( sceneGroup,translations["mode2"][settingsTable[2]], display.contentCenterX, display.contentHeight*0.45, font, 34 )
    emptyLabel2:setFillColor( unpack(textcolor) )
	emptyLabel2.isVisible = false

	emptyRect3 = display.newRoundedRect( sceneGroup, display.contentCenterX, display.contentHeight*0.62, 420, display.contentHeight*0.14, 50 )
	emptyRect3:setFillColor(1, 1, 1, 0.85)
	emptyRect3.strokeWidth = 4
	emptyRect3:setStrokeColor( unpack(labelrectcolor) )
	emptyRect3.isVisible = false
	emptyLabel3 = display.newText( sceneGroup,translations["mode3"][settingsTable[2]], display.contentCenterX, display.contentHeight*0.62, font, 26 )
    emptyLabel3:setFillColor( unpack(textcolor) )
	emptyLabel3.isVisible = false

	emptyRect4 = display.newRoundedRect( sceneGroup, display.contentCenterX, display.contentHeight*0.79, 420, display.contentHeight*0.14, 50 )
	emptyRect4:setFillColor(1, 1, 1, 0.85)
	emptyRect4.strokeWidth = 4
	emptyRect4:setStrokeColor( unpack(labelrectcolor) )
	emptyRect4.isVisible = false
	emptyLabel4 = display.newText( sceneGroup,translations["mode4"][settingsTable[2]], display.contentCenterX, display.contentHeight*0.79, font, 26 )
    emptyLabel4:setFillColor( unpack(textcolor) )
	emptyLabel4.isVisible = false

	menuImg = display.newImage( sceneGroup, "menu.png", 50,display.contentHeight-50 )
	menuImg:setFillColor(unpack(labelrectcolor))
    menuImg:scale(0.75, 0.75)
	menuImg:addEventListener( "tap", toMenu )


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
		composer.removeScene( "tutorials" )
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
