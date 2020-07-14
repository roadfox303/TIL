# def greeting
#   puts 'おはよう'
#
#   text = yield 'こんにちは'
#   puts text
#   puts 'こんばんは'
# end
#
# greeting do |text, other|
#   text * 2 + other.inspect
# end

# ブロックをメソッドの引数として受け付ける
def greeting(&block)
  puts 'おはよう'
  # blockを受け取ってている？
  unless block.nil?
    # callメソッドを使ってブロックを実行する
    text = block.call('こんにちは')
    puts text
  end
  puts 'こんばんは'
end

greeting do |text|
  text * 2
end
