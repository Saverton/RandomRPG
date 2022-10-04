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
    self.currentTrack = self.track
    self.introTimer = nil
    self:playIntro()
end

-- play the music to start, plays an intro part if applicable
function Music:playIntro()
    if self.introTrack == nil then
        self:play()
    else
        self.currentTrack = self.introTrack
        self:play()
        self.introTimer = Timer.after(self.introTrack:getDuration("seconds"), function()
            self.introTimer:remove()
            self:stop()
            self.currentTrack = self.track
            self:play()
        end)
    end
end

-- play the music if not playing
function Music:play()
    love.audio.play(self.currentTrack)
end

-- stops music playing
function Music:pause()
    love.audio.pause(self.currentTrack)
end

-- stops music playing and rewind to start
function Music:stop()
    love.audio.stop(self.currentTrack)
    if self.introTimer ~= nil then
        self.introTimer:remove()
    end
end