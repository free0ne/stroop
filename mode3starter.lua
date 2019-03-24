local composer = require( "composer" )
local widget = require( "widget" )
local toast = require('plugin.toast')
local scene = composer.newScene()

--local firstback = true
local bgcolor = {225/255, 226/255, 225/255}
local colorButton = {2/255, 218/255, 197/255}
local whiteColor = {255/255, 255/255, 255/255}
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

local function gameStart1( event )
	Runtime:removeEventListener( "key", onKeyEvent )
	composer.gotoScene( "mode3" )
end

local function gameStart2( event )
	Runtime:removeEventListener( "key", onKeyEvent )
	composer.gotoScene( "mode4" )
end

local function gameStart3( event )
	Runtime:removeEventListener( "key", onKeyEvent )
	composer.gotoScene( "mode5" )
end

local function hardcoreInfo( event )
	Runtime:removeEventListener( "key", onKeyEvent )
	composer.gotoScene( "hardcoreInfo" )
end

local function toMenu( event )
	Runtime:removeEventListener( "key", onKeyEvent )
	composer.gotoScene( "menu" )
end
-- create()
function scene:create( event )
	local sceneGroup = self.view
	firstback = true

	local backRect = display.newRect( sceneGroup, 40, 40, 80, 80 )
	backRect:setFillColor( unpack(bgcolor) )
	backRect:addEventListener( "tap", toMenu )
	backImage = display.newImage( sceneGroup, "back.png", 35, 35 )
	backImage:setFillColor( 0, 0, 0 )
	backImage:scale(0.7, 0.7)

	local buttonHeight = 220
	local buttonWidth = display.contentWidth-110

	local rectGame1 = display.newRect( sceneGroup, display.contentCenterX, 200, buttonWidth, buttonHeight )
	rectGame1:setFillColor( unpack (whiteColor) )
	local startGame1 = display.newRect( sceneGroup, display.contentCenterX, 200 - 65, display.contentWidth-140, 60 )
	startGame1:setFillColor( unpack (colorButton) )
	startGame1:addEventListener( "tap", gameStart1 )
	local startLabel1 = display.newText( sceneGroup, "1:1", display.contentCenterX, 200 - 65, font, 40 )
	startLabel1:setFillColor( unpack(labeltextcolor) )
	local tutorialLabel1 = display.newText( sceneGroup,
    	"Задания из режимов \"Определение цветов\" & \"Прочтение слов\"\nровно через раз",
    	display.contentCenterX, 462, display.contentWidth-170, 550, font, 22 )
	tutorialLabel1:setFillColor( unpack(textcolor) )

	local rectGame2 = display.newRect( sceneGroup, display.contentCenterX, 475, buttonWidth, buttonHeight )
	rectGame2:setFillColor( unpack (whiteColor) )
	local startGame2 = display.newRect( sceneGroup, display.contentCenterX, 475 - 65, display.contentWidth-140, 60 )
	startGame2:setFillColor( unpack (colorButton) )
	startGame2:addEventListener( "tap", gameStart2 )
	local startLabel2 = display.newText( sceneGroup, "RANDOM", display.contentCenterX, 475 - 65, font, 40 )
	startLabel2:setFillColor( unpack(labeltextcolor) )
	local tutorialLabel2 = display.newText( sceneGroup,
    	"Задания из режимов \"Определение цветов\" & \"Прочтение слов\"\nв случайном порядке",
    	display.contentCenterX, 737, display.contentWidth-170, 550, font, 22 )
	tutorialLabel2:setFillColor( unpack(textcolor) )

	local rectGame3 = display.newRect( sceneGroup, display.contentCenterX, 750, buttonWidth, buttonHeight )
	rectGame3:setFillColor( unpack (whiteColor) )
	local startGame3 = display.newRect( sceneGroup, display.contentCenterX, 750 - 65, display.contentWidth-140, 60 )
	startGame3:setFillColor( unpack (colorButton) )
	startGame3:addEventListener( "tap", gameStart3 )
	local squareGame3 = display.newRect( sceneGroup, display.contentCenterX + 160, 783, 65, 65 )
	squareGame3:setFillColor( unpack (colorButton) )
	squareGame3:addEventListener( "tap", hardcoreInfo )
	local questionGame3 = display.newText( sceneGroup, "?", display.contentCenterX + 160, 783, font, 56 )
	--local questionGame3 = display.newText( sceneGroup, "?", display.contentCenterX + 163, 783, "BrickShapers.otf", 56 )
	questionGame3:setFillColor( unpack(labeltextcolor) )

	local startLabel3 = display.newText( sceneGroup, "hardcore", display.contentCenterX, 750 - 65, font, 40 )
	startLabel3:setFillColor( unpack(labeltextcolor) )
	local tutorialLabel3 = display.newText( sceneGroup,
    	"Обучение окончено,\nможно приступить\nк полноценной игре!",
    	display.contentCenterX, 1022, display.contentWidth-170, 550, font, 22 )
	tutorialLabel3:setFillColor( unpack(textcolor) )





	--[[local startGame = display.newRect( sceneGroup, display.contentCenterX, display.contentCenterY + 370, display.contentWidth-140, 130 )
	startGame:setFillColor( unpack (colorButton) )
	startGame:addEventListener( "tap", gameStart )
	local tutorialLabel = display.newText( sceneGroup,
    	"в данном режиме нужно определить, какого цвета слова, указанные в задании, и выбрать соответствующий вариант ответа\n\nвремя: 25 сек\nштраф: -1.25 сек",
    	display.contentCenterX, display.contentCenterY-40, display.contentWidth-120, 550, font, 35 )
	tutorialLabel:setFillColor( unpack(textcolor) )
	local startLabel = display.newText( sceneGroup, "ок, поехали!", display.contentCenterX, display.contentCenterY + 370, font, 40 )
	startLabel:setFillColor( unpack(labeltextcolor) )]]--




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
		Runtime:removeEventListener( "key", onKeyEvent )
	elseif ( phase == "did" ) then
		-- Code here runs immediately after the scene goes entirely off screen
		composer.removeScene( "mode3starter" )
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
