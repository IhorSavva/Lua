---------------------------------------------------------------------------------
--
-- scene.lua
--
---------------------------------------------------------------------------------
-- Load scene with same root filename as this file
local composer = require( "composer" )
local scene = composer.newScene(  )

local pazzles = {
display.newImage("image/1.png"),
display.newImage("image/2.png"),
display.newImage("image/3.png"),
display.newImage("image/4.png"),
display.newImage("image/5.png"),
display.newImage("image/6.png"),
display.newImage("image/7.png"),
display.newImage("image/8.png"),
display.newImage("image/9.png"),
display.newImage("image/10.png"),
display.newImage("image/11.png"),
display.newImage("image/12.png")
}
local soundTouch = audio.loadSound("audio/touch.mp3")
local soundWin = audio.loadSound("audio/win.mp3")
local image = display.newImage("image/image.jpg")

local pazzlesCorrect = {}
local xPlacement = {}
local yPlacement = {}
local x = {}
local y = {}
local Xcorrect = {}
local Ycorrect = {}

local xSeriesPuzzles = 0
local ySeriesPuzzles = 0
local tag = 0
local Xconnector = 10
local Yconnector = 12
local xBack = 0
local yBack = 0
local Timer = 0
local CounterTime = 0
local Hour = 0
local Minute = 0
local Second = 0

local finish = false





---------------------------------------------------------------------------------

local nextSceneButton



local function determinationCoordinates( )
    for i = 2, #pazzles do
        xPlacement[1] = 40
        yPlacement[1] = 40
         
        if i <= 5 then
            xPlacement[#xPlacement+1] = xPlacement[#xPlacement] + (display.contentWidth-80)/4
            yPlacement[#yPlacement+1] = yPlacement[1]
        elseif i <=7 then
            xPlacement[#xPlacement+1] = xPlacement[#xPlacement]
            yPlacement[#yPlacement+1] = yPlacement[#yPlacement] + (display.contentHeight-80)/2
        elseif i <=11 then
            xPlacement[#xPlacement+1] = xPlacement[#xPlacement] - (display.contentWidth-80)/4
            yPlacement[#yPlacement+1] = yPlacement[#yPlacement]
        else 
            xPlacement[#xPlacement+1] = xPlacement[#xPlacement]
            yPlacement[#yPlacement+1] = yPlacement[#yPlacement] - (display.contentHeight-80)/2
        end
    end

end

local function randomizeLocation( )
    
    determinationCoordinates()
    local iRandom
    for i=1, 12 do
       iRandom = math.random(1,13-i)
       
       x[#x+1] = xPlacement[iRandom]
       y[#y+1] = yPlacement[iRandom]
       table.remove(xPlacement,iRandom)
       table.remove(yPlacement,iRandom)
    end
    
end

local function preparationPazzles( )
     for i=1,12 do
        pazzles[i].tag = i 
        pazzles[i].x = x[i]
        pazzles[i].y = y[i]
        pazzles[i].width = pazzles[i].width / 5
        pazzles[i].height = pazzles[i].height /6
        pazzles[i]:toFront()
        
       
    end
end

local function determinationCorrectLocation(  )
    Xcorrect[1] = display.contentWidth/2 - image.contentWidth/2 + pazzles[1].contentWidth/Xconnector
    Ycorrect[1] = display.contentHeight/2 - image.contentHeight /2 + pazzles[1].contentHeight/Yconnector
       
    xSeriesPuzzles = pazzles[1].contentWidth/5

        for i =2,12 do

            Xcorrect[i] = display.contentWidth/2 - image.contentWidth/2 + xSeriesPuzzles + pazzles[i].contentWidth/Xconnector - 22 
            Ycorrect[i] =display.contentHeight/2 - image.contentHeight /2 + pazzles[i].contentHeight/Yconnector + ySeriesPuzzles 
            xSeriesPuzzles = xSeriesPuzzles+pazzles[i].contentWidth/5 - 20.5

            if(i == 11) then
                Ycorrect[i] =display.contentHeight/2 - image.contentHeight /2 + pazzles[i].contentHeight/6.5 + ySeriesPuzzles 
            elseif (i == 6)or(i == 7) then
                Ycorrect[i] =display.contentHeight/2 - image.contentHeight /2 + pazzles[i].contentHeight/Yconnector + ySeriesPuzzles  - 17
            end

            if i%4 == 0 then
                ySeriesPuzzles = ySeriesPuzzles + pazzles[i-3].contentHeight/6 - 17.1
                xSeriesPuzzles = pazzles[1].contentWidth/19.3
                if i == 10 then
                    ySeriesPuzzles = ySeriesPuzzles + pazzles[i-3].contentHeight/6 
                end
            end
            if i>8 then
                xSeriesPuzzles = xSeriesPuzzles - 0.4
            elseif i>4 and i<9 then
                xSeriesPuzzles = xSeriesPuzzles - 0.4
            end
        end
end


local function moveIt(event ) 
    local counter = 0
    
    local tagElementary = nil
    if event.phase == "began" then
        
        tagElementary = event.target.tag
        
        if(pazzles[tagElementary]~= nil) then
            audio.play(soundTouch)
            tag = tagElementary
            pazzles[tag]:toFront()
            xBack = pazzles[tag].x
            yBack = pazzles[tag].y
        end
    end
    
    if(pazzles[tag]~= nil) then
        if event.phase == "moved" then
            pazzles[tag]:toFront()
            pazzles[tag].x = event.x
            pazzles[tag].y = event.y
            

        end
        if event.phase == "ended" then
             if((pazzles[tag].x<0 )or(pazzles[tag].y<0)or 
                (pazzles[tag].x>display.contentWidth+pazzles[tag].contentWidth/6)or
                (pazzles[tag].y>display.contentHeight))then
                transition.moveTo( pazzles[tag], { x=xBack, y=yBack, time=200 } )
            end

            if(((pazzles[tag].x < Xcorrect[tag]+pazzles[tag].contentWidth*0.15)and
                (pazzles[tag].x > Xcorrect[tag]-pazzles[tag].contentWidth*0.15))and
                ((pazzles[tag].y < Ycorrect[tag]+pazzles[tag].contentHeight*0.15)and
                (pazzles[tag].y > Ycorrect[tag]-pazzles[tag].contentHeight*0.15))) then
                    transition.moveTo( pazzles[tag], { x=Xcorrect[tag], y=Ycorrect[tag], time=200 } )
                    table.insert(pazzlesCorrect,pazzles[tag])
                    pazzlesCorrect[#pazzlesCorrect].x = pazzles[tag].x
                    pazzlesCorrect[#pazzlesCorrect].y = pazzles[tag].y
                    pazzles[tag] = nil

                for i = 1,12 do
                    if pazzles[i] == nil then
                        counter = counter +1
                    end
                end
                if counter == 12 then
                    audio.play(soundWin)
                    local function onComplete( event )
                         if event.action == "clicked" then
                            local i = event.index
                            if i == 1 then
                                composer.removeScene("scene2")
                                composer.gotoScene( "scene1",  "slideLeft", 300 )    
                            elseif i == 2 then
                                composer.removeScene("scene2")
                                composer.gotoScene( "scene2",{ effect = "fade", time = 800 } ) 
                            end
                        end
                    end
                    
                    local TimeComplete = "Ваше время: "..math.modf(CounterTime/3600)..":"..math.modf(CounterTime/60)..":"..CounterTime%60 
                    native.showAlert( "Поздравляю!", TimeComplete, { "В меню", "Еще раз" }, onComplete )
                end

            end
        end
    end
end



local function countTime()
    CounterTime = CounterTime + 1;
end

function scene:create( event )
    local sceneGroup = self.view
    

    -- Called when the scene's view does not exist
    -- 
    -- INSERT code here to initialize the scene
    -- e.g. add display objects to 'sceneGroup', add touch listeners, etc
end

function scene:show( event )
    local sceneGroup = self.view
    local phase = event.phase

    if phase == "will" then
        -- Called when the scene is still off screen and is about to move on screen

        local backGround = display.newImage("image/backGround.jpg")
        backGround.x = display.contentWidth / 2
        backGround.y = display.contentHeight / 2
        
        image.width =  image.width / 5
        image.height =  image.height / 6
        image.x = display.contentWidth / 2
        image.y = display.contentHeight / 2
        image:toFront()
       
        randomizeLocation()
        determinationCorrectLocation()
        preparationPazzles( )

        Timer = timer.performWithDelay(1000,countTime,-1)
        for i=1,#pazzles do
          pazzles[i]:addEventListener( "touch", moveIt)
        end

        sceneGroup:insert(backGround)
        sceneGroup:insert(image)
        for i = 1, #pazzles do
            sceneGroup:insert(pazzles[i])
        end
    elseif phase == "did" then
        -- Called when the scene is now on screen
        -- 
        -- INSERT code here to make the scene come alive
        -- e.g. start timers, begin animation, play audio, etc
    end 
end

function scene:hide( event )
    local sceneGroup = self.view
    local phase = event.phase

    if event.phase == "will" then
        -- Called when the scene is on screen and is about to move off screen
        --
        -- INSERT code here to pause the scene
        -- e.g. stop timers, stop animation, unload sounds, etc.)
    elseif phase == "did" then
        -- Called when the scene is now off screen
        --[[if nextSceneButton then
            nextSceneButton:removeEventListener( "touch", nextSceneButton )
        end]]
    end 
end


function scene:destroy( event )
    local sceneGroup = self.view

    -- Called prior to the removal of scene's "view" (sceneGroup)
    -- 
    -- INSERT code here to cleanup the scene
    -- e.g. remove display objects, remove touch listeners, save state, etc
end

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )



---------------------------------------------------------------------------------

return scene
