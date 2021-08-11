# TODO Better buttons. Counters. Menu. Panels. text-box. Decorators.



class Composite
  attr_accessor :primitives
  def initialize(primitives, x: 640, y: 360)
    @x = x
    @y = y
    @primitives = primitives
    place
    $gtk.args.static_primitives << @primitives
  end

  def place
    @primitives.each do |primitive|
      primitive.x = @x
      primitive.y = @y
      primitive.y += 40 if primitive.class == Label
    end
  end


end

# add quick mirroring references

class Button
  attr_accessor :value
  def initialize(x: 0, y: 0, w: 200, h: 50, text: "", bg: [0,0,0],
                 fg: [255,255,255], dim: [127,127,127], toggle: false, font: '', value: false )
    @x = x
    @y = y
    @w = w
    @h = h
    @bg = bg
    @fg = fg
    @dim = dim
    @toggle = toggle
    @text = text
    @font = font
    @mouse = $gtk.args.inputs.mouse
    @value = value
    @label = Label.new(x: @x + @w / 2, y: @y + 40, text: @text,
                      font_size: 6, font_align: 1, color: @fg, font: @font)
    @solid = Solid.new(x: @x, y: @y, w: @w, h: @h, color: @bg)
  end

  def show
    [@solid, @label]
  end

  def clicked?
    @mouse.click &&
    (@x..(@x + 200)).include?(@mouse.x) && (@y..(@y + 50)).include?(@mouse.y)
  end

  def switch
    @value = !@value
    if @toggle
      (@label.color = (@label.color == @fg) ? @dim : @fg)
    end
  end
end
