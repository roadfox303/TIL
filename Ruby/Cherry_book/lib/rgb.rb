# def to_hex(r, g, b)
#   hex = "#"
#   [r,g,b].each do |n|
#     hex += n.to_s(16).rjust(2,'0')
#   end
#   hex
# end
def to_hex(r, g, b)
  [r, g, b].inject('#') do |hex, n|
    hex + n.to_s(16).rjust(2,'0')
  end
end
# injectでさらにリファクタリングできる

# def to_ints(hex)
#   r = hex[1..2]
#   g = hex[3..4]
#   b = hex[5..6]
#   ints = []
#   [r, g, b].each do |s|
#     ints << s.hex
#   end
#   ints
# end

# リファクタリング
# def to_ints(hex)
#   [hex[1..2], hex[3..4], hex[5..6]].map do |s|
#     s.hex
#   end
# end

# 正規表現でさらにリファクタリング
# def to_ints(hex)
#   hex.scan(/\w\w/).map do |s|
#     s.hex
#   end
# end

# &とシンボル　のメソッドでさらにリファクタリング
# &:メソッド名 が利用できるのは下記の3条件
# ブロック引数が１個だけである
# ブロックで呼び出すメソッドには引数がない
#　ブロックの中では、ブロック引数に対してメソッドを一回呼び出す以外に処理がない。
# &:hex は ブロック引数:メソッド　という意味
def to_ints(hex)
  hex.scan(/\w\w/).map(&:hex)
end
