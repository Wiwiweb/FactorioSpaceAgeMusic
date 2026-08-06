return
{
  type = "ambient-sound",
  name = "fulgora-interlude-6",
  track_type = "main-track",
  planets = {"fulgora"},
  weight = 15,

  variable_sound =
  {
    length_seconds = 300,
    alignment_samples = 44100,

    layers =
    {
      {
        name = "A",
        variants =
        {
          sound_variations(Space_age_ambient_folder_path .. "/fulgora/interlude-6/interlude-6", 5, 1.6)
        },
        composition_mode = "randomized",
      },
    }, --layers

    states =
    {
      {
        name = "begin",
        layers_properties =
        {
          {
            pause_between_repetitions = {2, 8},
          },
        },
      },
    } --states
  }
}
