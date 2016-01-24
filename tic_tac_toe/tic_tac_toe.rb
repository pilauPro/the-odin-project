class TicTacToe
    module GameHelper
	    def initial_greeting
	        puts "WELCOME TO TIC-TAC-TOE"
	    end

	    def prompt_move(side)
	        puts "Your move, #{side}. Pick a square (1-3,1-3):"
	    end

	    def prompt_game
	    	puts "Play again (y/n)?"
	    end

	    def invalid_selection
	        "Invaid selection. Pick Again (1-3, 1-3):"
	    end
	end
	
    include GameHelper
    
	attr_accessor :game, :stats
	
	def initialize
		@game = GameNavigator.new
		@stats = GameStats.new
	end

	class GameStats
		# attr_accessor :winner, :games_played, :x_games_won, :o_games_won, :ties
	    
	    @@games_played = 0
	    @@x_games_won = 0
	    @@o_games_won = 0
	    @@ties = 0
	    
	    def initialize
	  
	    end
	    
	    def set_winner(side)
	        @winner = side.to_sym
	    end
	    
	    def increment_games_played
	    	@@games_played += 1
	    end
	    
	    def increment_ties
	        @@ties += 1
	    end
    
        def increment_winner
            @winner == :X ? @@x_games_won += 1 : @@o_games_won += 1
        end
        
	    def games_played
	        @@games_played
	    end
	    
	    def x_games_won
	        @@x_games_won
	    end
        
        def o_games_won
	        @@o_games_won
	    end
	    
	    def games_tied
	        @@ties
	    end
	end
	
	class GameNavigator
	    attr_accessor :board, :moves
	    def initialize
	        @board = []
	        @move = []
	        @moves = 0
	        3.times{@board << [nil, nil, nil]}
	    end
	    
	    def display_board
    		@board.each{ |row|
    			row.each{ |square| print square ? "|#{square}" : "| " }
    			print "|\n"
    		}
	    end

	    def display_result
	    	puts "#{determine_winning_move} wins the game." if game_winner?
	    	puts "Tie game" if full_board?
	    end

	    def split_choice(choice)
	        @move = choice.scan(/\d/).map{|num| num.to_i}
	    end
	    
	    def invalid_move
	        invalid = false
	        @move.each{ |num| invalid = true if num < 1 || num > 3 }
	        invalid
	    end

	    def square_occupied?
	    	@board[@move[0] - 1][@move[1] - 1] != nil
	    end
	    
	    def determine_move
	        @moves.even? || @moves == 0 ? "X" : "O"
	    end

	    def determine_winning_move
	    	@moves.odd? ? "X" : "O"
	    end
	    
	    def mark_move(mark)
		    @board[@move[0] - 1][@move[1] - 1] = mark
    	end

    	def increment_moves
    		@moves += 1
    	end

    	def game_over?
    		full_board? || game_winner?
    	end

    	def game_winner?
    		row_winner? || column_winner? || diagonal_winner?
    	end
        
        def tie_game?
            full_board? && !game_winner?
        end
        
    	def row_winner?
    		@board.find_index{ |row| row.join == "XXX" || row.join == "OOO"}
    	end

    	def column_winner?
    		make_vert_arrays.find_index{ |row| row.join == "XXX" || row.join == "OOO"}
    	end

    	def diagonal_winner?
    		make_diag_arrays.any?{|diag| diag.join == "XXX" || diag.join == "OOO"}
    	end

    	def full_board?
    		@board.all?{|row|
			    row.all?{|square| square}
			}	
    	end

    	def make_diag_arrays
    		diag1 = [@board[0][0], @board[1][1], @board[2][2]]
    		diag2 = [@board[0][2], @board[1][1], @board[2][0]]
    		return [diag1, diag2]
    	end

    	def make_vert_arrays
    		i = 0
    		vert_ar = []
    		3.times{ 
			    vert_ar << [@board[0][i], @board[1][i], @board[2][i]]
			    i += 1
			}
			vert_ar
    	end
	end
	
end



continue = true

while continue

	# Create TicTacToe instance
	current = TicTacToe.new

	# Print initial greeting, once
	current.initial_greeting if current.stats.games_played == 0

	# Set loop control variable
	ingame = true

	# Continue game loop until win or tie is reached
	while ingame
	    current.prompt_move(current.game.determine_move)
	    begin
	        current.game.split_choice(gets.chomp)
	        raise current.invalid_selection if current.game.invalid_move || current.game.square_occupied?
	    rescue => e
	        puts e
	        retry
	    end

	    current.game.mark_move(current.game.determine_move)
	    current.game.display_board
	    current.game.increment_moves
	    
	    ingame = false if current.game.game_over?
	end

	# Show results of finished game
	current.game.display_result

	# update Class counters
	current.stats.increment_games_played
	if current.game.game_winner?
	    current.stats.set_winner(current.game.determine_winning_move)
	    current.stats.increment_winner
	else
	    current.stats.increment_ties
	end
	
	puts "games played: #{current.stats.games_played}"
    puts "X games won: #{current.stats.x_games_won}"
    puts "O games won: #{current.stats.o_games_won}"
    puts "ties: #{current.stats.games_tied}"

    
	# Prompt user to play another game or exit program
	current.prompt_game
	continue = false if gets.chomp.downcase == "n"

end
