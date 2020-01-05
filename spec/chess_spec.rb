require "./lib/chess.rb"

RSpec.describe Board do

  describe "#move" do
    it "returns error, if from position is outside board" do
      board = Board.new
      expect(board.move("p8", "h8")).to eql("error_outside_board")
      expect(board.move("a0", "h8")).to eql("error_outside_board")
      expect(board.move("d9", "h8")).to eql("error_outside_board")
    end

    it "returns error, if to position is outside board" do
      board = Board.new
      expect(board.move("h8", "p8")).to eql("error_outside_board")
      expect(board.move("h8", "a0")).to eql("error_outside_board")
      expect(board.move("h8", "d9")).to eql("error_outside_board")
    end

    it "returns error, if to position isn't a chess piece by current player" do
      board = Board.new
      expect(board.move("a7", "a6")).to eql("error_not_player_piece")
      expect(board.move("a5", "a4")).to eql("error_not_player_piece")
    end

    describe "white pawn" do

      it "moves up 1 step vertically" do
        board = Board.new
        pawn_a2 = board.get_piece("a2")
        board.move("a2", "a3")
        expect(board.get_piece("a3")).to eql(pawn_a2)
      end

      it "moves up 2 steps from starting row" do
        board = Board.new
        pawn_a2 = board.get_piece("a2")
        board.move("a2", "a4")
        expect(board.get_piece("a4")).to eql(pawn_a2)
      end

      it "gives error for 2 steps, if not starting row" do
        board = Board.new
        pawn_a2 = board.get_piece("a2")
        board.move("a2", "a3")
        expect(board.move("a3", "a5")).to eql("error_illegal_move")
      end

      it "gives error, if column is +-2 or more" do
        board = Board.new
        pawn_d2 = board.get_piece("d2")
        expect(board.move("d2", "f3")).to eql("error_illegal_move")
        expect(board.move("d2", "f4")).to eql("error_illegal_move")
        expect(board.move("d2", "g3")).to eql("error_illegal_move")
        expect(board.move("d2", "g4")).to eql("error_illegal_move")
        expect(board.move("d2", "b3")).to eql("error_illegal_move")
        expect(board.move("d2", "b4")).to eql("error_illegal_move")
        expect(board.move("d2", "a3")).to eql("error_illegal_move")
        expect(board.move("d2", "a4")).to eql("error_illegal_move")
      end

      it "gives error, if tries to move backwards" do
        board = Board.new
        pawn_a2 = board.get_piece("a2")
        board.move("a2", "a4")
        expect(board.move("a4", "a3")).to eql("error_illegal_move")
      end

      it "does non-special captures correctly" do
        board = Board.new
        pawn_d2 = board.get_piece("d2")
        board.move("d2", "d4")
        board.player = "b"
        board.move("e7", "e5")
        board.player = "w"
        board.move("d4", "e5")
        expect(board.get_piece("e5")).to eql(pawn_d2)
      end
        
    end

    describe "black pawn" do

      it "moves forward 1 step" do
        board = Board.new
        board.player = "b"
        pawn_d7 = board.get_piece("d7")
        board.move("d7", "d6")
        expect(board.get_piece("d6")).to eql(pawn_d7)
      end

      it "moves forward 2 steps" do
        board = Board.new
        board.player = "b"
        pawn_d7 = board.get_piece("d7")
        board.move("d7", "d5")
        expect(board.get_piece("d5")).to eql(pawn_d7)
      end

      it "gives error for illegal moves" do
        board = Board.new
        board.player = "b"
        pawn_d7 = board.get_piece("d7")
        board.move("d7", "d5")
        expect(board.move("d5", "d6")).to eql("error_illegal_move")
        expect(board.move("d5", "d3")).to eql("error_illegal_move")
        expect(board.move("d5", "a5")).to eql("error_illegal_move")
        expect(board.move("d5", "c4")).to eql("error_illegal_move")
        expect(board.move("d5", "e4")).to eql("error_illegal_move")
      end

      it "does non-special captures correctly" do
        board = Board.new
        pawn_e7 = board.get_piece("e7")
        board.move("d2", "d4")
        board.player = "b"
        board.move("e7", "e6")
        board.player = "w"
        board.move("d4", "d5")
        board.player = "b"
        board.move("e6", "d5")
        expect(board.get_piece("d5")).to eql(pawn_e7)
      end

    end

    describe "knight" do
      it "moves in L-patterns" do
        board = Board.new

        knight_b1 = board.get_piece("b1")
        board.move("b1", "c3")
        expect(board.get_piece("c3")).to eql(knight_b1)
        board.move("c3", "e4")
        expect(board.get_piece("e4")).to eql(knight_b1)
        board.move("e4", "d6")
        expect(board.get_piece("d6")).to eql(knight_b1)
        board.move("d6", "b5")
        expect(board.get_piece("b5")).to eql(knight_b1)

        board.player = "b"
        knight_b8 = board.get_piece("b8")
        board.move("b8", "c6")
        expect(board.get_piece("c6")).to eql(knight_b8)
        board.move("c6", "e5")
        expect(board.get_piece("e5")).to eql(knight_b8)
        board.move("e5", "f3")
        expect(board.get_piece("f3")).to eql(knight_b8)
        board.move("f3", "d4")
        expect(board.get_piece("d4")).to eql(knight_b8)
      end

      it "gives error, if movemenet is not L-pattern" do
        board = Board.new

        knight_b1 = board.get_piece("b1")
        expect(board.move("b1", "b3")).to eql("error_illegal_move")
        board.move("b1", "c3")
        expect(board.move("c3", "e2")).to eql("error_illegal_move")

        board.player = "b"
        knight_b8 = board.get_piece("b8")
        expect(board.move("b8", "d7")).to eql("error_illegal_move")
        board.move("b8", "c6")
        board.move("c6", "e5")
        expect(board.move("e5", "f7")).to eql("error_illegal_move")
      end
    end

    describe "bishop" do
      it "moves diagonally" do
        board = Board.new

        bishop_c1 = board.get_piece("c1")
        board.move("d2", "d3")
        board.move("c1", "e3")
        board.move("e3", "a7")
        board.move("a7", "b8")
        expect(board.get_piece("b8")).to eql(bishop_c1)

        board.player = "b"
        bishop_f8 = board.get_piece("f8")
        board.move("g7", "g6")
        board.move("f8", "h6")
        board.move("h6", "f4")
        board.move("f4", "e5")
        board.move("e5", "h2")
        expect(board.get_piece("h2")).to eql(bishop_f8)
      end

      it "gives error, when movement isn't diagonal" do
        board = Board.new

        bishop_c1 = board.get_piece("c1")
        board.move("d2", "d3")
        board.move("c1", "e3")
        expect(board.move("e3", "e5")).to eql("error_illegal_move")
        expect(board.move("e3", "a3")).to eql("error_illegal_move")
      end

      it "gives error, if a piece is blocking the way" do
        board = Board.new

        bishop_c1 = board.get_piece("c1")
        expect(board.move("c1", "b2")).to eql("error_illegal_move")
        board.move("d2", "d3")
        board.move("f2", "f4")
        expect(board.move("c1", "h6")).to eql("error_illegal_move")

        board.player = "b"
        bishop_f8 = board.get_piece("f8")
        expect(board.move("f8", "h6")).to eql("error_illegal_move")
        board.move("e7", "e6")
        board.move("f8", "a3")
        expect(board.move("a3", "c1")).to eql("error_illegal_move")
      end
    end

    describe "rook" do
      it "moves horizontally and vertically" do
        board = Board.new

        rook_a1 = board.get_piece("a1")
        board.move("a2", "a4")
        board.move("a1", "a3")
        board.move("a3", "h3")
        board.move("h3", "h7")
        board.move("h7", "h5")
        board.move("h5", "b5")
        expect(board.get_piece("b5")).to eql(rook_a1)
        
        board.player = "b"
        rook_h8 = board.get_piece("h8")
        board.move("h8", "h2")
        board.move("h2", "h1")
        board.move("h1", "g1")
        board.move("g1", "g2")
        board.move("g2", "h2")
        board.move("h2", "h4")
        expect(board.get_piece("h4")).to eql(rook_h8)
      end

      it "gives error, when movement isn't horizontal or vertical" do
        board = Board.new

        rook_a1 = board.get_piece("a1")
        board.move("a2", "a4")
        board.move("a1", "a3")
        expect(board.move("a3", "b4")).to eql("error_illegal_move")
        expect(board.move("a3", "c4")).to eql("error_illegal_move")
      end

      it "gives error, if a piece is blocking the way" do
        board = Board.new

        rook_a1 = board.get_piece("a1")
        expect(board.move("a1", "a3")).to eql("error_illegal_move")
        board.move("a2", "a4")
        board.move("a1", "a3")
        board.move("a3", "c3")
        expect(board.move("c3", "c8")).to eql("error_illegal_move")
        expect(board.move("c3", "c2")).to eql("error_illegal_move")
        board.move("c3", "c4")
        expect(board.move("c4", "a4")).to eql("error_illegal_move")
      end
    end

    describe "queen" do
      it "moves horizontally, vertically and diagonally" do
        board = Board.new

        queen_d1 = board.get_piece("d1")
        board.move("e2", "e4")
        board.move("d1", "f3")
        board.move("f3", "f7")
        board.move("f7", "e7")
        board.move("e7", "f7")
        board.move("f7", "d5")
        board.move("d5", "d4")
        board.move("d4", "a7")
        expect(board.get_piece("a7")).to eql(queen_d1)

        board.player = "b"
        queen_d8 = board.get_piece("d8")
        board.move("d8", "e7")
        board.move("e7", "e4")
        board.move("e4", "a4")
        board.move("a4", "b5")
        board.move("b5", "b6")
        expect(board.get_piece("b6")).to eql(queen_d8)

      end

      it "gives error, when movement isn't horizontal, vertical or diagonal" do
        board = Board.new

        quen_d1 = board.get_piece("d1")
        board.move("e2", "e4")
        board.move("d1", "e2")
        board.move("e2", "c4")

        expect(board.move("c4", "b6")).to eql("error_illegal_move")
        expect(board.move("c4", "a5")).to eql("error_illegal_move")
        expect(board.move("c4", "a3")).to eql("error_illegal_move")
        expect(board.move("c4", "h5")).to eql("error_illegal_move")
        expect(board.move("c4", "g6")).to eql("error_illegal_move")
      end

      it "gives error, if a piece is blocking the way" do
        board = Board.new

        board.player = "b"
        queen_d8 = board.get_piece("d8")
        expect(board.move("d8", "d7")).to eql("error_illegal_move")
        expect(board.move("d8", "d5")).to eql("error_illegal_move")
        expect(board.move("d8", "c8")).to eql("error_illegal_move")
        expect(board.move("d8", "e8")).to eql("error_illegal_move")
        board.move("e7", "e5")
        board.move("d8", "g5")
        expect(board.move("g5", "g7")).to eql("error_illegal_move")
        expect(board.move("g5", "g1")).to eql("error_illegal_move")
        expect(board.move("g5", "a5")).to eql("error_illegal_move")
        expect(board.move("g5", "c3")).to eql("error_illegal_move")
      end
    end

    describe "king" do
      it "moves one square horizontally, vertically and diagonally" do
        board = Board.new

        king_e1 = board.get_piece("e1")
        board.move("d2", "d4")
        board.move("e1", "d2")
        board.move("d2", "e3")
        board.move("e3", "d3")
        board.move("d3", "c3")
        board.move("c3", "c4")
        expect(board.get_piece("c4")).to eql(king_e1)

        board.player = "b"
        king_e8 = board.get_piece("e8")
        board.move("f7", "f6")
        board.move("e8", "f7")
        board.move("f7", "g6")
        board.move("g6", "h6")
        board.move("h6", "g5")
        board.move("g5", "g4")
        expect(board.get_piece("g4")).to eql(king_e8)
      end

      it "gives error, when trying to move more than one square" do
        board = Board.new

        board.move("d2", "d4")
        board.move("e1", "d2")
        expect(board.move("d2", "b4")).to eql("error_illegal_move")
        expect(board.move("d2", "g5")).to eql("error_illegal_move")
        board.move("d2", "c3")
        expect(board.move("c3", "a3")).to eql("error_illegal_move")
        expect(board.move("c3", "h3")).to eql("error_illegal_move")
        expect(board.move("c3", "c5")).to eql("error_illegal_move")

        board.player = "b"
        board.move("d7", "d5")
        board.move("e8", "d7")
        expect(board.move("d7", "a4")).to eql("error_illegal_move")
        expect(board.move("d7", "g4")).to eql("error_illegal_move")
        board.move("d7", "e6")
        expect(board.move("e6", "e4")).to eql("error_illegal_move")
      end

      it "gives error, if a piece is blocking the way" do
        board = Board.new

        expect(board.move("e1", "d1")).to eql("error_illegal_move")
        expect(board.move("e1", "d2")).to eql("error_illegal_move")
        expect(board.move("e1", "e2")).to eql("error_illegal_move")
        expect(board.move("e1", "f2")).to eql("error_illegal_move")
        expect(board.move("e1", "f1")).to eql("error_illegal_move")

        board.player = "b"
        expect(board.move("e8", "d7")).to eql("error_illegal_move")
        expect(board.move("e8", "e7")).to eql("error_illegal_move")
        expect(board.move("e8", "f7")).to eql("error_illegal_move")
      end

      describe "castling" do
        it "works corrently, if King and Rook haven't moved yet" do
          board = Board.new
          king_e1 = board.get_piece("e1")
          rook_h1 = board.get_piece("h1")
          board.move("e2", "e3")
          board.move("f1", "e2")
          board.move("g1", "h3")
          board.move("e1", "g1")
          expect(board.get_piece("g1")).to eql(king_e1)
          expect(board.get_piece("f1")).to eql(rook_h1)
          
          board = Board.new
          king_e1 = board.get_piece("e1")
          rook_a1 = board.get_piece("a1")
          board.move("d2", "d3")
          board.move("c1", "e3")
          board.move("d1", "d2")
          board.move("b1", "a3")
          board.move("e1", "c1")
          expect(board.get_piece("c1")).to eql(king_e1)
          expect(board.get_piece("d1")).to eql(rook_a1)

          board = Board.new
          board.player = "b"
          king_e8 = board.get_piece("e8")
          rook_h8 = board.get_piece("h8")
          board.move("e7", "e6")
          board.move("f8", "e7")
          board.move("g8", "h6")
          board.move("e8", "g8")
          expect(board.get_piece("g8")).to eql(king_e8)
          expect(board.get_piece("f8")).to eql(rook_h8)
          
          board = Board.new
          board.player = "b"
          king_e8 = board.get_piece("e8")
          rook_a8 = board.get_piece("a8")
          board.move("d7", "d6")
          board.move("c8", "e6")
          board.move("d8", "d7")
          board.move("b8", "a6")
          board.move("e8", "c8")
          expect(board.get_piece("c8")).to eql(king_e8)
          expect(board.get_piece("d8")).to eql(rook_a8)
        end

        it "gives error, if a piece is blocking the way" do
          board = Board.new

          expect(board.move("e1", "g1")).to eql("error_illegal_move")
          expect(board.move("e1", "c1")).to eql("error_illegal_move")

          board.player = "b"
          expect(board.move("e8", "g8")).to eql("error_illegal_move")
          expect(board.move("e8", "c8")).to eql("error_illegal_move")
        end

        it "gives error, if King or Rook has moved already" do
          board = Board.new
          king_e1 = board.get_piece("e1")
          rook_h1 = board.get_piece("h1")
          board.move("e2", "e3")
          board.move("f1", "e2")
          board.move("g1", "h3")
          board.move("e1", "f1")
          board.move("f1", "e1")
          expect(board.move("e1", "g1")).to eql("error_illegal_move")

          board = Board.new
          king_e1 = board.get_piece("e1")
          rook_h1 = board.get_piece("h1")
          board.move("e2", "e3")
          board.move("f1", "e2")
          board.move("g1", "h3")
          board.move("h1", "g1")
          board.move("g1", "h1")
          expect(board.move("e1", "g1")).to eql("error_illegal_move")
        end
      end
    end
  end
end