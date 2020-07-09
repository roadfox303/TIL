class Tempo
  include Comparable
  attr_reader :bpm

  def initialize(bpm)
    @bpm = bpm
  end

  def <=>(other)
    if other.is_a?(Tempo)
      # bpm を比較した結果を返す。
      bpm <=> other.bpm
    else
      # 比較できない場合はnilを返す。
      nil
    end
  end

  #irb上で見やすくするためにinspectメソッドをオーバーライド
  def inspect
    "#{bpm}bpm"
  end
end
