-- Tracks the total mass of a contraption

hook.Add("cfw.contraption.created", "CFW_Mass", function(con)
    con.totalMass = 0
end)

hook.Add("cfw.contraption.entityAdded", "CFW_Mass", function(con, ent)
    local obj = ent:GetPhysicsObject()

    if IsValid(obj) then
        local mass = obj:GetMass()

        ent._mass     = mass
        con.totalMass = con.totalMass + mass
    end
end)

hook.Add("cfw.contraption.entityRemoved", "CFW_Mass", function(con, ent)
    local obj = ent:GetPhysicsObject()

    if IsValid(obj) then
        con.totalMass = con.totalMass - obj:GetMass()
    end
end)

hook.Add("Initialize", "CFW_Mass", function()
    local PHYS    = FindMetaTable("PhysObj")
    local setMass = PHYS.SetMass

    function PHYS:SetMass(newMass)
        local ent     = self:GetEntity()
        local oldMass = ent._mass --self:GetMass()

        ent._mass = newMass

        setMass(self, newMass)

        local con = self:GetEntity():GetContraption()

        if con then
            con.totalMass = con.totalMass + (newMass - oldMass)
        end
    end

    hook.Remove("Initialize", "CFW_Mass")
end)