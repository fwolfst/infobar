class Infobar::Spinner
  PREDEFINED = {
    pipe:      %w[ | / – \\ ],
    arrow:     %w[ ↑ ↗ → ↘ ↓ ↙ ← ↖ ],
    bar1:      %w[ ▁ ▂ ▃ ▄ ▅ ▆ ▇ █ ▇ ▆ ▅ ▄ ▃ ▂ ],
    bar2:      %w[ █ ▉ ▊ ▋ ▌ ▍ ▎ ▏ ▎ ▍ ▌ ▋ ▊ ▉ ],
    braille7:  %w[ ⣾ ⣽ ⣻ ⢿ ⡿ ⣟ ⣯ ⣷ ],
    braille1:  %w[ ⠁ ⠂ ⠄ ⡀ ⢀ ⠠ ⠐ ⠈ ],
    square1:   %w[ ▖ ▘ ▝ ▗ ],
    square2:   %w[ ◰ ◳ ◲ ◱ ],
    tetris:    %w[ ▌ ▀ ▐▄ ],
    eyes:      %w[ ◡◡ ⊙⊙ ◠◠ ],
    corners:   %w[ ┤ ┘ ┴ └ ├ ┌ ┬ ┐ ],
    triangle:  %w[ ◢ ◣ ◤ ◥ ],
    circle1:   %w[ ◴ ◷ ◶ ◵ ],
    circle2:   %w[ ◐ ◓ ◑ ◒ ],
    circle3:   %w[ ◜ ◝ ◞ ◟ ],
    cross:     %w[ + × ],
    cylon:     [ '●  ', ' ● ', '  ●', ' ● ' ],
    pacman:    [ 'ᗧ∙∙∙∙●', ' O∙∙∙●', '  ᗧ∙∙●','   O∙●', '    ᗧ●', 'ᗣ    O', ' ᗣ   ᗤ', ' ᗣ  O ', ' ᗣ ᗤ  ', ' ᗣO   ', ' ᗤ    ', 'O ∞   ', 'ᗧ   ∞ ', 'O     ' ],
    asteroids: [ 'ᐊ  ◍', 'ᐃ  ◍', 'ᐓ  ◍', 'ᐅ· ◍', 'ᐅ ·◍', 'ᐅ  ○', 'ᐅ  ◌', 'ᐁ   ' ],
  }

  def initialize(frames = nil)
    @frames =
      case frames
      when Array
        frames
      when Symbol
        PREDEFINED.fetch(frames) do
          |k| raise KeyError, "frames #{k} not predefined"
        end
      when nil
        PREDEFINED[:pipe]
      end
  end

  def spin(count)
    @string =
      if count == :random
        @frames[rand(@frames.size)]
      else
        @frames[count % @frames.size]
      end
    self
  end

  def to_s
    @string
  end
end
