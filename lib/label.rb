class Label
  attr_accessor :x, :y, :text, :size_enum, :alignment_enum, :font, :r, :g, :b, :a

  def primitive_marker
    :label
  end

  def initialize(x: 640, y: 480, text: "Hello", font_size: 5, font_align: 1,
                  font: '', color: [0, 0, 0, 255])
    @x = x
    @y = y
    @text = text
    @size_enum = font_size
    @alignment_enum = font_align
    @r, @g, @b = color
    @a = color[3] || 255
  end
end
