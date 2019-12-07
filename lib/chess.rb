
class Board
  def initialize
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

class Pawn
  attr_reader :symbol
  
  def initialize(player)
    @player = player
    player == "w" ? @symbol = "♟" : @symbol = "♙"
  end

  def move_ok?(board)
    #check if move is possible
  end
end