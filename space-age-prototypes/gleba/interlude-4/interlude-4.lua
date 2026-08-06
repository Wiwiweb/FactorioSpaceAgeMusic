return
{
  type = "ambient-sound",
  name = "gleba-interlude-4",
  track_type = "main-track",
  planets = {"gleba"},
  weight = 25,

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
          sound_variations(Space_age_ambient_folder_path .. "/gleba/interlude-4/interlude-4", 4, 1.4)
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
