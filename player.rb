class Player
  attr_reader :total_score, :id

  def initialize(id)
    @id = id
    @total_score = 0
    @turn_score = 0
  end

  def add_turn_score(score)
    @turn_score = score == 0 ? 0 : (@turn_score + score)
  end

  def can_accumulate?()
    @total_score >= 300
  end

  def total_turn_score()
    if can_accumulate? # || @turn_score >= 300
      @total_score + @turn_score
    else
      0
    end
  end

  def has_max_score?()
    @total_score >= 3000
  end

  def end_turn()
    @total_score += @turn_score if can_accumulate? || @turn_score >= 300
    @turn_score = 0
  end
end
