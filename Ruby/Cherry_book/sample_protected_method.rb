class User
  # weight は外部に公開しない
  attr_reader :name

  def initialize(name, weight)
    @name = name
    @weight = weight
  end

  # 自分が other_user より重い場合は true

  def heavier_than?(other_user)
    other_user.weight < @weight
  end

  protected
  # protected メソッドなので同じクラスかサブクラスであればレシーバ付きで呼び出せる。
  def weight
    @weight
  end
end

alice = User.new('Alice', 50)
bob = User.new('bob', 60)
# 同じクラスのインスタンスメソッド内では weight が呼び出せる
alice.heavier_than?(bob)
bob.heavier_than?(alice)
# クラスの外では weight は呼び出せない
alice.weight
