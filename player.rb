require 'yaml'

class Player
  attr_accessor :color, :selector
  
  def initialize(color, board)
    @color = color
    @board = board
    @selector = @board.selected
  end
  
  def selector_actions(jumped)
    if @board.crowning
      @board.deselect
      return 'finished'
    elsif jumped == true && @board.valid_moves(jumped).empty?
      @board.deselect
      return 'finished'
    end
    
    begin
      system("stty raw -echo")
      input = STDIN.getc.chr
    ensure
      system("stty -raw echo")
    end
    
    case input 
    when 'l'
      cursor([1, 0])
    when 'j'
      cursor([-1, 0])
    when 'i'
      cursor([0, -1])
    when 'k'
      cursor([0, 1])
    when 's'
      if jumped == true
        if @board.valid_moves(jumped).empty?
          @board.deselect
          return 'finished'
        elsif @board.valid_moves(jumped).include?(@selector)
          @board.move!(@selector.dup)
        else
          puts 'not valid'
        end
      elsif @board[@selector] != nil && @board[@selector].color == @color
        @board.select_piece
      elsif @board.valid_moves(jumped).include?(@selector)
        @board.move!(@selector.dup)
      else
        puts 'not valid'
      end
        
    # when '2'
#       contents = File.read("save_file.txt")
#       saved_game = YAML::load(contents)
#       @board = saved_game
#     when '1'
#       save_file = @board.to_yaml
#       f = File.open("save_file.txt", "w+") do |f|
#         f.write(save_file)
#         f.close
#       end
    when 'q'
      quit
    else
      puts 'invalid entry'
      selector_actions(jumped)
    end
  end
  
  def quit
    puts "exiting checkers"
    exit
  end
  
  def cursor(move)
    @selector[0] = (@selector[0] + move.first) % 8
    @selector[1] = (@selector[1] + move.last) % 8
  end
  
  # TA: Move me to the board!
  def display_moves(piece)
    moves = piece.valid_moves
    @board.valid_moves = moves
  end
end



class Computer < Player
  def initialize(color, board)
    super(color, board)
  end
  
  def selector_actions(jumps)
    think(jumps)
  end
end

class DeepBlue < Computer
  
  def think(jumps)
    sleep(4.0/24.0)
    placement = nil
    random_piece = nil
    if @board.crowning
      @board.selected = @selector
      return 'finished'
    end
    if jumps == true
      if @board.valid_moves(jumps).empty?
        @board.selected = @selector
        return 'finished'
      else     
        placement = @board.valid_moves(jumps).sample
      end
    else
      until placement != nil && random_piece.valid_board(placement)
        random_piece = @board.player_pieces(@color).sample
        @board.selected = random_piece.pos
        @board.select_piece()
        placement = @board.valid_moves(jumps).sample
      end
    end
    action = @board.move!(placement)
    if action == 'finished'
      @board.selected = @selector
      return 'finished'
    else
      return 'jumped'
    end
  end
end


class Watson < DeepBlue
  
  def think(jumps)
    moves = {}
    value = 0
    pieces = @board.player_pieces(@color).shuffle
    pieces.each do |piece|
      @board.selected = piece.pos
      @board.select_piece()
      valids = @board.valid_moves(jumps)
      valids.each do |move|
        next unless piece.valid_board(move)
        if piece.valid_jumps.include?(move)
          @board.selected = @selector
          return @board.move!(move)
        end
        if [0,7].include?(move[1]) && piece.class.name == "Checker"
          p 'kinging'
          @board.selected = @selector
          return @board.move!(move)
        end
      end
    end
    return super(jumps)
  end
end
      






























    