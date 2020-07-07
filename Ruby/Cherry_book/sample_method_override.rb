# メソッドのオーバーライド

class Product
  attr_reader :name, :price

  def initialize(name, price)
    @name = name
    @price = price
  end

  def to_s
    "name: #{name}, price: #{price}"
  end
end

class DVD < Product
  attr_reader :running_time

  def initialize(name, price, running_time)
    super(name, price)
    @running_time = running_time
  end

  def to_s
    # name と price は スーパークラス である Productと同じなので
    # super で スーパークラス の to_s を呼び出す
    "#{super}, running_time: #{running_time}"
  end
end

product = Product.new('A great movie',1000)
product.to_s

dvd = DVD.new('An awesome film', 3000, 120)
dvd.to_s
