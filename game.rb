require "./board"
require "./player"

class Game
  attr_reader :board, :current_player
  
  def initialize
    @board = Board.new
    @player1 = Watson.new(:white, @board)
    @player2 = Watson.new(:black, @board)
    @curr_player = @player1
  end
  
  def run
    @board.render(false)
    loop do
      turn(@curr_player)
    end
  end
  
  def turn(player)
    finished = false
    jumped = false
    @board.render(jumped)
    until finished == true  
      action = player.selector_actions(jumped)
      @board.render(jumped)
      finished = true if action == 'finished'
      jumped = true if action == 'jumped'
    end
    switch_player
  end
  
  def switch_player
    @curr_player.color == :white ? @curr_player = @player2 : @curr_player = @player1
    @board.current_player = @curr_player.color
  end
end


if __FILE__ == $PROGRAM_NAME
  chess = Game.new
  chess.run
end