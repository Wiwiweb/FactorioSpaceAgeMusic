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
    if sound.track_type == "hero-track" then
        local sound_planet = sound.planet or "space"
        if location_has_hero_track[sound_planet] == false then -- Specifically check for false, not false and nil
            table.insert(new_ambient_sounds, sound)
            table.insert(track_names_per_type[sound.track_type], name)
            location_has_hero_track[sound_planet] = true
        end
    else
        for _, location in pairs(locations) do
            local new_sound = table.deepcopy(sound)
            new_sound.name = sound.name .. "-for-" .. location
            new_sound.planet = location == "space" and nil or location
            table.insert(new_ambient_sounds, new_sound)
        end
        table.insert(track_names_per_type[sound.track_type], name)
    end
end

log(#new_ambient_sounds .. " tracks total")
log("Tracklist: " .. serpent.line(track_names_per_type))

data:extend(new_ambient_sounds)
