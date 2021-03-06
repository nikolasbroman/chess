class Board
  attr_accessor :player, :board #for RSpec tests

  def initialize
    @player = "w"
    @board = get_new_board
  end

  def get_new_board
    [
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

  def new_game
    print_opening_message
    loop do
      new_round
      break unless another_round?
    end
    puts
    puts "Thank you for playing."
    puts
  end

  def print_opening_message
    puts
    puts " Hello & welcome to"
    puts "-------------------"
    puts "  ♖ ♘ ♗ ♕ ♔ ♗ ♘ ♖"
    puts "  ♙ ♙ ♙ ♙ ♙ ♙ ♙ ♙"
    puts "  ♙ ♙  CHESS  ♙ ♙"
    puts "  ♟ ♟ ♟ ♟ ♟ ♟ ♟ ♟"
    puts "  ♜ ♞ ♝ ♛ ♚ ♝ ♞ ♜"
    puts "-------------------"
    puts " by Nikolas Broman"
    puts
    puts
    puts "Instructions"
    puts "-------------------"
    puts "Move your pieces by typing"
    puts "e.g. 'a2 a4' or 'b1 c3'."
    puts
    puts "You can do castling only by"
    puts "applying the move to King."
    puts
    puts "You can surrender"
    puts "by typing 'surrender'."
    puts
    puts "Have fun!"
  end

  def new_round
    puts
    puts
    puts "New Round"
    puts "-------------------"
    puts
    result = play_until_end
    do_win if result == "win"
    do_surrender if result == "surrender"
  end

  def another_round?
    puts
    puts "Play another round? (yes/no)"
    loop do
      input = gets.chomp.downcase
      case input
      when "yes", "y"
        return true
      when "no", "n"
        return false
      else
        puts "Please answer yes or no:"
      end
    end
  end

  def play_until_end
    loop do
      print_board
      print_player_turn
      move_result = make_move
      return move_result unless move_result == "ok"
      change_player
    end
  end

  def do_win
    print_board
    @player == "w" ? player_full = "White" : player_full = "Black"
    puts "#{player_full} wins!"
  end

  def do_surrender
    @player == "w" ? player_full = "White" : player_full = "Black"
    puts "#{player_full} surrenders..."
  end

  def print_player_turn
    if @player == "w"
      puts "White's turn:"
    else
      puts "Black's turn:"
    end
  end

  def make_move
    loop do
      player_move = gets.chomp.downcase
      puts
      if player_move == "surrender"
        return "surrender"
      elsif player_move !~ /^[a-h][1-8]\s*[a-h][1-8]$/
        puts "Sorry, couldn't understand you."
        puts "Please try again:"
      else
        from = player_move[0..1]
        to = player_move[-2..-1]
        move_result = move(from, to)
        case move_result
        when "error_not_player_piece"
          @player == "w" ? enemy = "black" : enemy = "white"
          puts "You can't move #{enemy}'s piece."
          puts "Please try again:"
        when "error_illegal_move"
          puts "That move is illegal."
          puts "Please try again:"
        else
          return move_result
        end
      end
    end
  end

  def change_player
    @player == "w" ? @player = "b" : @player = "w"
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
    puts
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
      capture_pawn_behind(from, to)
    when "castling"
      move_rook_next_to_king(from, to)
    end

    if @board[to[:row]][to[:column]].is_a?(King)
      return_value = "win"
    else
      return_value = "ok"
    end

    @board[from[:row]][from[:column]] = nil
    @board[to[:row]][to[:column]] = piece
    
    return return_value
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

  def move_rook_next_to_king(from, to)
    if to[:column] > from[:column]
      rook_from_column = 7
      rook_to_column = 5
    else
      rook_from_column = 0
      rook_to_column = 3
    end
    rook = @board[from[:row]][rook_from_column]
    @board[from[:row]][rook_from_column] = nil
    @board[from[:row]][rook_to_column] = rook
  end

  def capture_pawn_behind(from, to)
    @player == "w" ? i = 1 : i = -1
    @board[to[:row] + 1 * i][to[:column]] = nil
  end

end


class Pawn
  attr_reader :symbol, :player
  attr_accessor :en_passantable
  
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
        if from[:row] == @starting_row
          @en_passantable = true
          return "en_passantable"
        else
          return "illegal"
        end
      end
    elsif from[:row] == to[:row] + 1 * i
      if from[:column] == to[:column]
        return board[to[:row]][to[:column]] == nil ? "ok" : "illegal"
      elsif to[:column] == from[:column] + 1 || to[:column] == from[:column] - 1
        if board[to[:row]][to[:column]].nil?
          piece_behind = board[to[:row] + 1 * i][to[:column]]
          if piece_behind.is_a?(Pawn) && piece_behind.en_passantable
            return "en_passant_capture"
          else
            return "illegal"
          end
        else
          return board[to[:row]][to[:column]].player != @player ? "ok" : "illegal"
        end
      else
        return "illegal"
      end
    else
      return "illegal"
    end
  end
end


class King
  attr_reader :symbol, :player

  def initialize(player)
    @player = player
    player == "w" ? @symbol = "♚" : @symbol = "♔"
    @has_moved = false
  end

  def check_move(board, from, to)
    if board[to[:row]][to[:column]].nil? || board[to[:row]][to[:column]].player != @player
      if move_is_one_square_only?(board, from, to)
        @has_moved = true
        return "ok"
      end
    end
    if @has_moved == false
      if castling?(board, from, to)
        @has_moved = true
        return "castling"
      end
    end
    return "illegal"
  end

  def move_is_one_square_only?(board, from, to)
    if to[:row] == from[:row] && (to[:column] - from[:column]).abs == 1
      return true
    elsif to[:column] == from[:column] && (to[:row] - from[:row]).abs == 1
      return true
    elsif (to[:row] - from[:row]).abs == 1 && (to[:column] - from[:column]).abs == 1
      return true
    else
      return false
    end
  end

  def castling?(board, from, to)
    @player == "w" ? kings_row = 7 : kings_row = 0

    if to[:row] == kings_row
      if to[:column] == 6 && board[kings_row][7].is_a?(Rook) && board[kings_row][7].has_moved == false
        if board[kings_row][5].nil? && board[kings_row][6].nil?
          return true
        end
      elsif to[:column] == 2 && board[kings_row][0].is_a?(Rook) && board[kings_row][0].has_moved == false
        if board[kings_row][1].nil? && board[kings_row][2].nil? && board[kings_row][3].nil?
          return true
        end
      end
    end
    return false
  end
end


class Queen
  attr_reader :symbol, :player
  
  def initialize(player)
    @player = player
    player == "w" ? @symbol = "♛" : @symbol = "♕"
  end

  def check_move(board, from, to)
    if board[to[:row]][to[:column]].nil? || board[to[:row]][to[:column]].player != @player
      
      if to[:row] == from[:row] || to[:column] == from[:column]
        if straight_path_is_free?(board, from, to)
          return "ok"
        end

      elsif (to[:row] - from[:row]).abs == (to[:column] - from[:column]).abs
        if diagonal_path_is_free?(board, from, to)
          return "ok"
        end
      end

    end
    return "illegal"
  end


  def diagonal_path_is_free?(board, from, to)
    to[:row] > from[:row] ? r = 1 : r = -1
    to[:column] > from[:column] ? c = 1 : c = -1
    row = from[:row]
    column = from[:column]
    loop do 
      row += 1 * r
      column += 1 * c
      break if row == to[:row] && column == to[:column]
      return false if board[row][column] != nil
    end
    true
  end

  def straight_path_is_free?(board, from, to)
    r = 0
    r = 1 if to[:row] > from[:row]
    r = -1 if to[:row] < from[:row]

    c = 0
    c = 1 if to[:column] > from[:column]
    c = -1 if to[:column] < from[:column]

    row = from[:row]
    column = from[:column]
    loop do 
      row += 1 * r
      column += 1 * c
      break if row == to[:row] && column == to[:column]
      return false if board[row][column] != nil
    end
    true
  end
end


class Rook
  attr_reader :symbol, :player, :has_moved
  
  def initialize(player)
    @player = player
    player == "w" ? @symbol = "♜" : @symbol = "♖"
    @has_moved = false
  end

  def check_move(board, from, to)
    if board[to[:row]][to[:column]].nil? || board[to[:row]][to[:column]].player != @player
      if to[:row] == from[:row] || to[:column] == from[:column]
        if path_is_free?(board, from, to)
          @has_moved = true
          return "ok"
        end
      end
    end
    return "illegal"
  end

  def path_is_free?(board, from, to)
    r = 0
    r = 1 if to[:row] > from[:row]
    r = -1 if to[:row] < from[:row]

    c = 0
    c = 1 if to[:column] > from[:column]
    c = -1 if to[:column] < from[:column]

    row = from[:row]
    column = from[:column]
    loop do 
      row += 1 * r
      column += 1 * c
      break if row == to[:row] && column == to[:column]
      return false if board[row][column] != nil
    end
    true
  end

end


class Bishop
  attr_reader :symbol, :player
  
  def initialize(player)
    @player = player
    player == "w" ? @symbol = "♝" : @symbol = "♗"
  end

  def check_move(board, from, to)
    if board[to[:row]][to[:column]].nil? || board[to[:row]][to[:column]].player != @player
      if (to[:row] - from[:row]).abs == (to[:column] - from[:column]).abs
        if path_is_free?(board, from, to)
          return "ok"
        end
      end
    end
    return "illegal"
  end

  def path_is_free?(board, from, to)
    to[:row] > from[:row] ? r = 1 : r = -1
    to[:column] > from[:column] ? c = 1 : c = -1
    row = from[:row]
    column = from[:column]
    loop do 
      row += 1 * r
      column += 1 * c
      break if row == to[:row] && column == to[:column]
      return false if board[row][column] != nil
    end
    true
  end
end


class Knight
  attr_reader :symbol, :player
  
  def initialize(player)
    @player = player
    player == "w" ? @symbol = "♞" : @symbol = "♘"
  end

  def check_move(board, from, to)
    if board[to[:row]][to[:column]].nil? || board[to[:row]][to[:column]].player != @player
      if (from[:row] - to[:row]).abs == 2
        (from[:column] - to[:column]).abs == 1 ? "ok" : "illegal"
      elsif (from[:column] - to[:column]).abs == 2
        (from[:row] - to[:row]).abs == 1 ? "ok" : "illegal"
      else
        return "illegal"
      end
    else
      return "illegal"
    end
  end
end


board = Board.new
board.new_game