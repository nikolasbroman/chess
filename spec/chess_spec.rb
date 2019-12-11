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
        
    end
  end
end