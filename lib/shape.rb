# TODO Diamond, non-radial circles (lo-fi) advanced triangles. Vertical variations. 



=begin
$bg = 47.times.map do |i|
  StaticSolid.new(y: i * 16, h: 16, w: 1280, color: BLACK)
end
$square = 50.times.map do |i|
  StaticSolid.new(x: 540 + i * 4, y: 260, h: 200, w: 4, color: BLACK)
end
$triangle = 200.times.map do |i|
  StaticSolid.new(x: 240 + i / 2, y: 260 + i, h: 1, w: 201 - i, color: BLACK)
end

$diamond = 200.times.map do |i|
  StaticLine.new(x: 840 + i / 2  , y: 361 + i / 2 , x2: 940 + i / 2, y2: 261 + i / 2 , color: BLACK)
end

$sun = 360.times.map {|i| StaticLine.new(x: 640, y: 560, x2: 640 + UV[i][0] * 100, y2: 560 + UV[i][1] * 100)}

=end
UV = 360.times.map{|i| [Math.cos( i * Math::PI / 180), Math.sin( i * Math::PI / 180)] }

class Shape

  def self.gradient_solid(x: 0, y: 0, w: 1280, h: 720, colors: [[0,0,0], [255,255,255]], vertical: false)
    colors.map.with_index do |color, i|
      StaticSolid.new(x: x, y: i * (h / colors.size), h: h / colors.size + 1, w: w, color: color)
    end
  end

  def self.gradient_triangle(x: 0, y: 0, w: 150, h: 150, colors: [[0,0,0], [127,127,127], [255,255,255]])
    colors.map.with_index do |color, i|
      StaticSolid.new(x: x + i * (w / colors.size) / 2,
                      y: y + i * (h / colors.size),
                      w: w - i * ( w / colors.size),
                      h: h / colors.size + 1,
                      color: color)
    end
  end

  def self.radial_circle(x: 640, y: 360, magnitude: 20, color: [255, 255, 255])
    360.times.map do |i|
      StaticLine.new(x: x, y: y,
                     x2: x + UV[i][0] * magnitude,
                     y2: y + UV[i][1] * magnitude,
                     color: color)
    end
  end
end

=begin
$bg.shuffle.take(2).each {|e| e.color = DULL_WHEEL[args.state.tick_count * 3 % 360]}
$square.shuffle.take(2).each {|e| e.color = HUE_WHEEL[(180 + args.state.tick_count * 3) % 360]}
$triangle.shuffle.take(2).each {|e| e.color = HUE_WHEEL[(90 + args.state.tick_count * 3) % 360]}
$diamond.shuffle.take(2).each {|e| e.color = HUE_WHEEL[(270 + args.state.tick_count * 3)  % 360]}
$sun.shuffle.take(2).each {|e| e.color = HUE_WHEEL[(270 + args.state.tick_count * 3)  % 360]}
$bg.each do |e|
  e.y += 1
  e.y = -15 if e.y > 724
end
=end
