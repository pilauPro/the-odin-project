class TicTacToe
	attr_accessor :name, :board
	def initialize
		@board = []
		3.times{@board << [nil, nil, nil]}
	end

	def mark_x(row, column)
		@board[row - 1][column -1] = "x"
	end

	def mark_o(row, column)
		@board[row - 1][column -1] = "o"
	end

	def display_board
		@board.each{ |row|
			row.each{ |square| print square ? "|#{square}" : "| " }
			print "|\n"
		}
	end
end

game = TicTacToe.new


game.mark_x(1,1)
game.mark_x(2,2)
game.mark_x(3,3)
game.mark_o(1,2)
game.mark_o(1,3)
game.mark_o(2,1)
game.display_board
