class Sprite
  attr_accessor :x, :y, :w, :h, :path, :angle, :a, :r, :g, :b, :source_x,
                :source_y, :source_w, :source_h, :flip_horizontally,
                :flip_vertically, :angle_anchor_x, :angle_anchor_y,
                :tile_x, :tile_y, :tile_w, :tile_h
  def initialize(x: 600, y: 480, w: 50, h: 70, path: '', angle: 0, a: 255,
                color: [0, 0, 0, 255])
    @x = x
    @y = y
    @w = w
    @h = h
    @r, @g, @b = color
    @a = a || 255
    @path = path
    @angle = angle
    @source_x = 0
    @source_y = 0
    @source_h = -1
    @source_w = -1
    @tile_x = 0
    @tile_y = 0
    @tile_h = -1
    @tile_w = -1
    @flip_horizontally = false
    @flip_vertically = false
    @angle_anchor_x = 0
    @angle_anchor_y = 0
  end
  def primitive_marker
    :sprite
  end
end
