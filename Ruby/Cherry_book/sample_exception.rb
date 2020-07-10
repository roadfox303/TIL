puts 'Start'
module Greeter
  def hello
    'hello'
  end
end

# 例外処理を組み込んで対処する
begin

# モジュールはインスタンスを作成できないのでエラーが発生する。
greeter = Greeter.new
rescue
  puts '例外が発生したがこのまま続行する'
end

# 例外処理を組み込んだので、最後まで実行可能。
puts 'End.'
