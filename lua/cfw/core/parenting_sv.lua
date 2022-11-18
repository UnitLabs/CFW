local connect    = CFW.connect
local disconnect = CFW.disconnect
local filter     = {
    gmod_hands = true
}

CFW.parentFilter = filter

hook.Add("Initialize", "CFW", function()
    timer.Simple(0, function()
        local ENT       = FindMetaTable("Entity")
        local setParent = ENT.SetParent

        function ENT:SetParent(parent, newAttach, ...)
            local oldParent = self:GetParent()
            local oldAttach = self:GetParentAttachment()

            setParent(self, parent, newAttach, ...)

            if self._cfwRemoved then return end -- Removed by an undo
            if oldParent == parent and oldAttach ~= newAttach then return end
            if filter[self:GetClass()] then return end
        
            if IsValid(oldParent) then disconnect(self, oldParent:EntIndex(), isParent) end
            if IsValid(parent) then connect(self, parent, isParent) end
        end
    end)

    hook.Remove("Initialize", "CFW")
end)