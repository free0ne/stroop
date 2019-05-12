
local composer = require( "composer" )
local widget = require( "widget" )
local toast = require('plugin.toast')
local scene = composer.newScene()

local firstback = true

local json = require( "json" )
local settingsTable = {}
local filePath = system.pathForFile( "settings.json", system.DocumentsDirectory )
local filePath2 = system.pathForFile( "random.json", system.DocumentsDirectory )
local loadSettings
local isVibroSetting
local languageSetting
local translations = require("translations")
local tutorialRect
local tutorialText
local gameRect
local gameText
local scoresTable = {}
local loadScores
-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

function scene:updateTitles()
	tutorialText.text = translations["Tutorial"][settingsTable[2]]
    gameText.text = translations["Game"][settingsTable[2]]
end

loadScores = function()
    local file = io.open( filePath2, "r" )
    if file then
        local contents = file:read( "*a" )
        io.close( file )
        scoresTable = json.decode( contents )
    end
    if ( scoresTable == nil or #scoresTable == 0 ) then
        scoresTable = { {0, "0.0.0000"}, {0, "0.0.0000"}, {0, "0.0.0000"},
        {0, "0.0.0000"}, {0, "0.0.0000"}, {0, "0.0.0000"}, {0, "0.0.0000"},
        {0, "0.0.0000"}, {0, "0.0.0000"}, {0, "0.0.0000"} }
    end
end

loadSettings = function()
    local file = io.open( filePath, "r" )
    if file then
        local contents = file:read( "*a" )
        io.close( file )
        settingsTable = json.decode( contents )
    end
    if ( settingsTable == nil or #settingsTable == 0 ) then
        local lang = ( system.getPreference( "locale", "language" ) )
        if lang == "ru" or lang == "be" or lang == "uk" then
            settingsTable = { true, "ru" }
        elseif lang == "de" then
            settingsTable = { true, "de" }
        else settingsTable = { true, "en" }
        end
    end
    composer.setVariable( "settingsTable", settingsTable )
end

local function openSettings( event )
        composer.showOverlay( "settings" , {
            isModal = true,
            effect = "fade",
            time = 400,
        } )
end

local function backTimer( event )
    firstback = true
end

local function goToTutorials( event )
    composer.gotoScene( "tutorials" )
end

local function hardcoreInfo( event )
	composer.gotoScene( "hardcoreInfo" )
end

local function openHSTable()
    composer.showOverlay( "HSTable" , {
      isModal = true,
      effect = "fade",
      time = 400,
    } )
end

-- Called when a key event has been received
local function onKeyEvent( event )
  -- If the "back" key was pressed on Android, prevent it from backing out of the app
  if (event.phase == "down" and event.keyName == "back" ) then
    if ( system.getInfo("platform") == "android" ) then
      if firstback == true then
        firstback = false
        timer.performWithDelay( 1500, backTimer )
        toast.show(translations["tap_exit"][settingsTable[2]])
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
    loadSettings()
	loadScores()
	composer.setVariable( "scoresTable", scoresTable )

    print("vibro = "..tostring(settingsTable[1]))
    print(tostring(settingsTable[2]))
    if display.contentHeight/display.contentWidth > 2 then display.setStatusBar( display.DefaultStatusBar )
       else display.setStatusBar( display.HiddenStatusBar ) end



	local sceneGroup = self.view
	-- Code here runs when the scene is first created but has not yet appeared on screen
    local bgcolor = {235/255, 235/255, 235/255}
    local labeltextcolor = {1, 1, 1}
    local labelrectcolor = {88/255, 2/255, 109/255}
    local textcolor = {0, 0, 0}
    local subTextcolor = {0.2, 0.2, 0.2}
    local colorButton = {2/255, 218/255, 197/255}
    local offColorButton = {1, 1, 1, 1}
    local startGameRectColor = {55/255, 0/255, 179/255}
    local tutorialColor = {120/255, 0/255, 64/255}
    local fontSize = 33

    display.setDefault( "background", unpack( bgcolor ) )

    --local font = "geometos.ttf"
    local font = "altridge.ttf"


    local labelRect = display.newRect( sceneGroup, display.contentCenterX, display.contentHeight*0.057291, display.contentWidth, display.contentHeight*0.078125*2 )
    labelRect:setFillColor( unpack (labelrectcolor) )
    local label = display.newText( sceneGroup, "STROOP EFFECT", display.contentCenterX, display.contentHeight*0.0677, font, 48 )
    label:setFillColor( unpack(labeltextcolor) )

    --local mode1Label = display.newText( sceneGroup, "ОПРЕДЕЛЕНИЕ\nЦВЕТОВ", display.contentCenterX, display.contentCenterY - 120, font, fontSize )
    --local mode2Label = display.newText( sceneGroup, "ПРОЧТЕНИЕ\nСЛОВ", display.contentCenterX - 32, display.contentCenterY + 50, font, fontSize )
    --local mode3Label = display.newText( sceneGroup, "СМЕШАННЫЕ\nТЕСТЫ", display.contentCenterX - 14, display.contentCenterY + 220, font, fontSize )

    tutorialRect = display.newRoundedRect( sceneGroup, display.contentCenterX, display.contentHeight*0.38, 420, display.contentHeight*0.24, 50 )
    tutorialRect:setFillColor(1)
    tutorialRect:addEventListener( "tap", goToTutorials )
    tutorialText = display.newText( sceneGroup, translations["Tutorial"][settingsTable[2]], display.contentCenterX, display.contentHeight*0.38, font, 48 )
    tutorialText:setFillColor( unpack(tutorialColor) )

    gameRect = display.newRoundedRect( sceneGroup, display.contentCenterX, display.contentHeight*0.67, 420, display.contentHeight*0.24, 50 )
    gameRect:setFillColor(1)
    gameRect:addEventListener( "tap", hardcoreInfo )
    gameText = display.newText( sceneGroup, translations["Game"][settingsTable[2]], display.contentCenterX, display.contentHeight*0.67, font, 48 )
    gameText:setFillColor( unpack(labelrectcolor) )

    local helpImg = display.newImage( sceneGroup, "setting.png", 45, display.contentHeight - 50 )
    helpImg:setFillColor(unpack(labelrectcolor))
    helpImg:scale(0.7, 0.7)
    helpImg:addEventListener( "tap", openSettings )

	local recordsImg = display.newImage( sceneGroup, "list.png", display.contentWidth - 45, display.contentHeight - 50 )
    recordsImg:setFillColor(unpack(labelrectcolor))
    recordsImg:scale(0.7, 0.7)
    recordsImg:addEventListener( "tap", openHSTable )
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
        --print("menuhidewill")
	elseif ( phase == "did" ) then
		-- Code here runs immediately after the scene goes entirely off screen
        --print("menuhidedid")
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
