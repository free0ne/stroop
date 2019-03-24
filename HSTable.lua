
local composer = require( "composer" )

local scene = composer.newScene()
local font = "altridge.ttf"
local textcolor = {0, 0, 0}
-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------




-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )

    local sceneGroup = self.view
    -- Code here runs when the scene is first created but has not yet appeared on screen
    local window = display.newRect( sceneGroup, display.contentCenterX,  display.contentCenterY,
    display.contentWidth, display.contentHeight )
    window:setFillColor(0.15, 0.8)
    window:addEventListener( "tap", function() composer.hideOverlay( "fade", 400 ) end)

    --display.newRoundedRect( sceneGroup, display.contentCenterX, 490, 460, 670, 15 ):setFillColor(0.95)
    display.newRect( sceneGroup, display.contentCenterX, 490, 460, 720):setFillColor(0.95)
    display.newCircle( sceneGroup, display.contentCenterX - 230, 130, 25 ):setFillColor( 0.95 )
    local kreuz = display.newImage( sceneGroup, "close.png", display.contentCenterX - 230, 130 )
    kreuz:scale(0.65, 0.65)
    kreuz:setFillColor( 0.1 )

    local highScoresHeader = display.newText( sceneGroup, "High Scores", display.contentCenterX, 180, font, 44 )
    highScoresHeader:setFillColor( unpack(textcolor) )
    local scoreNums = {}
    local scoreValues = {}
    local scoreDates = {}
    local scoresTable = composer.getVariable( "scoresTable" )
    for i = 1, #scoresTable do
        if scoresTable[i][1] > 0 then
            scoreNums[i] = display.newText( sceneGroup, i .. ")", display.contentCenterX-150, 180 + 40 + i * 55, font, 36 )
            scoreNums[i]:setFillColor( unpack(textcolor) )
            scoreValues[i] = display.newText( sceneGroup, scoresTable[i][1], display.contentCenterX - 70, 180 + 40 + i * 55, font, 36 )
            scoreValues[i]:setFillColor( unpack(textcolor) )
            scoreDates[i] = display.newText( sceneGroup, scoresTable[i][2], display.contentCenterX + 80, 180 + 40 + i * 55, font, 36 )
            scoreDates[i]:setFillColor( unpack(textcolor) )
            print(i.." "..scoresTable[i][1])
        end
    end
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
    composer.removeScene( "HSTable" )
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
