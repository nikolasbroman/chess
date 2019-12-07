require "./lib/chess.rb"

RSpec.describe Board do

  describe "move" do
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
  end
end