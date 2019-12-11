
class Board
  attr_accessor :player #for RSpec tests

  def initialize
    @player = "w"
    @board = [
      [Rook.new("b"), Knight.new("b"), Bishop.new("b"), Queen.new("b"),
      King.new("b"), Bishop.new("b"), Knight.new("b"), Rook.new("b")],
      [Pawn.new("b"), Pawn.new("b"), Pawn.new("b"), Pawn.new("b"),
      Pawn.new("b"), Pawn.new("b"), Pawn.new("b"), Pawn.new("b")],
      [nil, nil, nil, nil, nil, nil, nil, nil],
      [nil, nil, nil, nil, nil, nil, nil, nil],
      [nil, nil, nil, nil, nil, nil, nil, nil],
      [nil, nil, nil, nil, nil, nil, nil, nil],
      [Pawn.new("w"), Pawn.new("w"), Pawn.new("w"), Pawn.new("w"),
      Pawn.new("w"), Pawn.new("w"), Pawn.new("w"), Pawn.new("w")],
      [Rook.new("w"), Knight.new("w"), Bishop.new("w"), Queen.new("w"),
      King.new("w"), Bishop.new("w"), Knight.new("w"), Rook.new("w")]
    ]
  end

  def print_board
    letters = "  a b c d e f g h"
    i = 8
    puts letters
    @board.each do |row|
      print "#{i.to_s} "
      row.each do |piece|
        if piece.nil?
          print "·"
        else
          print piece.symbol
        end
          print " "
      end
      puts "#{i.to_s}"
      i -= 1
    end
    puts letters
  end

  def move(from, to)
    if from[0] !~ /[a-h]/ || from[1] !~ /[1-8]/ || to[0] !~ /[a-h]/ || to[1] !~ /[1-8]/
      return "error_outside_board"
    end

    from = convert_to_row_and_column_indexes(from)
    to = convert_to_row_and_column_indexes(to)
    piece = get_piece(from)

    if piece.nil? || piece.player != @player
      return "error_not_player_piece"
    end
    
    case piece.check_move(@board, from, to)
    when "illegal"
      return "error_illegal_move"
    when "promotion"
      #todo: add a way to promote pawn into desired piece
    when "en_passantable"
      #todo: make pawn's @en_passantable false after one enemy move
    when "en_passant_capture"
      #todo: capture the pawn one row behind current pawn's to position
    when "castling"
      #(make possible only by applying the move to king)
      #todo: move rook first, then let king make his move below
    end

    @board[from[:row]][from[:column]] = nil
    @board[to[:row]][to[:column]] = piece
  end

  def convert_to_row_and_column_indexes(pos)
    row = (pos[1].to_i - 8).abs
    column = pos[0].ord - 97
    {row: row, column: column}
  end

  def get_piece(pos)
    if pos.is_a?(String) #for RSpec testing
      pos = convert_to_row_and_column_indexes(pos)
    end
    @board[ pos[:row] ][ pos[:column] ]
  end
end



class Pawn
  attr_reader :symbol, :player, :en_passantable
  
  def initialize(player)
    @player = player
    @en_passantable = false
    if player == "w"
      @symbol = "♟"
      @starting_row = 6
    else
      @symbol = "♙"
      @starting_row = 1
    end
  end

  def check_move(board, from, to)
    @player == "w" ? i = 1 : i = -1

    if from[:row] == to[:row] + 2*i && from[:column] == to[:column]
      if board[to[:row]][to[:column]].nil?
        from[:row] == @starting_row ? "ok" : "illegal"
        #todo: add @en_passantable = true
        #todo: and return "en_passantable"
      end
    elsif from[:row] == to[:row] + 1*i
      if from[:column] == to[:column]
        board[to[:row]][to[:column]] == nil ? "ok" : "illegal"
      elsif to[:column] == from[:column] + 1 || to[:column] == from[:column] - 1
        if board[to[:row]][to[:column]].nil?
          piece_behind = board[to[:row]-1*1][to[:column]]
          if piece_behind.is_a?(Pawn) && piece_behind.en_passantable
            return "en_passant_capture"
          else
            return "illegal"
          end
        else
          board[to[:row]][to[:column]].player != @player ? "ok" : "illegal"
        end
      else
        return "illegal"
      end
    else
      return "illegal"
    end
  end
end


class Rook
  attr_reader :symbol
  
  def initialize(player)
    @player = player
    player == "w" ? @symbol = "♜" : @symbol = "♖"
  end

  def move_ok?(board)
    #check if move is possible
  end
end

class Knight
  attr_reader :symbol
  
  def initialize(player)
    @player = player
    player == "w" ? @symbol = "♞" : @symbol = "♘"
  end

  def move_ok?(board)
    #check if move is possible
  end
end

class Bishop
  attr_reader :symbol
  
  def initialize(player)
    @player = player
    player == "w" ? @symbol = "♝" : @symbol = "♗"
  end

  def move_ok?(board)
    #check if move is possible
  end
end

class Queen
  attr_reader :symbol
  
  def initialize(player)
    @player = player
    player == "w" ? @symbol = "♛" : @symbol = "♕"
  end

  def move_ok?(board)
    #check if move is possible
  end
end

class King
  attr_reader :symbol

  def initialize(player)
    @player = player
    player == "w" ? @symbol = "♚" : @symbol = "♔"
  end

  def move_ok?(board)
    #check if move is possible
  end
end