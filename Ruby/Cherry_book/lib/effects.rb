module Effects
  def self.reverse
    ->(words) do
      words.split(' ').map(&:reverse).join(' ')
    end
  end

  def self.echo(rate)
    ->(words) do
      # スペースならそのまま返す ： スペース以外なら指定された回数繰り返して返す。
      words.chars.map { |c| c == ' ' ? c : c * rate }.join
    end
  end

  def self.loud(level)
    ->(words) do
      words.split(' ').map { |word| word.upcase + '!' * level }.join(' ')
    end
  end
end
