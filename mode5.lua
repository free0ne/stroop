
local composer = require( "composer" )
local widget = require( "widget" )
local toast = require('plugin.toast')
local scene = composer.newScene()

local sceneGroup

local firstback = true
local isGameOver = false
local bgcolor = {255/255, 255/255, 255/255}
local colorButton = {2/255, 218/255, 197/255}
local colorButtonTr = {75/255, 157/255, 180/255, 0.2}
local labeltextcolor = {1, 1, 1}
local textcolor = {0, 0, 0}
local outlinecolor = {0, 0, 0, 0.4}
local correctcolor = {46/255, 139/255, 87/255}
local wrongcolor = {220/255, 20/255, 60/255}
local font = "altridge.ttf"
local colors = require("colors")
local answersColored = {}
local answersColoredArray = {}
local nametask
local colortask
local namenum
local colornum
local correct
local incorrect
local lvl
local answerSize = 50
local answerHeight = 70
local answerWidth = display.contentWidth - 250
local taskFontSize = 58
local enableButton = false

--hardcore
local theTask
local answersRect
local taskType
local positionsOfValuesFromTask
local totalIds
local devider1
local devider2
local devider3
--hardcore
local taskLabel2
local taskLabel
local schtrafLabel
local countLabel
local timerText
local timerRect
local countDownTimer
local nameImgTask
local clrImgTask
local nameImgAnswers
local clrImgAnswers

--timer
local basetime = 25.0
local timeleft
local schtraf = 1.25
local timerFontSize = 44

--counter
local corrects
local total

--GOver scene
local gameOverLabel1
local gameOverLabel2
local gameOverCurr1
local gameOverCurr2
local gameOverHighScore1
local gameOverHighScore2
local recordsCircle
local recordsImage
local restartGame
local restartImage
local toMenu
local toMenuImage

--FUNCTIONS
local restartLevel
local goToMenu

--SCORES
local json = require( "json" )
local scoresTable = {}
local filePath = system.pathForFile( "random.json", system.DocumentsDirectory )
local loadScores
local saveScores

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------
loadScores = function()
    local file = io.open( filePath, "r" )
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
saveScores = function()
    for i = #scoresTable, 11, -1 do
        table.remove( scoresTable, i )
    end
    local file = io.open( filePath, "w" )
    if file then
        file:write( json.encode( scoresTable ) )
        io.close( file )
    end
end
local function compare( a, b )
    if a[1] > b[1] then
        return a
    end
end
local function openHSTable()
    composer.showOverlay( "HSTable" , {
      isModal = true,
      effect = "fade",
      time = 400,
    } )
end

local function backTimer( event )
    firstback = true
end

local function transition_2_task(nameid, clrid)
    taskLabel.text = colors[nameid][1]
    taskLabel:setFillColor(unpack(colors[clrid][2]))
    taskLabel2.text = colors[nameid][1]
    taskLabel2:setFillColor(unpack(outlinecolor))

    transition.to(taskLabel,{time=150,alpha=1})
    transition.to(taskLabel2,{time=150,alpha=1})
end
local function transition_2_colored_task(wrd, clr, obj)
    obj.text = colors[wrd][1]
    obj:setFillColor(unpack(colors[clr][2]))
    transition.to(obj,{time=150,alpha=1})
end

local function newTask()
    namenum = math.random(11)
    repeat
        colornum = math.random(11)
    until( namenum ~= colornum )
    return {namenum, colornum}
end

--GENIUNE: CfC CfW WfC WfW
local function setGenuine(corr, type)
    print("GENUINE: ")
    local array = {}
    local setted = {false, false, false, false}
    corr = corr + 1
    array[corr] = type
    type = type + 1
    print("TYPE = "..type)
    setted[type] = true
    local attempt
    for i = 1,4 do
        if i ~= corr then
            repeat
                attempt = math.random(4)-1
            until( setted[attempt+1] == false )
            array[i] = attempt
            setted[attempt+1] = true
        end
    end
    local newWords = {}
    local newColors = {}
    for i = 1, 4 do
        if array[i] == 0 then     newColors[i-1] = theTask[2]
        elseif array[i] == 1 then newWords[i-1] = theTask[2]
        elseif array[i] == 2 then newColors[i-1] = theTask[1]
        elseif array[i] == 3 then newWords[i-1] = theTask[1]
        end
    end
    for i = 0,3 do
        if newColors[i] == nil then newColors[i] = totalIds[2 + table.indexOf( positionsOfValuesFromTask, i )] end
        if newWords[i] == nil then newWords[i] = totalIds[2 + table.indexOf( positionsOfValuesFromTask, i )] end
    end
    return {newColors, newWords}
end


local function newAnswers()
    local type = math.random(99)
    correct = math.random(4)-1
    print( "correct "..correct )

    local newWords = {}
    local newColors = {}

    totalIds = {theTask[1], theTask[2]}
    local fillerId
    for i = 1,4 do
        repeat
            fillerId = math.random(11)
        until( table.indexOf(totalIds, fillerId) == nil )
        table.insert( totalIds, fillerId )
    end
    for i = 1,6 do
        print(i.." "..totalIds[i])
    end

    print("positions:")

    positionsOfValuesFromTask = {}
    table.insert(positionsOfValuesFromTask, math.random(4)-1)
    local positionFiller
    for i = 2,4 do
        repeat
            positionFiller = math.random(4)-1
        until( table.indexOf(positionsOfValuesFromTask, positionFiller) == nil )
        table.insert( positionsOfValuesFromTask, positionFiller )
    end
    --print( type )
    --print( "correct "..correct )
    --print( "incorrect "..incorrect )
    --print( "theanswer "..theanswer )

    --GENIUNE[1-4]: CfC CfW WfC WfW (0-3)
    if type < 25 then -- Color - Color
        taskType = 0
        local genuines = setGenuine(correct, taskType)
        newColors = genuines[1]
        newWords = genuines[2]
        print( "correct = "..correct)
        print(type..", Color - Color")
        --for i = 0,3 do
            --print( "ColorID: "..newColors[i].."; WordID: "..newWords[i])
        --end
        return {taskType, newColors, newWords}
    elseif type > 24 and type < 50 then -- Color - Word
        taskType = 1
        local genuines = setGenuine(correct, taskType)
        newColors = genuines[1]
        newWords = genuines[2]
        print(type..", Color - Word")
        return {taskType, newColors, newWords}
    elseif type > 49 and type < 75 then -- Word - Color
        taskType = 2
        local genuines = setGenuine(correct, taskType)
        newColors = genuines[1]
        newWords = genuines[2]
        print(type..", Word - Color")
        return {taskType, newColors, newWords}
    elseif type < 100 then -- Word - Word
        taskType = 3
        local genuines = setGenuine(correct, taskType)
        newColors = genuines[1]
        newWords = genuines[2]
        print(type..", Word - Word")
        return {taskType, newColors, newWords}
    end
end
local function createNewTask()
    enableButton = true
    lvl = lvl + 1
    --print ("lvl "..lvl )
    local newtask = newTask()
    theTask = newtask
    local nameid = newtask[1]
    local clrid = newtask[2]
    print ("nameid "..nameid )
    print ("clrid "..clrid )
    local newAnswerArray
    --0: C-C 1: C-W 2: W-C 3: W-W
    newAnswerArray = newAnswers()
    local answColors = newAnswerArray[2]
    local answWords = newAnswerArray[3]
    --print("newAnswerArray[1] = "..newAnswerArray[1])
    local newX1 = math.random(100, 440)
    local newX2 = math.random(100, 440)
    nameImgTask.x = newX1
    clrImgTask.x = newX1
    nameImgAnswers.x = newX2
    clrImgAnswers.x = newX2
    if newAnswerArray[1] == 0 then
        nameImgTask.isVisible = false
        clrImgTask.isVisible = true
        nameImgAnswers.isVisible = false
        clrImgAnswers.isVisible = true
    elseif newAnswerArray[1] == 1 then
        nameImgTask.isVisible = false
        clrImgTask.isVisible = true
        nameImgAnswers.isVisible = true
        clrImgAnswers.isVisible = false
    elseif newAnswerArray[1] == 2 then
        nameImgTask.isVisible = true
        clrImgTask.isVisible = false
        nameImgAnswers.isVisible = false
        clrImgAnswers.isVisible = true
    elseif newAnswerArray[1] == 3 then
        nameImgTask.isVisible = true
        clrImgTask.isVisible = false
        nameImgAnswers.isVisible = true
        clrImgAnswers.isVisible = false
    end
    --nameImg.isVisible = false
    --clrImg.isVisible = true
    if lvl == 1 then
        --print ("lv1" )
        nametask = colors[nameid][1]
        taskLabel.text = nametask
        taskLabel2.text = nametask
        colortask = colors[clrid][2]
        taskLabel:setFillColor( unpack(colortask) )
        taskLabel2:setFillColor( unpack(outlinecolor) )
        for i = 0,3 do
            answersColored[i].text = colors[answWords[i]][1]
            answersColored[i]:setFillColor(unpack( colors[answColors[i]][2] ))
            answersColored[i].isVisible = true
        end
    else --lvl ~= 1
        --print ("lvl ~= 1" )
        transition_2_task(nameid, clrid)
        for i = 0,3 do
            answersColored[i].size = answerSize
            answersColored[i].isVisible = true
            transition_2_colored_task(answWords[i], answColors[i], answersColored[i])
        end
    end
end

local function gameover(taskLabel, taskLabel2, countLabel, timerText, schtrafLabel, answersColored)
    isGameOver = true
    transition.cancel()
    answersRect:removeSelf()
    taskLabel:removeSelf()
    taskLabel2:removeSelf()
    countLabel:removeSelf()
    devider1:removeSelf()
    devider2:removeSelf()
    devider3:removeSelf()
    timerText:removeSelf()
    nameImgTask:removeSelf()
    clrImgTask:removeSelf()
    nameImgAnswers:removeSelf()
    clrImgAnswers:removeSelf()
    schtrafLabel:removeSelf()
    for i = 0,3 do
        answersColored[i]:removeSelf()
    end
end

local function showGOTable()

    loadScores()
    local date = os.date( "*t" )
    local dateString = date.day.."."..date.month.."."..date.year
    table.insert( scoresTable, {corrects, dateString} )
    table.sort( scoresTable, compare )
    saveScores()
    composer.setVariable( "scoresTable", scoresTable )

    gameOverLabel1 = display.newText( sceneGroup, "GAME", display.contentCenterX, 210, font, 70 )
    gameOverLabel1:setFillColor( 0, 0, 0, 1.0 )
    gameOverLabel2 = display.newText( sceneGroup, "OVER", display.contentCenterX, 290, font, 70 )
    gameOverLabel2:setFillColor( 0, 0, 0, 1.0 )
    gameOverCurr1 = display.newText( sceneGroup, "СЧЁТ", display.contentCenterX, 430, font, 52 )
    gameOverCurr1:setFillColor( 0, 0, 0, 1.0 )
    gameOverCurr2 = display.newText( sceneGroup, corrects.." из "..total, display.contentCenterX, 500, font, 52 )
    gameOverCurr2:setFillColor( 0, 0, 0, 1.0 )
    gameOverHighScore1 = display.newText( sceneGroup, "РЕКОРД", display.contentCenterX, 620, font, 52 )
    gameOverHighScore1:setFillColor( 0, 0, 0, 1.0 )
    gameOverHighScore2 = display.newText( sceneGroup, scoresTable[1][1], display.contentCenterX, 690, font, 52 )
    gameOverHighScore2:setFillColor( 0, 0, 0, 1.0 )

    recordsCircle = display.newCircle( sceneGroup, display.contentCenterX + 200, 70, 55 )
    recordsCircle:setFillColor( unpack (colorButton) )
    recordsCircle:addEventListener( "tap", openHSTable )
    recordsImage = display.newImage( sceneGroup, "list.png", display.contentCenterX + 200, 70 )
    recordsImage:scale(0.8, 0.8)

    restartGame = display.newRect( sceneGroup, display.contentCenterX - 120, display.contentCenterY + 370, 180, 130 )
    restartGame:setFillColor( unpack (colorButton) )
    restartGame:addEventListener( "tap", restartLevel )
    restartImage = display.newImage( sceneGroup, "refresh.png", display.contentCenterX - 120, display.contentCenterY + 370 )

    toMenu = display.newRect( sceneGroup, display.contentCenterX + 120, display.contentCenterY + 370, 180, 130 )
    toMenu:setFillColor( unpack (colorButton) )
    toMenu:addEventListener( "tap", goToMenu )
    toMenuImage = display.newImage( sceneGroup, "menu.png", display.contentCenterX + 120, display.contentCenterY + 370 )

end

local function removeGOTable()
    gameOverLabel1:removeSelf()
    gameOverLabel2:removeSelf()
    gameOverCurr1:removeSelf()
    gameOverCurr2:removeSelf()
    gameOverHighScore1:removeSelf()
    gameOverHighScore2:removeSelf()
    recordsCircle:removeSelf()
    recordsImage:removeSelf()
    restartGame:removeSelf()
    restartImage:removeSelf()
    toMenu:removeSelf()
    toMenuImage:removeSelf()
end

local function updateCountDown( rect, text, timerCD )
    timeleft = timeleft - 0.03
    local timeDisplay = string.format( "%2.1f", timeleft )
    rect.width = (1 - ((basetime - timeleft)/ basetime)) * display.contentWidth * 2

    if timeleft <= 0 then
        timer.cancel( timerCD )
        gameover(taskLabel, taskLabel2, countLabel, timerText, schtrafLabel, answersColored)
        showGOTable()
        timeleft = 0
        timeDisplay = "0.0"
        timerRect.width = 0
    end
    text.text = timeDisplay
end

local function recht()
    corrects = corrects + 1
    total = total + 1
    countLabel.text = string.format( "%d / %d", corrects, total)
end
local function falsch()
    total = total + 1
    countLabel.text = string.format( "%d / %d", corrects, total)
end
local function schtrafen()
    print ("schtrafen")
    system.vibrate()
    timeleft = timeleft - schtraf
    schtrafLabel:setFillColor( 1, 0, 0, 0.7 )
    schtrafLabel.alpha = 1
    transition.to(schtrafLabel,{time=500,alpha=0})
    timerRect:setFillColor( 1, 0, 0, 0.7 )
    --transition.to(schtrafLabel,{time=500,alpha=0})
    transition.to( timerRect.fill, { r=0, g=0, b=0, a=1, time=400, transition=easing.inCubic })
    if timeleft <= 0 then
        timer.cancel( countDownTimer )
        gameover(taskLabel, taskLabel2, countLabel, timerText, schtrafLabel, answersColored)
        showGOTable()
        timeleft = 0
        timeDisplay = "0.0"
        timerRect.width = 0
    end
    timerText.text = timeDisplay
end
local function answer( event )
    if enableButton == true then
        enableButton = false
        transition.to(taskLabel,{time=300,alpha=0.0,onComplete = createNewTask})
        transition.to(taskLabel2,{time=300,alpha=0.0})
        if event.target.alias == "colored" then
            --print("colored")
            if event.target.nummer == correct then
                event.target.size = answerSize + 7
                recht()
            else
                event.target.size = answerSize - 12
                falsch()
                schtrafen()
            end
            for i = 0,3 do
                transition.to(answersColored[i],{time=300,alpha=0.0})
            end
        end
    end
end

local function setField()
    isGameOver = false
    timeleft = basetime
    lvl = 0
    corrects = 0
    total = 0
    answersRect = display.newRect( sceneGroup, display.contentCenterX, 350, 400, 1 )
    answersRect:setFillColor( unpack( bgcolor ) )
    answersRect.strokeWidth = 2
    answersRect:setStrokeColor( 0, 0, 0 )

    devider1 = display.newLine( sceneGroup, display.contentCenterX-100, 565, display.contentCenterX+100, 565 )
    devider1:setStrokeColor( 0.8 )
    devider1.strokeWidth = 1
    devider2 = display.newLine( sceneGroup, display.contentCenterX-100, 655, display.contentCenterX+100, 655 )
    devider2:setStrokeColor( 0.8 )
    devider2.strokeWidth = 1
    devider3 = display.newLine( sceneGroup, display.contentCenterX-100, 745, display.contentCenterX+100, 745 )
    devider3:setStrokeColor( 0.8 )
    devider3.strokeWidth = 1


	taskLabel2 = display.newText( sceneGroup, "", display.contentCenterX+3, display.contentCenterY - 307, font, taskFontSize )
	taskLabel = display.newText( sceneGroup, "", display.contentCenterX, display.contentCenterY - 310, font, taskFontSize )
	schtrafLabel = display.newText( sceneGroup, "-1.25", 450, 90, font, timerFontSize+4 )
	schtrafLabel:setFillColor( 1, 0, 0, 0.0 )
	timerRect = display.newRect( sceneGroup, 0, 10, display.contentWidth*2, 20 )
	timerRect:setFillColor( 0, 0, 0 )
	countLabel = display.newText( sceneGroup, string.format( "%d / %d", corrects, total), 90, 50, font, timerFontSize-4 )
	countLabel:setFillColor( 0, 0, 0 )
    timerText = display.newText( "25.0", 460, 50, font, timerFontSize )
    timerText:setFillColor( unpack(textcolor) )
    local paintClr = {
        type = "gradient",
        color1 = { 176/255, 77/255,160/255,1 },
        color2 = { 227/255, 217/255, 218/255, 1 },--    { 43/255, 122/255, 165/255, 1 },
        direction = "down"
    }
    local paintName = {
        type = "gradient",
        color1 = { 43/255, 122/255, 165/255, 1 },
        color2 = { 226/255, 252/255, 241/255, 1 },
        direction = "down"
    }
    clrImgTask = display.newImage( sceneGroup, "palette.png", display.contentCenterX-70, 300 )
    clrImgTask:scale(0.7, 0.7)
    clrImgTask:setFillColor( 0, 1 )
    clrImgTask.isVisible = false
    nameImgTask = display.newImage( sceneGroup, "word.png", display.contentCenterX+70, 300 )
    nameImgTask:scale(0.7, 0.7)
    nameImgTask:setFillColor( 0, 1 )
    nameImgTask.isVisible = false
    clrImgAnswers = display.newImage( sceneGroup, "palette.png", display.contentCenterX-70, 400 )
    clrImgAnswers:scale(0.7, 0.7)
    clrImgAnswers:setFillColor( 0, 1 )
    clrImgAnswers.isVisible = false
    nameImgAnswers = display.newImage( sceneGroup, "word.png", display.contentCenterX+70, 400 )
    nameImgAnswers:scale(0.7, 0.7)
    nameImgAnswers:setFillColor( 0, 1 )
    nameImgAnswers.isVisible = false
    countDownTimer = timer.performWithDelay( 30, function() updateCountDown(timerRect, timerText, countDownTimer) end, 0 )

	for i = 0,3 do
		answersColored[i] = display.newText( sceneGroup, "ответ"..i, display.contentCenterX, 520 + i*90, font, answerSize )
		answersColored[i]:setFillColor( unpack(textcolor) )
		answersColored[i].nummer = i
		answersColored[i].alias = "colored"
		answersColored[i].isVisible = false
		answersColored[i]:addEventListener( "tap", answer )
	end
	createNewTask()
end

restartLevel = function ( event )
    removeGOTable()
    setField()
end
goToMenu = function ( event )
    composer.gotoScene( "menu" )
end



local function onKeyEvent( event )
    if (event.phase == "down" and event.keyName == "back" ) then
        if ( system.getInfo("platform") == "android" ) then
            if firstback == true then
                firstback = false
                timer.performWithDelay( 1500, backTimer )
                toast.show('Нажмите ещё раз, чтобы выйти в меню')
                return true
            else
                if isGameOver == false then
                    timer.cancel( countDownTimer )
                    gameover(taskLabel, taskLabel2, countLabel, timerText, schtrafLabel, answersColored)
                end
                composer.gotoScene( "menu" )
                return true
            end

            return true
        end
    end
    return false
end
Runtime:addEventListener( "key", onKeyEvent )

-- create()
function scene:create( event )
	display.setStatusBar( display.HiddenStatusBar )
	sceneGroup = self.view
	-- Code here runs when the scene is first created but has not yet appeared on screen
	math.randomseed( os.time() )

	display.setDefault( "background", unpack( bgcolor ) )

    setField()

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
		--if countDownTimer ~= nil then
		--	timer.cancel( countDownTimer )
		--end

		composer.removeScene( "mode5" )
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
