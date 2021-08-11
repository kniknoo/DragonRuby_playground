# Create a Keyboard and Mouse Class. These should not be instances. Test Controller eventually.



return unless $gtk.args.keyboard.key_down.raw_key
$label.text += if shift_held?
  case args.keyboard.key_down.raw_key
  when 39 then "\""
  when 44 then "<"
  when 45 then "_"
  when 46 then ">"
  when 47 then "?"
  when 48 then ")"
  when 49 then "!"
  when 50 then "@"
  when 51 then "#"
  when 52 then "$"
  when 53 then "%"
  when 54 then "^"
  when 55 then "&"
  when 56 then "*"
  when 57 then "("
  when 59 then ":"
  when 61 then "+"
  when 91 then "{"
  when 92 then "|"
  when 93 then "}"
  when (97..122) then (args.keyboard.key_down.raw_key - 32 ).chr
  end
else
  case args.keyboard.key_down.raw_key
  when 8 then "Backspace"
  when 9 then "Tab"
  when 13 then "Return"
  when 27 then "Esc"
  when 32 then " "
  when 39 then "\'"
  when (44..57) then args.keyboard.key_down.raw_key.chr
  when 59 then ";"
  when 61 then "="
  when (91..93) then args.keyboard.key_down.raw_key.chr
  when (97..122) then args.keyboard.key_down.raw_key.chr
  end
end
#$label.text += args.keyboard.key_down.char
#$label.text =  "ALt_Left!" if args.keyboard.key_held.truthy_keys.include?(:alt)

def key_press?
  $gtk.args.keyboard.key_down.raw_key
end

def shift_held?
  $gtk.args.keyboard.key_down.shift ? true : false
end
