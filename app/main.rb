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
end
