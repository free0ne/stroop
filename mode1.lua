
local composer = require( "composer" )
local widget = require( "widget" )
local toast = require('plugin.toast')

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------




-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )
	display.setStatusBar( display.HiddenStatusBar )
	local sceneGroup = self.view
	-- Code here runs when the scene is first created but has not yet appeared on screen
	local bgcolor = {255/255, 255/255, 255/255}
	local colorButton = {2/255, 218/255, 197/255}
	local labeltextcolor = {1, 1, 1}
	local textcolor = {0, 0, 0}
	local outlinecolor = {0, 0, 0, 0.4}
	local correctcolor = {46/255, 139/255, 87/255}
	local wrongcolor = {220/255, 20/255, 60/255}
	local font = "geometos.ttf"
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
	local lvl = 0
	local answerSize = 50
	local answerHeight = 70
	local answerWidth = display.contentWidth - 250
	local taskFontSize = 58

	--timer
	local basetime = 25.0
	local timeleft = 25.0
	local schtraf = 1
	local timerText
	local countDownTimer
	local timerFontSize = 44

	--counter
	local corrects = 0
	local total = 0

	math.randomseed( os.time() )

	display.setDefault( "background", unpack( bgcolor ) )

	local startGame = display.newRect( sceneGroup, display.contentCenterX, display.contentCenterY + 370, display.contentWidth-140, 130 )
	startGame:setFillColor( unpack (colorButton) )
	local tutorialLabel = display.newText( sceneGroup,
    	"в данном режиме нужно определить, какого цвета слова, указанные в задании, и выбрать соответствующий вариант ответа\n\nвремя: 25 сек\nштраф: -1 сек",
    	display.contentCenterX, display.contentCenterY-40, display.contentWidth-120, 550, font, 35 )
	tutorialLabel:setFillColor( unpack(textcolor) )
	local startLabel = display.newText( sceneGroup, "ок, поехали!", display.contentCenterX, display.contentCenterY + 370, font, 40 )
	startLabel:setFillColor( unpack(labeltextcolor) )

	local taskLabel2 = display.newText( sceneGroup, "", display.contentCenterX+3, display.contentCenterY - 297, font, taskFontSize )
	local taskLabel = display.newText( sceneGroup, "", display.contentCenterX, display.contentCenterY - 300, font, taskFontSize )
	local schtrafLabel = display.newText( sceneGroup, "-1", 500, 50, font, timerFontSize+4 )
	schtrafLabel:setFillColor( 1, 0, 0, 0.0 )
	local timerRect = display.newRect( sceneGroup, 0, 10, display.contentWidth*2, 20 )
	timerRect:setFillColor( 0, 0, 0, 0)
	local countLabel = display.newText( sceneGroup, string.format( "%d / %d", corrects, total), 90, 50, font, timerFontSize-4 )
	countLabel:setFillColor( 0, 0, 0, 0.0 )


	local function gameover()
		transition.cancel()
		taskLabel:removeSelf()
		taskLabel2:removeSelf()
		countLabel:removeSelf()
		timerText:removeSelf()
		schtrafLabel:removeSelf()
		for i = 0,3 do
			answersBlack[i]:removeSelf()
			answersColored[i]:removeSelf()
			answersTabs[i]:removeSelf()
		end
		local gameOverLabel1 = display.newText( sceneGroup, "game", display.contentCenterX, 210, font, 70 )
		gameOverLabel1:setFillColor( 0, 0, 0, 1.0 )
		local gameOverLabel2 = display.newText( sceneGroup, "over", display.contentCenterX, 290, font, 70 )
		gameOverLabel2:setFillColor( 0, 0, 0, 1.0 )
		local gameOverCurr1 = display.newText( sceneGroup, "счет", display.contentCenterX, 430, font, 52 )
		gameOverCurr1:setFillColor( 0, 0, 0, 1.0 )
		local gameOverCurr2 = display.newText( sceneGroup, corrects.." из "..total, display.contentCenterX, 500, font, 52 )
		gameOverCurr2:setFillColor( 0, 0, 0, 1.0 )
		local gameOverHighScore1 = display.newText( sceneGroup, "рекорд", display.contentCenterX, 620, font, 52 )
		gameOverHighScore1:setFillColor( 0, 0, 0, 1.0 )
		local gameOverHighScore2 = display.newText( sceneGroup, "7", display.contentCenterX, 690, font, 52 )
		gameOverHighScore2:setFillColor( 0, 0, 0, 1.0 )

		local restartGame = display.newRect( sceneGroup, display.contentCenterX, display.contentCenterY + 370, display.contentWidth-140, 130 )
		restartGame:setFillColor( unpack (colorButton) )
		local restartLabel = display.newText( sceneGroup, "заново", display.contentCenterX, display.contentCenterY + 370, font, 40 )
		restartLabel:setFillColor( unpack(labeltextcolor) )
	end

	local function updateCountDown( event )
	    timeleft = timeleft - 0.03
	    local timeDisplay = string.format( "%2.1f", timeleft )
		timerRect.width = (1 - ((basetime - timeleft)/ basetime)) * display.contentWidth * 2

		if timeleft <= 0 then
			timer.cancel( countDownTimer )
			gameover()
			timeleft = 0
			timeDisplay = "0.0"
			timerRect.width = 0
		end
		timerText.text = timeDisplay



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
			gameover()
			timeleft = 0
			timeDisplay = "0.0"
			timerRect.width = 0
		end
		timerText.text = timeDisplay
	end

	local function newTask()
		namenum = math.random(11)
		colornum = math.random(11)
		return {namenum, colornum}
	end

	local function checkBlackAnswers(newValue, iteration)
		if newValue == colornum then
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

	local function newAnswers(theanswer)
		local type = math.random(99)
		correct = math.random(4)-1
		--print( type )
		print( "correct "..correct )
		--print( "theanswer "..theanswer )
		if type < 49 then --answersBlack
			for i = 0, 3 do
				if i == correct then
					answersBlackArray[i] = colors[theanswer][1]
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
		--else if type < 67 then

		--  else

	end

	local function transition_2_task(nameid, clrid)
		taskLabel.text = colors[nameid][1]
		taskLabel:setFillColor(unpack(colors[clrid][2]))
		taskLabel2.text = colors[nameid][1]
		taskLabel2:setFillColor(unpack(outlinecolor))

		transition.to(taskLabel,{time=300,alpha=1})
		transition.to(taskLabel2,{time=300,alpha=1})
	end

	local function transition_2_black_task(text, obj)
		obj.text = text
		obj:setFillColor(unpack(textcolor))
		transition.to(obj,{time=300,alpha=1})
	end
	local function transition_2_colored_task(newcol, obj)
		obj.text = colors[newcol][1]
		obj:setFillColor(unpack(colors[newcol][2]))
		transition.to(obj,{time=300,alpha=1})
	end
	local function transition_2_tabbed_task(newcol, obj)
		obj:setFillColor(unpack(colors[newcol][2]))
		transition.to(obj,{time=300,alpha=1})
	end

	local function createNewTask()
		lvl = lvl + 1
		print ("lvl "..lvl )
		local newtask = newTask()
		local nameid = newtask[1]
		local clrid = newtask[2] --task
		--print ("clrid "..clrid )
		local newAnswerArray = newAnswers(clrid)

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

	local function recht()
		corrects = corrects + 1
		total = total + 1
		countLabel.text = string.format( "%d / %d", corrects, total)
	end
	local function falsch()
		total = total + 1
		countLabel.text = string.format( "%d / %d", corrects, total)
	end

	local function answer( event )
		transition.to(taskLabel,{time=300,alpha=0.0,onComplete = createNewTask})
		transition.to(taskLabel2,{time=300,alpha=0.0})
        if event.target.alias == "black" then
			print("black")
			if event.target.nummer == correct then
				event.target:setFillColor(unpack(correctcolor))
				recht()
			else
				event.target:setFillColor(unpack(wrongcolor))
				schtrafen()
				falsch()
			end
			for i = 0,3 do
				transition.to(answersBlack[i],{time=300,alpha=0.0})
			end

		elseif event.target.alias == "colored" then
			print("colored")
			if event.target.nummer == correct then
				event.target.size = answerSize + 7
				recht()
			else
				event.target.size = answerSize - 12
				schtrafen()
				falsch()
			end
			for i = 0,3 do
				transition.to(answersColored[i],{time=300,alpha=0.0})
			end

		elseif event.target.alias == "tabbed" then
			print("tabbed")
			if event.target.nummer == correct then
				event.target.width  = answerWidth + 20
				event.target.height  = answerHeight + 20
				recht()
			else
				event.target.width  = answerWidth - 20
				event.target.height  = answerHeight - 20
				schtrafen()
				falsch()
			end
			for i = 0,3 do
				transition.to(answersTabs[i],{time=300,alpha=0.0})
			end

		end
    end

	local function gameStart( event )
		startGame:removeSelf()
		tutorialLabel:removeSelf()
		startLabel:removeSelf()
		timerText = display.newText( "25.0", 430, 50, font, timerFontSize )
		timerText:setFillColor( unpack(textcolor) )
		countDownTimer = timer.performWithDelay( 30, updateCountDown, 0 )
		timerRect:setFillColor( 0, 0, 0)
		countLabel:setFillColor( 0, 0, 0)
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
			--answersTabs[i]:setFillColor( unpack(textcolor) )
			answersTabs[i].nummer = i
			answersTabs[i].alias = "tabbed"
			answersTabs[i].isVisible = false
			answersTabs[i].strokeWidth = 1
			answersTabs[i]:setStrokeColor( 0, 0, 0, 0.2 )
			answersTabs[i]:addEventListener( "tap", answer )
		end
		createNewTask()
	end

	startGame:addEventListener( "tap", gameStart )

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
