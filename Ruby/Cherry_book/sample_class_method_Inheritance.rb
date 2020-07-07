# クラスメソッドの継承

class Foo
  def self.hello
    'hello'
  end
end

class Bar < Foo
end

Foo.hello
Bar.hello
