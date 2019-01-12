
local composer = require( "composer" )
local widget = require( "widget" )
local toast = require('plugin.toast')
local scene = composer.newScene()

local firstback = true
-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------
local function backTimer( event )
    firstback = true
end

-- Called when a key event has been received
local function onKeyEvent( event )
  -- If the "back" key was pressed on Android, prevent it from backing out of the app
  if (event.phase == "down" and event.keyName == "back" ) then
    if ( system.getInfo("platform") == "android" ) then
      if firstback == true then
        firstback = false
        timer.performWithDelay( 1500, backTimer )
        toast.show('Нажмите ещё раз, чтобы выйти')
        return true
      else
        os.exit()
        return true
      end

      return true
    end
  end
  -- IMPORTANT! Return false to indicate that this app is NOT overriding the received key
  -- This lets the operating system execute its default handling of the key
  return false
end
-- Add the key event listener
Runtime:addEventListener( "key", onKeyEvent )
-- create()
function scene:create( event )
  display.setStatusBar( display.HiddenStatusBar )



	local sceneGroup = self.view
	-- Code here runs when the scene is first created but has not yet appeared on screen
  local bgcolor = {225/255, 226/255, 225/255}
  local labeltextcolor = {1, 1, 1}
  local labelrectcolor = {98/255, 0/255, 237/255}
  local textcolor = {0, 0, 0}
  local subTextcolor = {0.2, 0.2, 0.2}
  local colorButton = {2/255, 218/255, 197/255}
  local offColorButton = {1, 1, 1, 1}
  local startGameRectColor = {55/255, 0/255, 179/255}
  display.setDefault( "background", unpack( bgcolor ) )

  local font = "geometos.ttf"

  local labelRect = display.newRect( sceneGroup, display.contentCenterX, 65, display.contentWidth, 130 )
  labelRect:setFillColor( unpack (labelrectcolor) )
  local label = display.newText( sceneGroup, "Stroop effect", display.contentCenterX, 65, font, 48 )
  label:setFillColor( unpack(labeltextcolor) )

  local function goToGame1( event )
      composer.gotoScene( "mode1" )
  end

  local bgRect = display.newRect( sceneGroup, display.contentCenterX, display.contentCenterY + 50, display.contentWidth-100, 630 )
  bgRect:setFillColor( 1, 1 ,1 )

  local mode1Rect = display.newRect( sceneGroup, display.contentCenterX, display.contentCenterY - 150, display.contentWidth-140, 130 )
  mode1Rect:setFillColor( unpack (colorButton) )
  mode1Rect:addEventListener( "tap", goToGame1 )
  local mode1Label = display.newText( sceneGroup, "определение\nцветов", display.contentCenterX, display.contentCenterY - 150, font, 40 )
  mode1Label:setFillColor( unpack(labeltextcolor) )

  local mode2Rect = display.newRect( sceneGroup, display.contentCenterX, display.contentCenterY + 50, display.contentWidth-140, 130 )
  mode2Rect:setFillColor( unpack (colorButton) )
  mode2Rect:addEventListener( "tap", goToGame1 )
  local mode2Label = display.newText( sceneGroup, "прочтение\nслов", display.contentCenterX - 32, display.contentCenterY + 50, font, 40 )
  mode2Label:setFillColor( unpack(labeltextcolor) )

  local mode3Rect = display.newRect( sceneGroup, display.contentCenterX, display.contentCenterY + 250, display.contentWidth-140, 130 )
  mode3Rect:setFillColor( unpack (colorButton) )
  mode3Rect:addEventListener( "tap", goToGame1 )
  local mode3Label = display.newText( sceneGroup, "смешанный\nтест", display.contentCenterX - 14, display.contentCenterY + 250, font, 40 )
  mode3Label:setFillColor( unpack(labeltextcolor) )




  --[[local startGameRect = display.newRect( sceneGroup, display.contentCenterX, display.contentHeight - 65, display.contentWidth, 130 )
  startGameRect:setFillColor( unpack (startGameRectColor) )
  startGameRect:addEventListener( "tap", goToGame )
  local startGameLabel = display.newText( sceneGroup, "начать", display.contentCenterX, display.contentHeight - 65, font, 40 )
  startGameLabel:setFillColor( unpack(labeltextcolor) ) ]]--

  --[[local o = system.orientation
  local orient = display.newText( sceneGroup, o, display.contentCenterX, 200, native.systemFont, 46 )
  orient:setFillColor( unpack(textcolor) )

  local function onOrientationChange(e)
    orient.text = e.type
  end
  Runtime:addEventListener("orientation", onOrientationChange)   ]]--

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

	elseif ( phase == "did" ) then
		-- Code here runs immediately after the scene goes entirely off screen
    Runtime:removeEventListener( "key", onKeyEvent )
    composer.removeScene( "menu" )
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