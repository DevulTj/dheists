--[[
	© 2018 devultj.co.uk, do not share, re-distribute or modify

	without permission of its author (devultj@gmail.com).
]]

dHeists.alarms = dHeists.alarms or {}
dHeists.alarms.alarmSound = "dheists_alarm"

function dHeists.alarms:setAlarmSound( soundPath, data )
    sound.Add {
        name = dHeists.alarms.alarmSound,
        channel = data.channel or CHAN_STATIC,
        volume = data.volume or 1,
        level = data.level or 80,
        pitch = data.pitch or 100,

        sound = data.sound or soundPath
    }
end

-- Include configuration for Alarms
frile.includeFile( "dheists/config/config_entities/sh_alarms.lua" )