---------------------------------------------------------------------------------
--
-- scene.lua
--
---------------------------------------------------------------------------------

local sceneName = ...

local composer = require( "composer" )

-- Load scene with same root filename as this file
local scene = composer.newScene( sceneName )

---------------------------------------------------------------------------------

local nextSceneButton

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
    local BackGround = display.newImage("image/backGroundMenu.jpg")
    local PazleText = self:getObjectByName( "PazleText")
    local NewGameText = self:getObjectByName( "NewGameText" )
    local NewGameBtn = self:getObjectByName( "NewGameBtn" )
    if phase == "will" then
        -- Called when the scene is still off screen and is about to move on screen
        NewGameBtn.x = display.contentWidth / 2
        NewGameBtn.y = display.contentHeight * (4/5)
        
        NewGameText.x = display.contentWidth /2
        NewGameText.y = display.contentHeight * (4/5)
		
		PazleText.x = display.contentWidth / 2
		PazleText.y = display.contentHeight / 5
		PazleText:toFront()
		
		BackGround.x = display.contentWidth / 2
		BackGround.y = display.contentHeight / 2
        BackGround:toBack();
    elseif phase == "did" then
        -- Called when the scene is now on screen
        -- 
        -- INSERT code here to make the scene come alive
        -- e.g. start timers, begin animation, play audio, etc
        
        -- we obtain the object by id from the scene's object hierarchy
        BackGround:toBack()
        PazleText:toFront()
        NewGameBtn:toFront()
        NewGameText:toFront()
        
        nextSceneButton = self:getObjectByName( "NewGameBtn" )
        if nextSceneButton then
        	-- touch listener for the button
        	function nextSceneButton:touch ( event )
        		local phase = event.phase
        		if "ended" == phase then
        			composer.gotoScene( "scene2", { effect = "fade", time = 300 } )
        		end
        	end
        	-- add the touch event listener to the button
        	nextSceneButton:addEventListener( "touch", nextSceneButton )
        end
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
		if nextSceneButton then
			nextSceneButton:removeEventListener( "touch", nextSceneButton )
		end
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
