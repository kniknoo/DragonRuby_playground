class Line
  attr_accessor :x, :y, :x2, :y2, :r, :g, :b, :a
  def initialize(x: 600, y: 480, x2: 600, y2: 650, color: [0, 0, 0, 255])
    @x = x
    @y = y
    @x2 = x2
    @y2 = y2
    @r, @g, @b = color
    @a = color[3] || 255
  end
  def primitive_marker
    :line
  end
end
