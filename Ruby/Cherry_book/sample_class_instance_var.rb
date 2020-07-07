class Product
  @name = "Product"

  def self.name
    # クラスインスタンス変数
    @name
  end

  def initialize(name)
    # インスタンス変数
    @name = name
  end

  def name
    # インスタンス変数
    @name
  end
end

class DVD < Product
  @name = 'DVD'
  def self.name
    # クラスインスタンス変数を参照
    @name
  end

  def upcase_name
    # インスタンス変数を参照
    @name.upcase
  end
end

Product.name
DVD.name

product = Product.new('movie contents')
product.name

dvd = DVD.new('intersteler')
dvd.name
dvd.upcase_name

Product.name
DVD.name
