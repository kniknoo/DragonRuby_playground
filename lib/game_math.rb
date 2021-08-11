
# TODO Other types of noise generation. Make perlin multidimensional. Implement Kenneth's noise
# vector math section in addition to more detailed UV gen. dot Product generalized. I reckon I'll have to figure out gravity.
# parallax system



UV = 360.times.map{|i| [Math.cos( i * Math::PI / 180), Math.sin( i * Math::PI / 180)] }




# from Kenneth | CANICVS
def trig_noise(octaves)
  offsets = octaves.times.map{|_| rand*2*Math::PI}
  freqs = octaves.times.map{|o| o + rand + 0.5}
  return lambda do |x|
    octaves.times.map do |o|
      Math.cos((freqs[o]) * (x + offsets[o])) * (2 ** -o)
    end.reduce(&:plus)
  end
end

def demo
  generator = trig_noise(5)
  puts generator[0.0] # The square brackets are on purpose
  puts generator[0.1] # The square brackets are on purpose
  puts generator[0.2] # The square brackets are on purpose
end


class PerlinNoise
  attr_accessor :noise_map

  def initialize(res, pixel, factor: [0.05, 0.05], mode: 'smooth', vectors: 'random')
    @noise_map = []
    @res = res
    @pixel = pixel
    @factor = factor
    @mode = mode
    @vectors = vectors
    @hsync = 1.0 / res[0]
    @vsync = 1.0 / res[1]
    render_sections
  end

  def render_sections
    @res[0].times { |x| render_column(x) }
  end

  def render_column(x)
    @res[1].times do |y|
      @noise_map << [x * @pixel[0], y * @pixel[1], @pixel[0], @pixel[1],
                     grey(perlin(x * @factor[0], y * @factor[1]))]
    end
  end

  def perlin(x, y)
    xi = x.to_i
    yi = y.to_i
    interpolate(calc(xi, 1 + xi, yi, x, y), calc(xi, 1 + xi, 1 + yi, x, y), y - yi, @mode)
  end

  def interpolate(a0, a1, w, type = '')
    case type
    when 'linear' then (1 - w) * a0 + w * a1
    when 'smooth' then w**2 * (3 - 2 * w) * (a1 - a0) + a0
    else (a0 + a1) * w
    end
  end

  def calc(x1, x2, y1, x, y)
    interpolate(dot_product(x1, y1, x, y), dot_product(x2, y1, x, y), x - x1, @mode)
  end

  def dot_product(ix, iy, x, y)
    (x - ix) * vecs(ix, iy, @vectors).value(0) + (y - iy) * vecs(ix, iy, @vectors).value(1)
  end

  def vecs(ix, iy, type = '')
    #return [Math.cos(ix * iy), Math.sin(ix * iy)] unless type == 'random'

    random = 2920 * Math.sin(ix * 21_942 + iy * 171_324 + 8912) *
             Math.cos(ix * 23_157 * iy * 217_832 + 9758)
    [Math.cos(random), Math.sin(random)]
  end

  def grey(val)
    level = (val * 127 + 127).to_i
    [level, level, level]
  end
end

=begin
Fiber example
if args.state.tick_count.zero?
  $test = Fiber.new do
    80.times do |x|
      45.times do |y|
        args.static_solids << [x * 16,y * 16,16,16,[x * 3 ,0,y * 5]]
      end
      Fiber.yield
    end
  end
end
$test.resume if $test.alive?
=end

def gen_noise(count)
  count = [count] if count.class == Fixnum
  vals = count.first.times.map do
    count.size == 1 ? rand : gen_noise(count[1..-1])
  end
  vals << vals.first
end

def value_noise(nodes = 10, steps = 80, seed = Time.now.to_i)
  noise = gen_noise(nodes)
  step_size = nodes / steps.to_f
  steps.times.map do |i|
    x = i * step_size
    xi = x.to_i
    interpolate(noise[xi], noise[xi + 1], x - xi)
  end
end

def value_noise_2d(nodes = [10, 10], steps = [128, 72], seed = Time.now.to_i)
  $gtk.set_rng(seed)
  noise = gen_noise(nodes)
  step_size = [nodes[0] / steps[0].to_f, nodes[1] / steps[1].to_f ]
  quant = 255
  steps[0].times.map do |i|
    y = i * step_size[0]
    yi = y.to_i
    steps[1].times.map do |j|
      x = j * step_size[1]
      xi = x.to_i
      nx0 = quantize(interpolate(noise[yi][xi], noise[yi][xi + 1], x - xi), quant)
      nx1 =  quantize(interpolate(noise[yi + 1][xi], noise[yi + 1][xi + 1], x - xi), quant)
      quantize(interpolate(nx0, nx1, y - yi), quant)
    end
  end
end

def interpolate(low, high, weight)
  #low * (1 - weight) + high * weight
  #weight**2 * (3 - 2 * weight) * (high - low) + low
  ((6 * weight**5) - (15 * weight**4) + (10 * weight**3)) * (high - low) + low
end

def quantize(value, count )
 (value * count).to_i / count.to_f
end

#$v_noise = value_noise(11, 400)
#$h_noise = value_noise(13, 500)
#$c_noise = value_noise(17, 600)
#$noise = value_noise_2d([30,20], [160, 90])

=begin
  if args.state.tick_count.zero?
    args.render_target(:noise_map).solids <<
    $noise.map.with_index do |col, ci|
      col.map.with_index {|val, vi| [ci * 8, vi * 8, 8, 8, hues(val, 3) ]}
    end
  end
  args.sprites << [0, 0, 1280, 720, :noise_map]
  args.primitives << 10.times.map do |i|
                  [$h_noise[(args.state.tick_count + i * 127) % $h_noise.size] * 1230,
                  $v_noise[(args.state.tick_count + i * 183) % $v_noise.size] * 670,
                  8, 8, hues($c_noise[(args.state.tick_count + i * 197) % $c_noise.size], 2)
                ].solid
              end
=end



def sharpen(noise, overtones)
  index = overtones - 1
  sharp_vals = Array.new(noise.size * 2**(index), 0)
  sharp_vals.map!.with_index do |val, svi|
    val = overtones.times.map do |overtone|
      #0,1,2 => 1,2,4
      freq = 2**( overtone)
      #012   => 1,1/2,1/4
      amp = 1.0 / 2**overtone
      # noise[0/1 %noise.size]
      noise[(svi / freq) % noise.size] * amp
    end.reduce(&:plus)
  end
  maxval = sharp_vals.max
  sharp_vals.map! {|val| val / maxval}
  #overtones.times do |overtone|
    #freq = index - overtone
    #amp = 1.0 / 2**overtone
    #.map {}
    # map values starting with base test with 3 overtones
    #0, 1, 2        => 2, 1, 0        => 0, 1, 2
    # base value once every 2 ** 2 (4) values at 1 / 2**0 amplitude
    # 2nd value once every 2 ** 1 (2) values at 1 / 2**1  amp
    # 3rd value every      2 ** 0 at            1 / 2**2 amp

    #find max value and scale to unisgned float 0..1
  #end
end

#$sval = sharpen(TEST, 2)


=begin
  if args.state.tick_count.zero?
    args.render_target(:testing).solids <<
    $sval.map.with_index do |val, ci|
     [ci * 1, 0, 1, val * 320]
    end
  end
  args.sprites << [0, 0, 640, 360, :testing]
=end
