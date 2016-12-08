require_relative 'player'
require_relative 'dice_set'

class Game
  def initialize(players_count, dice_count = 5)
    @players = players_count.times.map { |n| Player.new("player#{n + 1}") }
    @dice_count = dice_count
  end

  def self.create()
    print "Enter number of players: "
    begin
      players = Integer(gets.chomp, 10)
      Game.new(players)
    rescue ArgumentError
      puts "Invalid number"
      Game.create()
    end
  end

  def play()
    final_player = nil
    turns = 1
    while !final_player
      puts "Turn #{turns}:\n--------"
      turns += 1

      @players.each do |player|
        roll_dice(player)
        if player.has_max_score?
          final_player = player
          break
        end
      end
    end
    play_final(final_player)
  end

  def roll_dice(player)
    next_dice_count = @dice_count

    while next_dice_count > 0
      roll = DiceSet.roll(next_dice_count)
      puts "\nPlayer #{player.id} rolls: #{roll.join(', ')}"
      score, next_dice_count = Game.compute_score(roll)
      puts "Score in this round: #{score}"
      player.add_turn_score(score)
      puts "Total score: #{player.total_turn_score}"

      if next_dice_count > 0
        print "Do you want to roll the non-scoring #{next_dice_count} #{next_dice_count > 1 ? 'dice' : 'die'} (y/n): "
        next_dice_count = 0 if gets.chomp != 'y'
      end
    end
    player.end_turn
  end

  def play_final(final_player)
    puts "\n\n\nFinal round"
    active_winner = final_player
    @players.each do |player|
      if player != final_player
        roll_dice(player)
        #TODO ties
        active_winner = player if player.total_score > active_winner.total_score
      end
    end
    puts "Winner - player ID: #{active_winner.id}, score: #{active_winner.total_score}"
  end

  def self.compute_score(dice)
    main_set = nil
    total = 0
    non_scoring = 0
    sets = dice.reduce({}) do |sets, n|
      count = sets[n] = (sets[n] || 0) + 1
      if count == 3
        sets.delete(n)
        main_set = n
      end
      sets
    end

    set_score = ->(value, n = 1) {
      score =
        case value
        when 1
          100 * n
        when 5
          50 * n
        else 0
        end

      if score == 0
        non_scoring += n
      else
        total += score
      end
    }

    if main_set == nil
      dice.each &set_score
    else
      total = main_set == 1 ? 1000 : main_set * 100
      sets.each { |k, v| set_score[k, v] }
    end

    return 0, 0 if total == 0
    return total, non_scoring
  end
end


game = Game.create
game.play
