local function lib(bp)
    local o = {}

    -- Private Variables.

    -- Public Variables.

    -- Private Methods.
    local function handleMouse(display, s, param, x, y)

        if display and s and param == 2 and display:hover(x, y) and s.display.x and s.display.y then
            s.display.x, s.display.y = display:pos_x(), display:pos_y()
            s:save()
            
        end

    end

    local function handleInputs(display)
        local visible = (not bp.__player.chat() and not bp.__player.moghouse()) and true or false
        display:visible(visible)

    end

    -- Public Methods.
    o.new = function(s)
        local display = bp.texts.new({pos={x=1, y=1}, bg={alpha=0, red=0, green=0, blue=0, visible=false}, flags={draggable=true, bold=true}, text={size=10, font='Arial', alpha=200, red=245, green=175, blue=20, stroke={width=2, alpha=255, red=0, green=0, blue=0}}, padding=5})
        local visible = (not bp.__player.menu() and not bp.__player.chat() and not bp.__player.moghouse()) and true or false

        if visible then
            display:show()
        
        end
        display.mouse_event = bp.register('mouse', function(param, x, y) handleMouse(display, s, param, x, y) end)
        display.keybd_event = bp.register('keyboard', function() handleInputs(display) end)
        display.delete = function(t)
            if not t then return end
            bp.unregister(t.mouse_event)
            bp.unregister(t.keybd_event)
            t:destroy()

        end
        return display

    end

    -- Private Events.

    return o

end
return lib