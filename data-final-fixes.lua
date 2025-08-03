-- Devs please don't patch 🙏
Space_age_path = "__base__/../space-age"

require("space-age-prototypes/ambient-sounds")

local locations = {}
local location_has_hero_track = {}
for name, _ in pairs(data.raw["planet"]) do
    table.insert(locations, name)
    location_has_hero_track[name] = false
end
if feature_flags["space_travel"] then
    table.insert(locations, "space")
    location_has_hero_track["space"] = false
end

log("Locations: " .. serpent.line(locations))


local track_names_per_type = {
    ["main-track"] = {},
    ["interlude"] = {},
    ["hero-track"] = {},
    ["menu-track"] = {},
}

local original_ambient_sounds = data.raw["ambient-sound"]
local new_ambient_sounds = {}
data.raw["ambient-sound"] = {}

for name, sound in pairs(original_ambient_sounds) do

    -- Only one hero-track per planet
    -- If the location of that hero track exists, keep it, otherwise discard it.
    -- (There is always a regular track version of the hero track anyway)
    if sound.track_type == "hero-track" then
        local sound_planet = sound.planet or "space"
        if location_has_hero_track[sound_planet] == false then -- Specifically check for false, not false and nil
            table.insert(new_ambient_sounds, sound)
            table.insert(track_names_per_type[sound.track_type], name)
            location_has_hero_track[sound_planet] = true
        end
    else

        -- Space age has interlude tracks marked as "main-track"
        -- From dev: 
        --   "since some planets have a very different ratio of main track to interludes 
        --    they are instead marked all as main tracks and use the weights to control how often they play"
        -- We only have one pool of songs, so we don't have this issue and we can restore the interlude system.
        if sound.track_type == "main-track" and string.find(sound.name, "interlude") then
            sound.track_type = "interlude"
            sound.weight = 10 -- Down to default weight
        end

        -- Make a copy of the ambient-sound for every location
        for _, location in pairs(locations) do
            local new_sound = table.deepcopy(sound)
            new_sound.name = sound.name .. "-for-" .. location
            if location == "space" then
                new_sound.planet = nil
            else
                new_sound.planet = location
            end
            table.insert(new_ambient_sounds, new_sound)
        end
        table.insert(track_names_per_type[sound.track_type], name)
    end
end

log(string.format("%d tracks total (including %d main tracks and %d interludes)",
    #new_ambient_sounds, #track_names_per_type["main-track"], #track_names_per_type["interlude"]))
log("Tracklist: " .. serpent.line(track_names_per_type))

data:extend(new_ambient_sounds)
