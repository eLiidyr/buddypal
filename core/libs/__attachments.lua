local function lib(bp)
    local o = {}

    -- Private Variables.
    local setAttachment = windower.ffxi.set_attachment

    -- Public Variables.

    -- Private Methods.

    -- Public Methods.
    o.getFrame = function()

        if bp.__player.mjob() == 'PUP' then
            local data = bp.__player.jobdata()
            
            if data:length() > 0 then
                return bp.__player.jobdata().frame

            end
        
        end
        return false

    end

    o.getHead = function()


        if bp.__player.mjob() == 'PUP' then
            local data = bp.__player.jobdata()

            if data:length() > 0 then
                return bp.__player.jobdata().head

            end
        
        end
        return false

    end

    o.getCurrent = function()

        if bp.__player.mjob() == 'PUP' then
            local data = bp.__player.jobdata()
            
            if data:length() > 0 then
                return T(bp.__player.jobdata().attachments)

            end
        
        end
        return T{}

    end

    o.getFrames = function()

        if bp.__player.mjob() == 'PUP' then
            local data = bp.__player.jobdata()

            if data:length() > 0 then
                return T(bp.__player.jobdata().available_frames)

            end
        
        end
        return T{}

    end

    o.getHeads = function()

        if bp.__player.mjob() == 'PUP' then
            local data = bp.__player.jobdata()

            if data:length() > 0 then
                return T(bp.__player.jobdata().available_heads)

            end
        
        end
        return T{}

    end

    o.getAll = function()

        if bp.__player.mjob() == 'PUP' then
            local data = bp.__player.jobdata()

            if data:length() > 0 then
                return T(bp.__player.jobdata().available_attachments)

            end
        
        end
        return T{}

    end

    o.equipHead = function(id)

        if o.getHead() ~= id then
            setAttachment(id)

        end

    end

    o.equipFrame = function(id)

        if o.getFrame() ~= id then
            setAttachment(id)

        end

    end

    o.equipAttachments = function(attachments)

        if attachments and type(attachments) == 'table' then

            for index, id in ipairs(attachments) do

                if o.getCurrent()[index] ~= id then
                    setAttachment:schedule((index * 0.15), id, index)

                end
                
            end

        end

    end

    o.equip = function(set)

        if set and type(set) == 'table' and set.head and set.frame and set.attachments then
            local d = 0

            for slot, attachment in pairs(set) do

                if slot == 'head' then
                    o.equipHead:schedule(d * 0.1, attachment)

                elseif slot == 'frame' then
                    o.equipFrame:schedule(d * 0.1, attachment)

                elseif slot == 'attachments' then
                    o.equipAttachments:schedule(d * 0.1, attachment)

                end
                d = (d + 1)

            end

        end

    end

    -- Private Events.

    return o

end
return lib