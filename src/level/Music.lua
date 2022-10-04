--[[
    Music manager class: holds a reference to a track, allows for playing, pausing, stopping music.
    @author Saverton
]]

Music = Class{}

function Music:init(trackName, introTrack)
    self.track = gSounds['music'][trackName]
    self.track:setLooping(true)
    if introTrack ~= nil then
        self.introTrack = gSounds['music'][introTrack]
    else
        self.introTrack = nil
    end
    self:playIntro()
end

-- play the music to start, plays an intro part if applicable
function Music:playIntro()
    if self.introTrack == nil then
        self:play()
    else
        love.audio.play(self.introTrack)
        local intro
        intro = Timer.after(self.introTrack:getDuration("seconds"), function()
            intro:remove()
            love.audio.stop(self.introTrack)
            self:play()
        end)
    end
end

-- play the music if not playing
function Music:play()
    love.audio.play(self.track)
end

-- stops music playing
function Music:pause()
    love.audio.pause(self.track)
end

-- stops music playing and rewind to start
function Music:stop()
    love.audio.stop(self.track)
end