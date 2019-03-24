
local composer = require( "composer" )
local widget = require( "widget" )
local toast = require('plugin.toast')
local scene = composer.newScene()

local sceneGroup

local firstback = true
local isGameOver = false
local bgcolor = {255/255, 255/255, 255/255}
local colorButton = {2/255, 218/255, 197/255}
local labeltextcolor = {1, 1, 1}
local textcolor = {0, 0, 0}
local outlinecolor = {0, 0, 0, 0.4}
local correctcolor = {46/255, 139/255, 87/255}
local wrongcolor = {220/255, 20/255, 60/255}
local font = "altridge.ttf"
local colors = require("colors")
local answersBlack = {}
local answersBlackArray = {}
local answersColored = {}
local answersColoredArray = {}
local answersTabs = {}
local answersTabbedArray = {}
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

local taskLabel2
local taskLabel
local schtrafLabel
local countLabel
local timerText
local timerRect
local countDownTimer
local nameImg
local clrImg

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
local filePath = system.pathForFile( "onebyone.json", system.DocumentsDirectory )
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
local function transition_2_black_task(text, obj)
    obj.text = text
    obj:setFillColor(unpack(textcolor))
    transition.to(obj,{time=150,alpha=1})
end
local function transition_2_colored_task(newcol, obj)
    obj.text = colors[newcol][1]
    obj:setFillColor(unpack(colors[newcol][2]))
    transition.to(obj,{time=150,alpha=1})
end
local function transition_2_tabbed_task(newcol, obj)
    obj:setFillColor(unpack(colors[newcol][2]))
    transition.to(obj,{time=150,alpha=1})
end

local function newTask()
    namenum = math.random(11)
    repeat
        colornum = math.random(11)
    until( namenum ~= colornum )
    return {namenum, colornum}
end
local function checkBlackAnswers(newValue, iteration)
    if newValue == colornum or newValue == namenum then
        --print("==")
        return false
    else
        if iteration == 0 then
            return true
        elseif iteration == 1 then
            if colors[newValue][1] == answersBlackArray[0] then
                --print("fail it 1, == 0: "..colors[newValue][1])
                return false
            else
                return true
            end
        elseif iteration == 2 then
            if colors[newValue][1] == answersBlackArray[0] or
                colors[newValue][1] == answersBlackArray[1] then
                --print("fail it 2, == 0 or 1: "..colors[newValue][1])
                return false
            else
                return true
            end
        elseif iteration == 3 then
            if colors[newValue][1] == answersBlackArray[0] or
                colors[newValue][1] == answersBlackArray[1] or
                colors[newValue][1] == answersBlackArray[2] then
                --print("fail it 3, == 0 or 1 or 2: "..colors[newValue][1])
                return false
            else
                return true
            end
        end
    end
end
local function newAnswersWorded(theanswer)
    local type = math.random(99)
    correct = math.random(4)-1
    repeat
        incorrect = math.random(4)-1
    until( incorrect ~= correct )
    --print( type )
    --print( "correct "..correct )
    --print( "incorrect "..incorrect )
    --print( "theanswer "..theanswer )
    if type < 49 then --answersBlack
        for i = 0, 3 do
            if i == correct then
                answersBlackArray[i] = colors[theanswer][1]
            elseif i == incorrect then
                answersBlackArray[i] = colors[colornum][1] --//
            else
                local newval
                repeat
                    newval = math.random(11)
                    answersBlackArray[i] = colors[newval][1]
                until( checkBlackAnswers(newval, i) )
            end
        end
        return {1, answersBlackArray}
    elseif type < 80 then
        for i = 0, 3 do
            if i == correct then
                answersBlackArray[i] = colors[theanswer][1]
                answersColoredArray[i] = theanswer
            elseif i == incorrect then
                answersBlackArray[i] = colors[colornum][1] --//
                answersColoredArray[i] = colornum --//
            else
                local newval
                repeat
                    newval = math.random(11)
                    answersBlackArray[i] = colors[newval][1]
                until( checkBlackAnswers(newval, i) )
                answersColoredArray[i] = newval
            end
        end
        return {2, answersColoredArray}
    elseif type < 100 then
        for i = 0, 3 do
            if i == correct then
                answersBlackArray[i] = colors[theanswer][1]
                answersTabbedArray[i] = theanswer
            elseif i == incorrect then
                answersBlackArray[i] = colors[colornum][1] --//
                answersTabbedArray[i] = colornum --//
            else
                local newval
                repeat
                    newval = math.random(11)
                    answersBlackArray[i] = colors[newval][1]
                until( checkBlackAnswers(newval, i) )
                answersTabbedArray[i] = newval
            end
        end
        return {3, answersTabbedArray}
    end
end
local function newAnswersColored(theanswer)
    local type = math.random(99)
    correct = math.random(4)-1
    repeat
        incorrect = math.random(4)-1
    until( incorrect ~= correct )
    --print( type )
    --print( "correct "..correct )
    --print( "incorrect "..incorrect )
    --print( "theanswer "..theanswer )
    if type < 49 then --answersBlack
        for i = 0, 3 do
            if i == correct then
                answersBlackArray[i] = colors[theanswer][1]
            elseif i == incorrect then
                answersBlackArray[i] = colors[namenum][1]
            else
                local newval
                repeat
                    newval = math.random(11)
                    answersBlackArray[i] = colors[newval][1]
                until( checkBlackAnswers(newval, i) )
            end
        end
        return {1, answersBlackArray}
    elseif type < 80 then
        for i = 0, 3 do
            if i == correct then
                answersBlackArray[i] = colors[theanswer][1]
                answersColoredArray[i] = theanswer
            elseif i == incorrect then
                answersBlackArray[i] = colors[namenum][1]
                answersColoredArray[i] = namenum
            else
                local newval
                repeat
                    newval = math.random(11)
                    answersBlackArray[i] = colors[newval][1]
                until( checkBlackAnswers(newval, i) )
                answersColoredArray[i] = newval
            end
        end
        return {2, answersColoredArray}
    elseif type < 100 then
        for i = 0, 3 do
            if i == correct then
                answersBlackArray[i] = colors[theanswer][1]
                answersTabbedArray[i] = theanswer
            elseif i == incorrect then
                answersBlackArray[i] = colors[namenum][1]
                answersTabbedArray[i] = namenum
            else
                local newval
                repeat
                    newval = math.random(11)
                    answersBlackArray[i] = colors[newval][1]
                until( checkBlackAnswers(newval, i) )
                answersTabbedArray[i] = newval
            end
        end
        return {3, answersTabbedArray}
    end
end
local function createNewTask()
    enableButton = true
    lvl = lvl + 1
    --print ("lvl "..lvl )
    local newtask = newTask()
    local nameid = newtask[1]
    local clrid = newtask[2] --task
    --print ("clrid "..clrid )
    local newAnswerArray
    if (lvl % 2) == 1 then
        newAnswerArray = newAnswersColored(clrid)
        nameImg.isVisible = false
        clrImg.isVisible = true
    else
        newAnswerArray = newAnswersWorded(nameid)
        nameImg.isVisible = true
        clrImg.isVisible = false
    end
    if lvl == 1 then
        --print ("lv1" )
        nametask = colors[nameid][1]
        taskLabel.text = nametask
        taskLabel2.text = nametask
        colortask = colors[clrid][2]
        taskLabel:setFillColor( unpack(colortask) )
        taskLabel2:setFillColor( unpack(outlinecolor) )
        if newAnswerArray[1] == 1 then
            for i = 0,3 do
                answersBlack[i].text = newAnswerArray[2][i]
                answersBlack[i].isVisible = true
            end
        elseif newAnswerArray[1] == 2 then
            local newcol
            for i = 0,3 do
                newcol = newAnswerArray[2][i]
                answersColored[i].text = colors[newcol][1]
                answersColored[i]:setFillColor(unpack( colors[newcol][2] ))
                answersColored[i].isVisible = true
            end
        elseif newAnswerArray[1] == 3 then
            local newcol
            for i = 0,3 do
                newcol = newAnswerArray[2][i]
                answersTabs[i]:setFillColor(unpack( colors[newcol][2] ))
                answersTabs[i].isVisible = true
            end
        end
    else --lvl ~= 1
        --print ("lvl ~= 1" )
        transition_2_task(nameid, clrid)
        if newAnswerArray[1] == 1 then
            for i = 0,3 do
                answersColored[i].isVisible = false
                answersBlack[i].isVisible = true
                answersTabs[i].isVisible = false
                transition_2_black_task(newAnswerArray[2][i], answersBlack[i])
            end
        elseif newAnswerArray[1] == 2 then
            local newcol
            for i = 0,3 do
                answersBlack[i].isVisible = false
                answersColored[i].size = answerSize
                answersColored[i].isVisible = true
                answersTabs[i].isVisible = false
                newcol = newAnswerArray[2][i]
                transition_2_colored_task(newcol, answersColored[i])
            end
        elseif newAnswerArray[1] == 3 then
            local newcol
            for i = 0,3 do
                answersBlack[i].isVisible = false
                answersColored[i].isVisible = false
                answersTabs[i].width  = answerWidth
                answersTabs[i].height  = answerHeight
                answersTabs[i].isVisible = true
                newcol = newAnswerArray[2][i]
                transition_2_tabbed_task(newcol, answersTabs[i])
            end
        end
    end
end

local function gameover(taskLabel, taskLabel2, countLabel, timerText, schtrafLabel, answersBlack, answersColored, answersTabs)
    isGameOver = true
    transition.cancel()
    taskLabel:removeSelf()
    taskLabel2:removeSelf()
    countLabel:removeSelf()
    timerText:removeSelf()
    nameImg:removeSelf()
    clrImg:removeSelf()
    schtrafLabel:removeSelf()
    for i = 0,3 do
        answersBlack[i]:removeSelf()
        answersColored[i]:removeSelf()
        answersTabs[i]:removeSelf()
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
        gameover(taskLabel, taskLabel2, countLabel, timerText, schtrafLabel, answersBlack, answersColored, answersTabs)
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
        gameover(taskLabel, taskLabel2, countLabel, timerText, schtrafLabel, answersBlack, answersColored, answersTabs)
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
        if event.target.alias == "black" then
            --print("black")
            if event.target.nummer == correct then
                event.target:setFillColor(unpack(correctcolor))
                recht()
            else
                event.target:setFillColor(unpack(wrongcolor))
                falsch()
                schtrafen()
            end
            for i = 0,3 do
                transition.to(answersBlack[i],{time=300,alpha=0.0})
            end

        elseif event.target.alias == "colored" then
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

        elseif event.target.alias == "tabbed" then
            --print("tabbed")
            if event.target.nummer == correct then
                event.target.width  = answerWidth + 20
                event.target.height  = answerHeight + 20
                recht()
            else
                event.target.width  = answerWidth - 20
                event.target.height  = answerHeight - 20
                falsch()
                schtrafen()
            end
            for i = 0,3 do
                transition.to(answersTabs[i],{time=300,alpha=0.0})
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
	taskLabel2 = display.newText( sceneGroup, "", display.contentCenterX+3, 277, font, taskFontSize )
	taskLabel = display.newText( sceneGroup, "", display.contentCenterX, 280, font, taskFontSize )
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
    clrImg = display.newImage( sceneGroup, "palette.png", display.contentCenterX-70, 190 )
    clrImg:scale(0.7, 0.7)
    clrImg:setFillColor( 0, 1 )
    clrImg.isVisible = false
    nameImg = display.newImage( sceneGroup, "word.png", display.contentCenterX+70, 190 )
    nameImg:scale(0.7, 0.7)
    nameImg:setFillColor( 0, 1 )
    nameImg.isVisible = false
    countDownTimer = timer.performWithDelay( 30, function() updateCountDown(timerRect, timerText, countDownTimer) end, 0 )

	for i = 0,3 do
		answersBlack[i] = display.newText( sceneGroup, "ответ"..i, display.contentCenterX, 520 + i*90, font, answerSize )
		answersBlack[i]:setFillColor( unpack(textcolor) )
		answersBlack[i].nummer = i
		answersBlack[i].alias = "black"
		answersBlack[i].isVisible = false
		answersBlack[i]:addEventListener( "tap", answer )
	end
	for i = 0,3 do
		answersColored[i] = display.newText( sceneGroup, "ответ"..i, display.contentCenterX, 520 + i*90, font, answerSize )
		answersColored[i]:setFillColor( unpack(textcolor) )
		answersColored[i].nummer = i
		answersColored[i].alias = "colored"
		answersColored[i].isVisible = false
		answersColored[i]:addEventListener( "tap", answer )
	end
	for i = 0,3 do
		answersTabs[i] = display.newRect( sceneGroup, display.contentCenterX, 520 + i*90, answerWidth, answerHeight )
		answersTabs[i].nummer = i
		answersTabs[i].alias = "tabbed"
		answersTabs[i].isVisible = false
		answersTabs[i].strokeWidth = 1
		answersTabs[i]:setStrokeColor( 0, 0, 0, 0.2 )
		answersTabs[i]:addEventListener( "tap", answer )
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
                    gameover(taskLabel, taskLabel2, countLabel, timerText, schtrafLabel, answersBlack, answersColored, answersTabs)
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

		composer.removeScene( "mode3" )
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
