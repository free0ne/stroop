local composer = require( "composer" )
local widget = require( "widget" )
local toast = require('plugin.toast')
local scene = composer.newScene()

--local firstback = true
local bgcolor = {255/255, 255/255, 255/255}
local colorButton = {2/255, 218/255, 197/255}
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

local function gameStart( event )
	Runtime:removeEventListener( "key", onKeyEvent )
	composer.gotoScene( "mode2" )
end

local function toMenu( event )
	Runtime:removeEventListener( "key", onKeyEvent )
	composer.gotoScene( "menu" )
end
-- create()
function scene:create( event )
	local sceneGroup = self.view
	firstback = true
	local startGame = display.newRect( sceneGroup, display.contentCenterX, display.contentCenterY + 370, display.contentWidth-120, 130 )
	startGame:setFillColor( unpack (colorButton) )
	startGame:addEventListener( "tap", gameStart )
	local tutorialLabel = display.newText( sceneGroup,
    	"В ДАННОМ РЕЖИМЕ НУЖНО ЧИТАТЬ СЛОВА, УКАЗАННЫЕ В ЗАДАНИИ, И ВЫБРАТЬ ЦВЕТА, КОТОРЫЕ ОНИ ОБОЗНАЧАЮТ\n\nВРЕМЯ: 25 СЕК\nШТРАФ: -1.25 СЕК",
    	display.contentCenterX, display.contentCenterY+15, display.contentWidth-120, 550, font, 35 )
	tutorialLabel:setFillColor( unpack(textcolor) )
	local startLabel = display.newText( sceneGroup, "ОК, ПОЕХАЛИ!", display.contentCenterX, display.contentCenterY + 370, font, 40 )
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
		composer.removeScene( "mode2starter" )
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
