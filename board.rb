require "./piece"
require 'debugger'
# encoding: utf-8

class Board
  
  attr_accessor :selected, :current_player, :board
  
  def initialize
    @board = Array.new(8) {Array.new(8) {nil}}
    @selected = [3,4]
    @selected_piece = nil
    # TA: make valid_moves a method. Use the @selected variable to calculate.
    @current_player = :white
    place_pieces
  end
  
  def place_pieces
    (5..7).each do |row|
      (0..7).each do |col|
        make_checker([col, row], :white )if (col + row) % 2 == 1 
      end
    end
    (0..2).each_with_index do |row|
      (0..7).each_with_index do |col|
        make_checker([col, row], :black )if (col + row) % 2 == 1 
      end
    end
  end
  
  def select_piece
    self[@selected] != nil ? @selected_piece = self[@selected.dup] : nil
  end
  
  def deselect
    @selected_piece = nil
  end
  
  def move!(move_pos)
    jump = false
    if (move_pos[0] - @selected_piece.pos[0]).abs > 1
      jump = true
    end
    self[move_pos] = @selected_piece
    self[@selected_piece.pos] = nil
    if jump == true
      killed = @selected_piece.pos.mid_point(move_pos)
      @board[killed[1]][killed[0]] = nil
      self[move_pos].move(move_pos)
      return 'jumped' 
    end
    self[move_pos].move(move_pos)
    @selected_piece = nil
    return 'finished'
    jump = false
  end
  
  def valid_moves(jumps)
    moves = []
    if jumps == true
      if @selected_piece != nil
        moves = @selected_piece.valid_jumps unless @selected_piece == nil
      end
    else
      if @selected_piece != nil
        moves = @selected_piece.valid_jumps + @selected_piece.valid_moves
      end
    end
    moves
  end
  
  def dup_board
    board_dup = Board.new
    all_pieces.each do |piece|
      new_piece = piece.clone
      new_piece.board = board_dup
      board_dup.place_piece(new_piece)
    end
    board_dup
  end
  
  def place_piece(piece)
    self[piece.pos] = piece
  end
  
  def all_pieces
    piece_array = []
    @board.each do |row|
      row.each do |piece|
        piece_array << piece unless piece.nil?
      end
    end
    piece_array
  end
  
  def player_pieces(color)
    array = []
    all_pieces.each do |piece|
      if piece.color == color 
        array << piece
      end
    end
    array
  end
  
  def crowning
    [:black, :white].each do |color|
      checkers = player_pieces(color).select { |piece| piece.is_a?(Checker) }
      checkers.each do |checker|
        if color == :white
          if checker.pos[1] == 0
            position = checker.pos.dup
            self[position] = King.new(self, position, color)
            @selected_piece = nil
            return true
          end
        elsif checker.pos[1] == 7
          position = checker.pos.dup
          self[position] = King.new(self, position, color)
          @selected_piece = nil
          return true
        end
      end
    end
    false
  end
  
  def make_checker(pos, color)
    piece = Checker.new(self, pos, color)
    self[pos] = piece
  end
  
  def [](position)
    @board[position.last][position.first]
  end
  
  def []=(pos, piece)
    @board[pos.last][pos.first] = piece
  end
  
  def render(jump)
    valids = valid_moves(jump)
    system('clear')
    @board.each_with_index do |row, row_ind|
      row.each_with_index do |piece, col_ind|
        if piece != nil
          display = ''
          if piece.color == :white
            display = 'piece.symbol.blue.bold'
          else
            display = 'piece.symbol.red.bold'
          end
        else
          display = "'   '"
        end
        if @selected == [col_ind, row_ind]
          if current_player == :white
            display = display + '.bg_cyan'
          else
            display = display + '.bg_magenta'
          end
        elsif valids.include?([col_ind, row_ind])
          display = display + '.bg_green'
        elsif (row_ind + col_ind) % 2 != 0
          display = display + '.bg_black'
        else
          display = display + '.bg_gray'
        end
        print eval(display)
      end
      puts
    end
  end
end

class Array
  def mid_point(array2)
    answer = []
    answer[0] = (self[0] + array2[0]) / 2
    answer[1] = (self[1] + array2[1]) / 2
    answer
  end
end

class String
def black;          "\033[30m#{self}\033[0m" end
def red;            "\033[31m#{self}\033[0m" end
def green;          "\033[32m#{self}\033[0m" end
def brown;          "\033[33m#{self}\033[0m" end
def blue;           "\033[34m#{self}\033[0m" end
def magenta;        "\033[35m#{self}\033[0m" end
def cyan;           "\033[36m#{self}\033[0m" end
def gray;           "\033[37m#{self}\033[0m" end
def bg_black;       "\033[40m#{self}\033[0m" end
def bg_red;         "\033[41m#{self}\033[0m" end
def bg_green;       "\033[42m#{self}\033[0m" end
def bg_brown;       "\033[43m#{self}\033[0m" end
def bg_blue;        "\033[44m#{self}\033[0m" end
def bg_magenta;     "\033[45m#{self}\033[0m" end
def bg_cyan;        "\033[46m#{self}\033[0m" end
def bg_gray;        "\033[47m#{self}\033[0m" end
def bold;           "\033[1m#{self}\033[22m" end
def reverse_color;  "\033[7m#{self}\033[27m" end
end



