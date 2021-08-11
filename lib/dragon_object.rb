# frozen_string_literal: true

#  TODO: Finish Sprites. beyond basics. Add relevant methods such as calcstringbox for labels "width"

# Base Class, doesn't do much on its own.

class DragonObject
  attr_accessor :x, :y, :r, :g, :b, :a, :primitive_marker, :color, :blendmode_enum

  def initialize(x:, y:, color:)
    @args = $gtk.args
    @x = x
    @y = y
    @r, @g, @b = color
    @a = color[3] || 255
  end

# All DragonObjects have a special color setting and getting method

  def color(alpha: false)
    alpha ? [@r, @g, @b, @a] : [@r, @g, @b]
  end

  def color=(color)
    @r, @g, @b = color
    @a = color[3] || @a
  end

# Generic Interface (fill these in to make them do something in a composite)
  def update();end
  def show();end
  def input();end
# It makes the errors quieter
  def serialize(); {x: @x, y: @y}; end
  def inspect(); serialize.to_s; end
  def to_s(); serialize.to_s; end
end

class Label < DragonObject
  attr_accessor :text, :size_enum, :alignment_enum, :font

  def initialize(x: 0, y: 50, color: [0, 0, 0, 255], text: '',
                 font_size: 8, font_align: 0, font: '')
    super(x: x, y: y, color: color)
    @text = text
    @size_enum = font_size
    @alignment_enum = font_align
    @font = font
    @primitive_marker = :label
  end

# The identify methods are there if you want to broadcast yourself to render_targets. Use them for
# composite setups.

  def identify
    [@x, @y, @text, @size_enum, @alignment_enum, @r, @g, @b, @a, @font].label
  end
end

class StaticLabel < Label
  def initialize(x: 0, y: 50,color: [0, 0, 0, 255], text: '', font_size: 8,
                  font_align: 0, font: '')
    super(x: x, y: y, color: color, text: text, font_size: font_size,
          font_align: font_align, font: font)
    @args.static_labels << self
  end
end

class Border < DragonObject
  attr_accessor :w, :h

  def initialize(x: 0, y: 0, w: 100, h: 100, color: [0, 0, 0, 255])
    super(x: x, y: y, color: color)
    @mouse = @args.mouse
    @w = w
    @h = h
    @primitive_marker = :border
  end

  def identify
    [@x, @y, @w, @h, @r, @g, @b, @a].border
  end

  def x2
    @x + @w
  end

  def y2
    @y + @h
  end

  def under_pointer?
    (@x..x2).include?(@mouse.x) && (@y..y2).include?(@mouse.y)
  end

  def clicked?
    @mouse.click && under_pointer?
  end
end

class StaticBorder < Border
  def initialize(x: 0, y: 0, w: 100, h: 100, color: [0, 0, 0, 255])
    super(x: x, y: y, w: w, h: h, color: color)
    @args.static_borders << self
  end
end

# pull from border simply to cut down typing. It's the same thing.

class Solid < Border
  def initialize(x: 0, y: 0, w: 100, h: 100, color: [0, 0, 0, 255])
    super(x: x, y: y, w: w, h: h, color: color)
    @primitive_marker = :solid
  end

  def identify
    [@x, @y, @w, @h, @r, @g, @b, @a].solid
  end
end

class StaticSolid < Solid
  def initialize(x: 0, y: 0, w: 100, h: 100, color: [0, 0, 0, 255])
    super(x: x, y: y, w: w, h: h, color: color)
    @args.static_solids << self
  end
end

class Line < DragonObject
  attr_accessor :x2, :y2

  def initialize(x: 0, y: 0, x2: 100, y2: 100, color: [0, 0, 0, 255])
    super(x: x, y: y, color: color)
    @x2 = x2
    @y2 = y2
    @primitive_marker = :line
  end
  def identify
    [@x, @y, @x2, @y2, @r, @g, @b, @a].line
  end
end

class StaticLine < Line
  def initialize(x: 0, y: 0, x2: 100, y2: 100, color: [0, 0, 0, 255])
    super(x: x, y: y, x2: x2, y2: y2, color: color)
    @args.static_lines << self
  end
end

# sprite pulls from border because they share common attributes. Makes the mess of attr_accessor
# below a bit less of a nightmare to look at. :D Also gains the mouse sensitivity methods.

class Sprite < Border
  attr_accessor :path, :angle, :source_x, :source_y, :source_w, :source_h,
                :tile_x, :tile_y, :tile_w, :tile_h, :flip_horizontally,
                :flip_vertically, :angle_anchor_x, :angle_anchor_y

  def initialize(x: 0, y: 0, w: 1280, h: 720, path: '', color: [255, 255, 255, 255])
    super(x: x, y: y, w: w, h: h, color: color)
    @path = path
    @primitive_marker = :sprite
    @source_w = w
    @source_h = h
    @source_x = 0
    @source_y = 0
    @flip_vertically = false
    @flip_horizontally = false
    @angle_anchor_x = 0
    @angle_anchor_y = 0
  end
  def identify
    [@x, @y, @w, @h, @path, @angle, @a, @r, @g, @b].sprite
  end
end

class StaticSprite < Sprite
  def initialize(x: 0, y: 0, w: 100, h: 100, color: [255, 255, 255, 255], path: '')
    super(x: x, y: y, w: w, h: h, color: color, path: path)
    @args.static_sprites << self
  end
end
