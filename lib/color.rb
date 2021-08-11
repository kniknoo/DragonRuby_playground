# frozen_string_literal: true

# TODO "paint mixer"? (uses palette to generate color_maps semi-automatically)
# Swatches to create quick feedback. User key population. NES and GameBoy palette

BLACK   = [0,   0,   0].freeze
WHITE   = [255, 255, 255].freeze
RED     = [255, 0,   0].freeze
ORANGE  = [255, 127, 0].freeze
YELLOW  = [255, 255, 0].freeze
LIME    = [127, 255, 0].freeze
GREEN   = [0,   255, 0].freeze
AQUA    = [0,   255, 127].freeze
CYAN    = [0,   255, 255].freeze
SKY     = [0,   127, 255].freeze
BLUE    = [0,   0,   255].freeze
INDIGO  = [127, 0,   255].freeze
MAGENTA = [255, 0,   255].freeze
PINK    = [255, 0,   127].freeze
GREY    = 256.times.map { |i| [i, i, i] }
GRAY    = GREY

class Color
  def self.invert(color)
    color.map { |rgb| 255 - rgb }
  end

  def self.gradient(c1 = BLACK, c2 = WHITE, steps = 10)
    steps.times.map do |i|
      c1.zip(c2).map { |a, b| ((b - a) * (i.to_f / (steps - 1)) + a).round }
    end
  end

  def self.complex_gradient(grads)
    grads.flat_map { |e| gradient(*e) }
  end

  def self.hex_to_rgb(hex)
    hex.gsub('#', '').chars.each_slice(2).map { |e| e.join.to_i(16)}
  end

  def self.rgb_to_hex(rgb, prefix = '')
    "#{prefix}#{rgb.map { |e| e.to_s(16).rjust(2, '0').upcase}.join}"
  end

  def self.map_float(c_map, value, cycles = 1)
    c_map[(value * c_map.size * cycles).to_i % c_map.size]
  end

  def self.map_signed_float(c_map, value, cycles = 1)
    half_size = c_map.size / 2
    c_map[((value * half_size * cycles).to_i + half_size) % c_map.size]
  end

  def self.hues(saturation = 100, lightness = 50)
    360.times.map { |i| hsl_to_rgb([i, saturation, lightness])}
  end

  # Adapted from https://github.com/anilyanduri/color_math/blob/master/lib/color_math.rb

  def self.hsl_to_rgb(hsl)
    h, s, l = hsl
    s *= 0.01
    return 3.times.map { (l * 2.55).round } if s == 0.0

    h *= 0.002777778
    l *= 0.01
    q = l < 0.5 ? l * (1 + s) : l + s - l * s
    p1 = 2 * l - q
    r = hue_to_rgb(p1, q, h + 0.333333333)
    g = hue_to_rgb(p1, q, h)
    b = hue_to_rgb(p1, q, h - 0.333333333)

    [(r * 255).round, (g * 255).round, (b * 255).round]
  end

  def self.hue_to_rgb(p1, q, t)
    t += 1                                      if t.negative?
    t -= 1                                      if t > 1
    return (p1 + (q - p1) * 6 * t)              if t < 0.166666667
    return q                                    if t < 0.5
    return (p1 + (q - p1) * (2 / 3.0 - t) * 6)  if t < 0.666666667

    p1
  end

  def self.rgb_to_hsl(rgb)
    r, g, b = rgb.map { |c| c * 0.003921569 }
    max = [r, g, b].max
    min = [r, g, b].min
    mag = max + min
    d = max - min
    l = mag * 0.5
    return [0, 0, (l * 100).round] if d.zero?

    s = l >= 0.5 ? d / (2.0 - max - min) : d / mag
    h = case max
        when r then (g - b) / d + (g < b ? 6.0 : 0)
        when g then (b - r) / d + 2.0
        when b then (r - g) / d + 4.0
        end

    [(h * 60).round, (s * 100).round, (l * 100).round]
  end
end

class Palette
  attr_reader :primary, :secondary, :tertiary, :complement

  def initialize(rgb, secondary = 'none', offset = 30)
    @hsl = Color.rgb_to_hsl rgb
    @primary = generate(rgb)
    @secondary, @tertiary = setup(secondary, offset).map { |e| generate(e) }
    @complement = generate(split(0))
  end

  def generate(c1, tone = 127)
    { base: c1,
      shades: Color.gradient(c1, BLACK, 10),
      tones: Color.gradient(c1, GREY[tone], 10),
      tints: Color.gradient(c1, WHITE, 10) }
  end

  def setup(secondary = 'none', offset = 30)
    case secondary
    when 'tetrad' then [adjacent(90), split(90)]
    when 'triad' then [split(60), split(-60)]
    when 'rectangle' then [adjacent(offset), split(offset)]
    when 'adjacent' then [adjacent(offset), adjacent(-offset)]
    when 'split' then [split(offset), split(-offset)]
    else [[0, 0, 0], [255, 255, 255]]
    end
  end

  def adjacent(degrees)
    Color.hsl_to_rgb([(@hsl[0] + degrees) % 360, @hsl[1], @hsl[2]])
  end

  def split(degrees)
    adjacent(180 + degrees)
  end
end

class Swatch
  def generate(palette)
     [:primary, :secondary, :tertiary, :complement].map.with_index do |base, bi|
       [:shades, :tones, :tints].map.with_index do |shade, si|
         palette.send(base)[shade].map.with_index do |color, ci|
           [bi * 300 + si * 100, ci * 70, 100, 70, color]
         end
       end
     end
  end
end
