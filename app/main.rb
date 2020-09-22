require 'lib/label.rb'
require 'lib/solid.rb'
require 'lib/border.rb'
require 'lib/line.rb'
require 'lib/sprite.rb'

$bob = Border.new(x: 200)
#$bob.args = $gtk.args
def tick args
  $bob.out
end
