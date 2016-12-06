class DiceSet
  def self.roll(count)
    count.times.map { rand(1..6) }
  end
end
