<<<<<<< HEAD

require 'lib/dragon_object.rb'
require 'lib/ui_element.rb'
require 'lib/game_math.rb'
require 'lib/color.rb'
require 'lib/shape.rb'
require 'lib/test.rb'



#$gtk.args.outputs.clear

#$test = Solid.new
#$testprim = [Solid.new(color: [127, 0, 127]),
#             Label.new(text: "Ohai!"),
#             Sprite.new(path: 'sprites/hexagon-orange.png',
#             color: [255,255,255,127], w: 100, h: 100) ]

#$test = Composite.new($testprim)
=begin
$sky = Shape.gradient_solid(colors: Color.gradient(INDIGO, BLACK, 40) )
$stars = 100.times.map do
  StaticSolid.new(x: rand(1280), y: rand(320) + 400,
                  h: rand(2) + 1, w: rand(2) + 1, color: WHITE)
end
$ground = Shape.gradient_solid(h: 360, colors: Color.gradient([0, 63, 0], BLACK, 20) )
$mts = 20.times.map do
  Shape.gradient_triangle(x: rand(135) * 10 - 200, y: 360,
                          w: (rand(35) + 20) * 10, h: (rand(10) + 2) * 10,
                          colors: Color.gradient(BLACK, [63, 0, 63], rand(20) + 10) )
end

$moon = Shape.radial_circle(x: 1000, y: 600, magnitude: 30, color: [255,255,200])

$bldgs = 50.times.map do
  StaticSolid.new(x: rand(1280), y: rand(40) + 280,
                  w: 20, h: rand(50) + 50, color: GRAY[10])
end

def tick(args)
  args.outputs.background_color = [0,0,0]

  $stars.shuffle.take(2).each do |star|
    rand < 0.5 ? star.w = rand(2) + 1 : star.h = rand(2) + 1
  end if args.state.tick_count % 3 == 0

  $mts.each do |mt|
    if mt[0].x + mt[0].w < 0
      mt.each {|terrace| terrace.x += 1300 + mt[0].w}
    else
      mt.each { |terrace| terrace.x -= 0.1 }
    end
  end
  $bldgs.each {|bldg| bldg.x -= 0.15; bldg.x = 1300 + rand(40) if bldg.x < -31}
=======
class Button
  attr_accessor :text
  def initialize(x, y, text)
    @x = x
    @y = y
    @w = 65
    @h = -65
    @text = text
    @color = [150, 150, 150]
  end

  def show
    [[@x, @y, @w, @h, @color].solid,
    [@x + 20, @y - 10, @text, 12].label]
  end

  def clicked?
    (@x..(@x + @w)) === $gtk.args.inputs.mouse.x &&
    ((@y + @h)..@y) === $gtk.args.inputs.mouse.y
  end
end

class Display
  attr_accessor :text
  def initialize
    @x = 500
    @y = 550
    @text = "0"
  end
  def show
    [[@x, @y, 275, -65, [250,250,250]].solid,
    [@x + 273, @y - 10, @text, 12, 2].label]
  end
end

$display = Display.new
$values = [["7", "8", "9", "*"],
           ["4", "5", "6", "/"],
           ["1", "2", "3", "-"],
           ["0", ".", "=", "+"]]
$buttons = $values.map.with_index do |row, y|
  row.map.with_index do |val, x|
    Button.new(500 + (x * 70), 450 - (y * 70), val)
  end
end

$operand1 = ""
$operand2 = ""
$operation = ""
$clear_next = false
def tick args
  args.solids << [0, 0, 1280, 720, [23, 23, 23]]
  args.solids << [426, 90, 426, 540, [46, 46, 46]]
  args.primitives << $buttons.map{|e| e.map { |f| f.show }}
  args.primitives << $display.show
  if args.inputs.mouse.click
    $buttons.each do |row|
      row.each do |b|
        if b.clicked?
          case b.text
          when ("0".."9") then handle_digit(b.text)
          when "." then $display.text += "." unless $display.text.include? "."
          when "=" then calculate
          else handle_operation(b.text)
          end
        end
      end
    end
  end
end

def handle_digit(digit)
  return if $display.text == "0" && digit == "0"
  $display.text = "" if $display.text == "0" || $clear_next
  return if $display.text.size > 12
  $clear_next = false
  $display.text += digit
end

def handle_operation(operation)
  $operation = operation
  $clear_next = true
  $operand1 = $display.text
end

def calculate
  $operand2 = $display.text
  $display.text = eval("#{$operand1} #{$operation} #{$operand2}").to_s[0,12]
  $clear_next = true
  $operand1 = ""
  $operand2 = ""
  $operation = ""
>>>>>>> aac6c14f6602a0f3f75cffe47a312bfd456ec3dc
end
=end
