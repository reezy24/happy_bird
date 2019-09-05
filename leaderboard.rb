class Leaderboard
  attr_accessor :board
  def initialize
    @board = { # dummy data
        John: 1,
        Zach: 2,
        Mary: 3
    }
  end
  def to_screen
    return @board.sort_by {|k, v| -v}
  end
  def new_entry(name, score)
    @board[name] = score
  end
end
