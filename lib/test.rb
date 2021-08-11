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
class Player < StaticSolid
  def move
      @y += 10 if @args.inputs.up
      @y -= 10 if @args.inputs.down
      @x -= 10 if @args.inputs.left
      @x += 10 if @args.inputs.right
  end
end
$player = Player.new(x: 640, y: 480, w: 50, h: 50, color: RED)

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
  $player.move
end
