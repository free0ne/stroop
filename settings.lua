local composer = require( "composer" )

local scene = composer.newScene()
local widget = require( "widget" )
local translations = require("translations")

local updatesImg
local dankeImg
local updatesTitle
local updatesText
local dankeText
local commentImg
local settingsImg
local settingsTitle

local vibroTitle
local vibroRect
local vibroCheck

local languageTitle
local ruImg
local ukIng
local geImg
local languageRight
local languageLeft
local currLanguage
local chooseLeft
local chooseRight

local purColor = {88/255, 2/255, 109/255}
local isVibro = false

local whoamiText
local whoamiImg
local whoamiTitle

local json = require( "json" )
local settingsTable = {}
local filePath = system.pathForFile( "settings.json", system.DocumentsDirectory )
local saveSettings

local footageText
local refreshTexts

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------




-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------
saveSettings = function()
    local file = io.open( filePath, "w" )
    if file then
        file:write( json.encode( settingsTable ) )
        io.close( file )
    end
end

local function chooseUpdates( event )
    updatesImg.alpha = 1
    dankeImg.alpha = 0.3
    settingsImg.alpha = 0.3
	updatesTitle.isVisible = true
    settingsTitle.isVisible = false
	updatesText.isVisible = true
	dankeText.isVisible = false
	commentImg.isVisible = false
    vibroTitle.isVisible = false
    vibroRect.isVisible = false
    vibroCheck.isVisible = false
    whoamiText.isVisible = false
    whoamiTitle.isVisible = false
    whoamiImg.isVisible = false
	languageTitle.isVisible = false
	languageLeft.isVisible = false
	languageRight.isVisible = false
	ruImg.isVisible = false
	ukImg.isVisible = false
	geImg.isVisible = false
end

local function chooseDanke( event )
    dankeImg.alpha = 1
    updatesImg.alpha = 0.3
    settingsImg.alpha = 0.3
	updatesTitle.isVisible = false
	updatesText.isVisible = false
	dankeText.isVisible = true
	commentImg.isVisible = true
    settingsTitle.isVisible = false
    vibroTitle.isVisible = false
    vibroRect.isVisible = false
    vibroCheck.isVisible = false
    whoamiText.isVisible = true
    whoamiTitle.isVisible = true
    whoamiImg.isVisible = true
	languageTitle.isVisible = false
	languageLeft.isVisible = false
	languageRight.isVisible = false
	ruImg.isVisible = false
	ukImg.isVisible = false
	geImg.isVisible = false
end

local function chooseSettings( event )
    settingsImg.alpha = 1
    dankeImg.alpha = 0.3
    updatesImg.alpha = 0.3
	updatesTitle.isVisible = false
	updatesText.isVisible = false
	dankeText.isVisible = false
	commentImg.isVisible = false
    settingsTitle.isVisible = true
    vibroTitle.isVisible = true
    vibroRect.isVisible = true
    whoamiText.isVisible = false
    whoamiTitle.isVisible = false
    whoamiImg.isVisible = false
    if isVibro then
        vibroCheck.isVisible = true
    else vibroCheck.isVisible = false end
	languageTitle.isVisible = true
	languageLeft.isVisible = true
	languageRight.isVisible = true
	if settingsTable[2] == "ru" then ruImg.isVisible = true end
	if settingsTable[2] == "en" then ukImg.isVisible = true end
	if settingsTable[2] == "de" then geImg.isVisible = true end
end

local function goToWhoami (event)
	if ( system.canOpenURL( "http://play.google.com/store/apps/details?id=pw.casualgaming.whoami" ) ) then
    	system.openURL( "http://play.google.com/store/apps/details?id=pw.casualgaming.whoami" )
	end
end

local function goToStroop (event)
	if ( system.canOpenURL( "http://play.google.com/store/apps/details?id=pw.casualgaming.stroop" ) ) then
    	system.openURL( "http://play.google.com/store/apps/details?id=pw.casualgaming.stroop" )
	end
end

local function vibroSwitch (event)
    if isVibro then
        isVibro = false
        vibroCheck.isVisible = false
		settingsTable[1] = false
    else
        vibroCheck.isVisible = true
        isVibro = true
		settingsTable[1] = true
    end
	composer.setVariable( "settingsTable", settingsTable )
	saveSettings()
end

local function chooseLeft (event)  -- ru en de ru en de
	local lang = settingsTable[2]
	if lang == "ru" then
		settingsTable[2] = "de"
		ruImg.isVisible = false
		geImg.isVisible = true
	elseif lang == "de" then
		settingsTable[2] = "en"
		geImg.isVisible = false
		ukImg.isVisible = true
	elseif lang == "en" then
		settingsTable[2] = "ru"
		ukImg.isVisible = false
		ruImg.isVisible = true
	end
	composer.setVariable( "settingsTable", settingsTable )
	saveSettings()
	refreshTexts()
end

local function chooseRight (event)  -- ru en de ru en de
	local lang = settingsTable[2]
	if lang == "ru" then
		settingsTable[2] = "en"
		ruImg.isVisible = false
		ukImg.isVisible = true
	elseif lang == "en" then
		settingsTable[2] = "de"
		ukImg.isVisible = false
		geImg.isVisible = true
	elseif lang == "de" then
		settingsTable[2] = "ru"
		geImg.isVisible = false
		ruImg.isVisible = true
	end
	composer.setVariable( "settingsTable", settingsTable )
	saveSettings()
	refreshTexts()
end

refreshTexts = function()
	settingsTitle.text = translations["Settings"][settingsTable[2]]
	vibroTitle.text = translations["Vibration"][settingsTable[2]]
	languageTitle.text = translations["Language"][settingsTable[2]]
	footageText.text = translations["Say"][settingsTable[2]]
	dankeText.text = translations["Support"][settingsTable[2]]
	updatesText.text = translations["Changelog"][settingsTable[2]]
end
-- create()
function scene:create( event )

	settingsTable = composer.getVariable( "settingsTable" )
	isVibro = settingsTable[1]
	currLanguage = settingsTable[2]
	local sceneGroup = self.view
	-- Code here runs when the scene is first created but has not yet appeared on screen
    local window = display.newRect( sceneGroup, display.contentCenterX,  display.contentCenterY,
    display.contentWidth, display.contentHeight+100 )
    --window:setFillColor(0.15, 0.8)
	window:setFillColor(1)
	local font = "altridge.ttf"

	updatesImg = display.newImage( sceneGroup, "update.png", display.contentWidth*0.25, display.contentHeight*0.1 )
	updatesImg:setFillColor(unpack( purColor ))
    updatesImg:addEventListener( "tap", chooseUpdates )
    updatesImg.alpha = 0.3

    settingsImg = display.newImage( sceneGroup, "setting.png", display.contentWidth*0.5, display.contentHeight*0.1 )
	settingsImg:setFillColor(unpack( purColor ))
    settingsImg:addEventListener( "tap", chooseSettings )

	dankeImg = display.newImage( sceneGroup, "emoticon.png", display.contentWidth*0.75, display.contentHeight*0.1 )
	dankeImg:setFillColor(unpack( purColor ))
    dankeImg.alpha = 0.3
    dankeImg:addEventListener( "tap", chooseDanke )



	updatesTitle = display.newText( sceneGroup, "Changelog", display.contentCenterX, display.contentHeight*0.19, font, 36 )
	updatesTitle:setFillColor( 0, 0, 0 )
    updatesTitle.isVisible = false

    settingsTitle = display.newText( sceneGroup, translations["Settings"][settingsTable[2]], display.contentCenterX, display.contentHeight*0.19, font, 36 )
	settingsTitle:setFillColor( 0, 0, 0 )
    settingsTitle.isVisible = true

    vibroTitle = display.newText( sceneGroup, translations["Vibration"][settingsTable[2]], display.contentCenterX-70, display.contentHeight*0.38, font, 32 )
	vibroTitle:setFillColor( 0, 0, 0 )
    vibroTitle.isVisible = true
    vibroTitle:addEventListener( "tap", vibroSwitch)
    vibroRect = display.newImage( sceneGroup, "box.png", display.contentCenterX+70, display.contentHeight*0.38)
	vibroRect:setFillColor(0, 0, 0)
	vibroRect:scale(0.85, 0.85)
    vibroRect.isVisible = true
    vibroRect:addEventListener( "tap", vibroSwitch)
    vibroCheck = display.newImage( sceneGroup, "check.png", display.contentCenterX+70, display.contentHeight*0.38)
	vibroCheck:setFillColor(unpack( purColor ))
	vibroCheck:scale(0.68, 0.68)
    if isVibro then
        vibroCheck.isVisible = true
    else vibroCheck.isVisible = false end

	languageTitle = display.newText( sceneGroup, translations["Language"][settingsTable[2]], display.contentCenterX-110, display.contentHeight*0.52, font, 32 )
	languageTitle:setFillColor( 0, 0, 0 )
    languageTitle.isVisible = true
	languageLeft = display.newImage( sceneGroup, "left.png", display.contentCenterX-10, display.contentHeight*0.52)
	languageLeft:setFillColor(unpack(purColor))
	languageLeft:scale(0.95, 0.95)
    languageLeft.isVisible = true
	languageLeft:addEventListener( "tap", chooseLeft )
	languageRight = display.newImage( sceneGroup, "right.png", display.contentCenterX+170, display.contentHeight*0.52)
	languageRight:setFillColor(unpack(purColor))
	languageRight:scale(0.95, 0.95)
    languageRight.isVisible = true
	languageRight:addEventListener( "tap", chooseRight )

	ruImg = display.newImage( sceneGroup, "ru.png", display.contentCenterX+80, display.contentHeight*0.52)
	ruImg:scale(0.4, 0.4)
    ruImg.isVisible = false
	if currLanguage == "ru" then ruImg.isVisible = true end
	ukImg = display.newImage( sceneGroup, "uk.png", display.contentCenterX+80, display.contentHeight*0.52)
	ukImg:scale(0.4, 0.4)
    ukImg.isVisible = false
	if currLanguage == "en" then ukImg.isVisible = true end
	geImg = display.newImage( sceneGroup, "ge.png", display.contentCenterX+80, display.contentHeight*0.52)
	geImg:scale(0.4, 0.4)
    geImg.isVisible = false
	if currLanguage == "de" then geImg.isVisible = true end


	footageText = display.newText( sceneGroup, translations["Say"][settingsTable[2]], display.contentWidth*0.55, display.contentHeight - 85, font, 22 )
	footageText:setFillColor( 0, 0, 0 )

    --display.newRoundedRect( sceneGroup, display.contentCenterX, display.contentCenterY, display.contentWidth*0.87,  display.contentHeight*0.7, 10 ):setFillColor(0.95)
    local options =
    {
        text = translations["Changelog"][settingsTable[2]],
        x = display.contentWidth/2,
        y = display.contentHeight*0.3,
        width = 420,
        font = font,
        fontSize = 22,
        align = "left"  -- Alignment parameter
    }

    updatesText = display.newText( options )
    updatesText:setFillColor( 0 )
    updatesText.isVisible = false
    sceneGroup:insert(updatesText)

    whoamiText = display.newText( sceneGroup, "Попробуйте также другое\nнаше приложение:\n", display.contentWidth*0.5, display.contentHeight*0.26, font, 29 )
	whoamiText:setFillColor( 0.2 )
	whoamiText.isVisible = false
    whoamiTitle = display.newText( sceneGroup, "\"Угадай, кто?\"", display.contentWidth*0.37, display.contentHeight*0.35, font, 29 )
	whoamiTitle:setFillColor( 0.2 )
	whoamiTitle.isVisible = false
    whoamiTitle:addEventListener( "tap", goToWhoami)
    whoamiImg = display.newImage( sceneGroup, "whoami.png", display.contentWidth*0.67, display.contentHeight*0.35)
	whoamiImg:scale(0.4, 0.4)
    whoamiImg.isVisible = false
    whoamiImg:addEventListener( "tap", goToWhoami)

	dankeText = display.newText( sceneGroup, translations["Support"][settingsTable[2]], display.contentWidth*0.5, display.contentHeight*0.53, font, 29 )
	dankeText:setFillColor( 0.2 )
	dankeText.isVisible = false

	commentImg = display.newImage( sceneGroup, "comment.png", display.contentWidth*0.5, display.contentHeight*0.70 )
	commentImg:setFillColor(88/255, 2/255, 109/255)
	--commentImg:scale(0.85, 0.85)
	commentImg.isVisible = false
	commentImg:addEventListener( "tap", goToStroop )

	local backImg = display.newImage( sceneGroup, "cancel.png", 45, display.contentHeight - 50)
	backImg:setFillColor(unpack( purColor ))
	backImg:scale(0.7, 0.7)
    backImg:addEventListener( "tap", function() composer.hideOverlay( "fade", 400 ) end)

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
	local parent = event.parent  --reference to the parent scene object
	if ( phase == "will" ) then
		-- Code here runs when the scene is on screen (but is about to go off screen)
		parent:updateTitles()
	elseif ( phase == "did" ) then
		-- Code here runs immediately after the scene goes entirely off screen
		composer.removeScene( "settings" )
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
