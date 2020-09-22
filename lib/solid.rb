class Solid
  attr_accessor :x, :y, :w, :h, :r, :g, :b, :a

  def initialize(x: 640, y: 480, w: 50, h: 70, color: [0, 0, 0, 255])
    @x = x
    @y = y
    @w = w
    @h = h
    @r, @g, @b = color
    @a = color[3] || 255
  end

  def primitive_marker
    :solid
  end
end
