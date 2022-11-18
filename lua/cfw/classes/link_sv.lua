-- Links are an abstraction of constraints and parents or "connections"
-- These are used to keep track of the number of connections between two entities
-- In graph theory these are edges

CFW.classes.link = {}

function CFW.createLink(a, b)
    local indexA, indexB = a:EntIndex(), b:EntIndex()

    local link = {
        entA = a,
        entB = b,
        indexA = indexA,
        indexB = indexB,
        count = 1,
        color = ColorRand()
    }

    a._links = a._links or {}
    b._links = b._links or {}

    a._links[indexB] = link
    b._links[indexA] = link

    setmetatable(link, CFW.classes.link)

    return link:Init()
end

do -- Class def
    local CLASS = CFW.classes.link

    CLASS.__index = CLASS -- why?

    function CLASS:Init()
        return link
    end

    function CLASS:Add()
        self.count = self.count + 1
    end

    function CLASS:Sub()
        self.count = self.count - 1

        if self.count == 0 then return self:Remove() end

        return true
    end

    function CLASS:Remove()
        local contraptionPopped = false
        local entA, entB        = self.entA, self.entB
        local indexA, indexB    = self.indexA, self.indexB

        if IsValid(entA) then
            entA._links[indexB] = nil

            if not next(entA._links) then
                entA._links = nil
                entA:GetContraption():Sub(entA)

                contraptionPopped = true
            end
        else
            contraptionPopped = true
        end

        if IsValid(entB) then
            entB._links[indexA] = nil

            if not next(entB._links) then
                entB._links = nil
                entB:GetContraption():Sub(entB)

                contraptionPopped = true
            end
        else
            contraptionPopped = true
        end
        
        return contraptionPopped
    end
end

do
    local ENT = FindMetaTable("Entity")

    function ENT:GetLink(other) -- Returns the link object between this and other
        return self._links and self._links[other:EntIndex()] or nil
    end

    function ENT:GetLinks() -- Creates a shallow copy of the links table
        local out = {}

        for k, v in pairs(self._links) do
            out[k] = v
        end

        return out
    end
end