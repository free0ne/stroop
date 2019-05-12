
local composer = require( "composer" )
local colors
local translations = require("translations")
local scene = composer.newScene()
local font = "altridge.ttf"
local textcolor = {0, 0, 0}
local lang

local answersRect
local devider1
local devider2
local devider3
local taskLabel
local taskLabel2
local countLabel
local timerRect
local timerText
local taskFontSize = 58
local timerFontSize = 44
local answerSize = 50
local outlinecolor = {0, 0, 0, 0.4}
local purColor = {88/255, 2/255, 109/255}
local clrImgTask
local nameImgTask
local clrImgAnswers
local nameImgAnswers

local tasks = {}
local icons = {}
local answers = { }
local answersColored = {}
local taskNum = 1

local sceneGroup
local frontGroup
local uiGroup

local position = 1
local positionText
local positions = { {false, false, false, false, false, false, false, false, false, false, false, false, false},
                    {true, false, true, false, true, false, false, false, false, false, false, false, true},
                    {true, false, false, false, false, false, true, true, true, false, false, false, true},
                    {false, true, false, true, false, true, false, false, false, false, false, false, true},
                    {true, true, false, false, false, false, false, false, true, true, true, true, true},
                    {false, false, false, false, false, false, false, false, false, false, false, false, false},
                    {true, true, false, false, false, false, false, false, true, true, true, true, true},
                    {false, false, false, false, false, false, false, false, false, false, false, false, false},
                    {true, true, false, false, false, false, false, false, true, true, true, true, true},
                    {false, false, false, false, false, false, false, false, false, false, false, false, false},
                    {true, true, false, false, false, false, false, false, true, true, true, true, true}, }

local blackWindow
local blackRect
local taskCircle
local answerCircle
local taskExplanation
local taskExplanation
local answerExplanation
local answerExplanation
local taskRectExplanation
local answerRectExplanation
local halfAnswerRect
local halfAnswer
local answerBackRect
local taskBackRect
local whyRect

--не начато

local whyText
-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------




-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------
local function setTable ()
    taskLabel2.text = tasks[taskNum][1]
    taskLabel.text = tasks[taskNum][1]
    taskLabel:setFillColor(unpack(tasks[taskNum][2]))
    clrImgTask.isVisible = not icons[taskNum][1]
    nameImgTask.isVisible = icons[taskNum][1]
    clrImgAnswers.isVisible = not icons[taskNum][2]
    nameImgAnswers.isVisible = icons[taskNum][2]

    for i = 0,3 do
        answersColored[i].text = answers[taskNum][i+1][1]
        answersColored[i]:setFillColor( unpack(answers[taskNum][i+1][2]) )
    end
end

local function updateExplanation ()
    if position == 2  then
        taskExplanation.text = translations["colorTaskExplanation"][lang]
    elseif position == 4 then
        answerExplanation.text = translations["nameAnswerExplanation"][lang]
    elseif position == 5 then
        answerBackRect.y = display.contentHeight*0.5417 + 2*display.contentHeight*0.09375
        whyRect.y = display.contentHeight*0.5886
        whyText.y = display.contentHeight*0.5886
        whyText.text = translations["color_word"][lang]
    elseif position == 7 then
        answerBackRect.y = display.contentHeight*0.5417
        whyRect.y = display.contentHeight*0.5417 + 2*display.contentHeight*0.09375
        whyText.y = display.contentHeight*0.5417 + 2*display.contentHeight*0.09375
        whyText.text = translations["word_color"][lang]
    elseif position == 9 then
        answerBackRect.y = display.contentHeight*0.5417 + display.contentHeight*0.09375
        whyRect.y = display.contentHeight*0.776
        whyText.y = display.contentHeight*0.776
        whyText.text = translations["color_color"][lang]
    elseif position == 11 then
        answerBackRect.y = display.contentHeight*0.5417 + display.contentHeight*0.09375
        whyRect.y = display.contentHeight*0.776
        whyText.y = display.contentHeight*0.776
        whyText.text = translations["word_word"][lang]
    end
    taskCircle.isVisible = positions[position][1]
    answerCircle.isVisible = positions[position][2]
    taskRectExplanation.isVisible = positions[position][3]
    answerRectExplanation.isVisible = positions[position][4]
    taskExplanation.isVisible = positions[position][5]
    answerExplanation.isVisible = positions[position][6]
    halfAnswerRect.isVisible = positions[position][7]
    halfAnswer.isVisible = positions[position][8]
    taskBackRect.isVisible = positions[position][9]
    answerBackRect.isVisible = positions[position][10]
    whyRect.isVisible = positions[position][11]
    whyText.isVisible = positions[position][12]
    blackWindow.isVisible = positions[position][13]
    positionText.text = position.." / "..#positions
end

local function sendToFront (object)
    sceneGroup:remove(object)
    frontGroup:insert(object)
end

local function sendToBack (object)
    frontGroup:remove(object)
    sceneGroup:insert(object)
    blackWindow:toFront()
end

local function chooseRight ()
    if position == 2 then
        sendToFront(taskLabel2)
        sendToFront(taskLabel)
    elseif position == 3 then
        sendToBack(taskLabel2)
        sendToBack(taskLabel)
    elseif position == 4 then
        sendToFront(taskLabel2)
        sendToFront(taskLabel)
        sendToFront(answersColored[2])
    elseif position == 5 then
        sendToBack(taskLabel2)
        sendToBack(taskLabel)
        sendToBack(answersColored[2])
        taskNum = 2
        setTable()
    elseif position == 6 then
        sendToFront(taskLabel2)
        sendToFront(taskLabel)
        sendToFront(answersColored[0])
    elseif position == 7 then
        sendToBack(taskLabel2)
        sendToBack(taskLabel)
        sendToBack(answersColored[0])
        taskNum = 3
        setTable()
    elseif position == 8 then
        sendToFront(taskLabel2)
        sendToFront(taskLabel)
        sendToFront(answersColored[1])
    elseif position == 9 then
        sendToBack(taskLabel2)
        sendToBack(taskLabel)
        sendToBack(answersColored[1])
        taskNum = 4
        setTable()
    elseif position == 10 then
        sendToFront(taskLabel2)
        sendToFront(taskLabel)
        sendToFront(answersColored[1])
    elseif position == 11 then
        sendToBack(taskLabel2)
        sendToBack(taskLabel)
        sendToBack(answersColored[1])
        taskNum = 1
        setTable()
    end

    if (position + 1) > #positions then
        position = 1
    else position = position + 1 end

    updateExplanation ()
end

local function chooseLeft ()
    if position == 1 then
        sendToFront(taskLabel2)
        sendToFront(taskLabel)
        sendToFront(answersColored[1])
        taskNum = 4
        setTable()
    elseif position == 3 then
        sendToBack(taskLabel2)
        sendToBack(taskLabel)
    elseif position == 4 then
        sendToFront(taskLabel2)
        sendToFront(taskLabel)
    elseif position == 5 then
        sendToBack(taskLabel2)
        sendToBack(taskLabel)
        sendToBack(answersColored[2])
    elseif position == 6 then
        sendToFront(taskLabel2)
        sendToFront(taskLabel)
        sendToFront(answersColored[2])
        taskNum = 1
        setTable()
    elseif position == 7 then
        sendToBack(taskLabel2)
        sendToBack(taskLabel)
        sendToBack(answersColored[0])
    elseif position == 8 then
        sendToFront(taskLabel2)
        sendToFront(taskLabel)
        sendToFront(answersColored[0])
        taskNum = 2
        setTable()
    elseif position == 9 then
        sendToBack(taskLabel2)
        sendToBack(taskLabel)
        sendToBack(answersColored[1])
    elseif position == 10 then
        sendToFront(taskLabel2)
        sendToFront(taskLabel)
        sendToFront(answersColored[1])
        taskNum = 3
        setTable()
    end

    if position == 1 then
        position = #positions
    else position = position - 1 end
    updateExplanation ()
end

-- create()
function scene:create( event )
    sceneGroup = self.view
    frontGroup = display.newGroup()
    uiGroup = display.newGroup()
    uiGroup:toFront()
    lang = composer.getVariable( "settingsTable" )[2]
    if lang == "en" then colors = require("colorsEN")
    elseif lang == "de" then colors = require("colorsDE")
    elseif lang == "ru" then colors = require("colorsRU") end

    --[[{ "ЗЕЛЁНЫЙ", 1} },
    { "КОРИЧНЕВЫЙ", 2 },
    { "ЧЁРНЫЙ", 3 },
    { "КРАСНЫЙ", 4 },
    { "ОРАНЖЕВЫЙ", 5 },
    { "ЖЁЛТЫЙ", 6 },
    { "СИНИЙ", 7 },
    { "ГОЛУБОЙ", 8 },
    { "СЕРЫЙ", 9 },
    { "ФИОЛЕТОВЫЙ", 10 },
    { "РОЗОВЫЙ", 11 }]]--

    tasks = { {colors[2][1], colors[5][2]}, {colors[8][1], colors[9][2]}, {colors[6][1], colors[1][2]}, {colors[11][1], colors[4][2]} }

    answers = {   { {colors[10][1], colors[5][2]}, {colors[6][1], colors[2][2]}, {colors[5][1], colors[11][2]}, {colors[2][1], colors[1][2]} },
                { {colors[4][1], colors[8][2]}, {colors[1][1], colors[9][2]}, {colors[9][1], colors[3][2]}, {colors[8][1], colors[7][2]} },
                { {colors[1][1], colors[9][2]}, {colors[8][1], colors[1][2]}, {colors[6][1], colors[11][2]}, {colors[2][1], colors[6][2]} },
                { {colors[4][1], colors[2][2]}, {colors[11][1], colors[8][2]}, {colors[3][1], colors[4][2]}, {colors[5][1], colors[11][2]} } }

    icons = { {false, true}, {true, false}, {false, false}, {true, true} }


    -- Code here runs when the scene is first created but has not yet appeared on screen
    local window = display.newRect( sceneGroup, display.contentCenterX,  display.contentCenterY,
    display.contentWidth, display.contentHeight+100 )
    window:setFillColor(1)


    answersRect = display.newRect( sceneGroup, display.contentCenterX, display.contentHeight*0.3646, 400, 1 )
    answersRect:setFillColor( 1 )
    answersRect.strokeWidth = 2
    answersRect:setStrokeColor( 0, 0, 0 )

    devider1 = display.newLine( sceneGroup, display.contentCenterX-100, display.contentHeight*0.5886, display.contentCenterX+100, display.contentHeight*0.5886 )
    devider1:setStrokeColor( 0.8 )
    devider1.strokeWidth = 1
    devider2 = display.newLine( sceneGroup, display.contentCenterX-100, display.contentHeight*0.6822, display.contentCenterX+100, display.contentHeight*0.6822 )
    devider2:setStrokeColor( 0.8 )
    devider2.strokeWidth = 1
    devider3 = display.newLine( sceneGroup, display.contentCenterX-100, display.contentHeight*0.776, display.contentCenterX+100, display.contentHeight*0.776 )
    devider3:setStrokeColor( 0.8 )
    devider3.strokeWidth = 1

    taskBackRect = display.newRect( frontGroup, display.contentCenterX,  display.contentHeight*0.177, 480, 85 )
    taskBackRect:setFillColor(1)
    taskBackRect.isVisible = false

    answerBackRect = display.newRect( frontGroup, display.contentCenterX,  display.contentHeight*0.177, 480, 85 )
    answerBackRect:setFillColor(1)
    answerBackRect.isVisible = false

    taskLabel2 = display.newText( sceneGroup, tasks[taskNum][1], display.contentCenterX+3, display.contentHeight*0.177+3, font, taskFontSize )
    taskLabel2:setFillColor(unpack(outlinecolor))
	taskLabel = display.newText( sceneGroup, tasks[taskNum][1], display.contentCenterX, display.contentHeight*0.177, font, taskFontSize )
    taskLabel:setFillColor(unpack(tasks[taskNum][2]))
	timerRect = display.newRect( sceneGroup, 0, 10, display.contentWidth*2*0.6, 20 )
	timerRect:setFillColor( 0, 0, 0 )
	countLabel = display.newText( sceneGroup, string.format( "%d / %d", 3, 7), 90, 50, font, timerFontSize-4 )
	countLabel:setFillColor( 0, 0, 0 )
    timerText = display.newText( sceneGroup, "15.0", 460, 50, font, timerFontSize )
    timerText:setFillColor( 0 )

    taskCircle = display.newCircle(frontGroup, display.contentCenterX-150, display.contentHeight*0.3125, 40)
    taskCircle:setFillColor(1)
    taskCircle.isVisible = false
    answerCircle = display.newCircle(frontGroup, display.contentCenterX-150, display.contentHeight*0.4167, 40)
    answerCircle:setFillColor(1)
    answerCircle.isVisible = false

    clrImgTask = display.newImage( frontGroup, "palette.png", display.contentCenterX-150, display.contentHeight*0.3125 )
    clrImgTask:scale(0.7, 0.7)
    clrImgTask:setFillColor( 0, 1 )
    clrImgTask.isVisible = not icons[taskNum][1]
    nameImgTask = display.newImage( frontGroup, "word.png", display.contentCenterX-150, display.contentHeight*0.3125  )
    nameImgTask:scale(0.7, 0.7)
    nameImgTask:setFillColor( 0, 1 )
    nameImgTask.isVisible = icons[taskNum][1]
    clrImgAnswers = display.newImage( frontGroup, "palette.png", display.contentCenterX-150, display.contentHeight*0.4167 )
    clrImgAnswers:scale(0.7, 0.7)
    clrImgAnswers:setFillColor( 0, 1 )
    clrImgAnswers.isVisible = not icons[taskNum][2]
    nameImgAnswers = display.newImage( frontGroup, "word.png", display.contentCenterX-150, display.contentHeight*0.4167 )
    nameImgAnswers:scale(0.7, 0.7)
    nameImgAnswers:setFillColor( 0, 1 )
    nameImgAnswers.isVisible = icons[taskNum][2]

    for i = 0,3 do
		answersColored[i] = display.newText( sceneGroup, answers[taskNum][i+1][1], display.contentCenterX, display.contentHeight*0.5417 + i*display.contentHeight*0.09375, font, answerSize )
		answersColored[i]:setFillColor( unpack(answers[taskNum][i+1][2]) )
	end

    blackWindow = display.newRect( sceneGroup, display.contentCenterX,  display.contentCenterY,
    display.contentWidth, display.contentHeight+100 )
    blackWindow:setFillColor(0, 0.55)
    blackWindow.isVisible = false
    blackRect = display.newRect( sceneGroup, display.contentCenterX,  display.contentHeight - 50,
    display.contentWidth, 100 )
    blackRect:setFillColor(0, 0.55)

    timerRect = display.newRect( sceneGroup, 0, 10, display.contentWidth*2*0.6, 20 )
	timerRect:setFillColor( 0, 0, 0 )

    taskRectExplanation = display.newRect( frontGroup, display.contentCenterX,  display.contentHeight*0.4167 + 40, 390, 170 )
    taskRectExplanation:setFillColor(1)
    taskRectExplanation.isVisible = false
    answerRectExplanation = display.newRect( frontGroup, display.contentCenterX,  display.contentHeight*0.3125 - 40, 390, 190 )
    answerRectExplanation:setFillColor(1)
    answerRectExplanation.isVisible = false

    taskExplanation = display.newText( frontGroup, translations["colorTaskExplanation"][lang], display.contentCenterX,  display.contentHeight*0.4167 + 40, font, 26 )
    taskExplanation:setFillColor( 0 )
    taskExplanation.isVisible = false
    answerExplanation = display.newText( frontGroup, " ", display.contentCenterX,  display.contentHeight*0.3125 - 40, font, 26 )
    answerExplanation:setFillColor( 0 )
    answerExplanation.isVisible = false

    halfAnswerRect = display.newRect( frontGroup, display.contentCenterX,  display.contentHeight*0.3125, 200, 85 )
    halfAnswerRect:setFillColor(1)
    halfAnswerRect.isVisible = false
    halfAnswer = display.newText( frontGroup,  translations["colorIsOrange"][lang], display.contentCenterX,  display.contentHeight*0.3125, font, 26 )
    halfAnswer:setFillColor( 0 )
    halfAnswer.isVisible = false

    whyRect = display.newRect( frontGroup, display.contentCenterX,  display.contentHeight*0.5886, 440, 170 )
    whyRect:setFillColor(1)
    whyRect.isVisible = false
    whyText = display.newText( frontGroup, " ", display.contentCenterX,  display.contentHeight*0.5886, font, 26 )
    whyText:setFillColor( 0 )
    whyText.isVisible = false


    local backImg = display.newImage( uiGroup, "cancel.png", 45, display.contentHeight - 50)
	backImg:setFillColor( 1 )
	backImg:scale(0.7, 0.7)
    backImg:addEventListener( "tap", function() composer.hideOverlay( "fade", 400 ) end)

    local instructionLeft = display.newImage( uiGroup, "left.png", display.contentCenterX-90, display.contentHeight - 50)
	instructionLeft:setFillColor( 1 )
	--instructionLeft:scale(0.95, 0.95)
	instructionLeft:addEventListener( "tap", chooseLeft )
	local instructionRight = display.newImage( uiGroup, "right.png", display.contentCenterX+90, display.contentHeight - 50)
	instructionRight:setFillColor( 1 )
	--instructionRight:scale(0.95, 0.95)
	instructionRight:addEventListener( "tap", chooseRight )
    positionText = display.newText( uiGroup, position.." / "..#positions, display.contentCenterX,  display.contentHeight - 50, font, 38 )
    positionText:setFillColor( 1 )




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
        frontGroup:removeSelf()
        uiGroup:removeSelf()
	elseif ( phase == "did" ) then
		-- Code here runs immediately after the scene goes entirely off screen

        composer.removeScene( "instruction" )
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
