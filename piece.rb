
class Piece
  attr_accessor :pos, :color, :board
  
  def initialize(board, pos, color)
    @board = board
    @pos = pos
    @color = color
  end

  def move(pos)
    @pos = pos
  end
  
  def valid_moves(ymoves)
    valids = []
    xmoves = [[-1,0], [1, 0]]
    ymoves.each do |y|
      xmoves.each do |x|
        if  valid_board(@pos.cmove(x, y)) && !valid_enemy(@pos.cmove(x, y))
          if !valid_friend(@pos.cmove(x, y))
            valids << @pos.cmove(x, y)
          end
        end
      end
    end
    valids
  end
    
  def valid_jumps(ymoves)
    valids = []
    xmoves = [[-1,0], [1, 0]]
    ymoves.each do |y|
      xmoves.each do |x|
        if valid_enemy(@pos.cmove(x,y))
          if valid_board(@pos.cmove(x,y).cmove(x,y))
            unless valid_enemy(@pos.cmove(x,y).cmove(x,y))
              unless valid_friend(@pos.cmove(x,y).cmove(x,y))
                valids << @pos.cmove(x,y).cmove(x,y)
              end
            end
          end
        end
      end
    end

    valids
  end

  def valid_enemy(position)
    # TA: beware if/else with return true/false. One liner:[1]][pos[0]
    # @board[move] != nil && @board[move].color != @color[1]][pos[0]
    if valid_board(position)
      if @board[position] != nil &&  @board[position].color != @color
        return true
      end
    end
    false
  end

  def valid_board(pos)
    if pos[0].between?(0,7) && pos[1].between?(0,7)
      return true
    end
    false
  end
  
  def valid_friend(pos)
    if  @board[pos] != nil &&  @board[pos].color == @color
      return true
    end
    false
  end
end

class Checker < Piece
  def symbol
    return ' O '
  end
  
  def valid_moves
    @color == :white ? ymoves = [[0, -1]] : ymoves = [[0, 1]]
    super(ymoves)
  end
  
  def valid_jumps
    @color == :white ? ymoves = [[0, -1]] : ymoves = [[0, 1]]
    super(ymoves)
  end
end

class King < Piece
  def symbol 
    return ' K '
  end
  
  def valid_moves
    ymoves = [[0, -1], [0, 1]]
    super(ymoves)
  end
  
  def valid_jumps
    ymoves = [[0, -1], [0, 1]]
    super(ymoves)
  end
end

class Array
  def cmove(array1, array2)
    new_array = []
    new_array[0] = self[0] + array2[0] + array1[0]
    new_array[1] = self[1] + array2[1] + array1[1]
    new_array
  end
end