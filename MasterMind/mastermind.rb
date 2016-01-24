# This class contains the modules / subclasses required to run the MasterMind game
class MasterMind
    attr_accessor :game, :moves_remaining, :guess
    
    # This module contains functions to facilitate the execution of the MasterMind game
    module GameHelper
        # Creates a randomly generated code of four numbers, 1-4
        def generate_code
            code = []
            4.times{ code << rand(1..4) }
            code
        end
        
        # Translates the number code to corresponding colors
        def translate_num_to_color(num)
            case num
                when 1
                    "black"
                when 2
                    "white"
                when 3
                    "red"
                when 4
                    "green"
            end
        end
        
        # Translates colors to the corresponding number codes 1-4
        def translate_color_to_num(color)
            case color
                when "b"
                    1
                when "w"
                    2
                when "r"
                    3
                when "g"
                    4
            end
        end
        
        def invalid_selection
            "invalid selection. Try again:"
        end
    end
    
    def initialize
        @game = Game.new
        @moves_remaining = 12
    end
    
    # This class contains the randomly generated code to solve, other attributes and functions for the game
    class Game
        attr_accessor :code, :word_code, :guess
        
        include GameHelper
        
        # creates a new code to solve and converts the code to colors, stored in a different attribute
        def initialize
            @code = generate_code
            @word_code = convert_code
            @guess = []
            @word_guess = []
        end
        
        # calls on translate_num_to_color to convert numbers to colors
        def convert_code
            @code.map{ |num| translate_num_to_color(num) }
        end
        
        # takes user input and breaks it into a code guess array
        def capture_guess(user_input)
            @guess = user_input.scan(/./)
        end
        def verify_guess
            verify_letters && verify_size
        end
        def verify_letters
            @guess.all?{ |letter| letter =~ /[bwrg]/ }
        end
        def verify_size
            @guess.size == 4
        end
    end
end

# Create MasterMind Instance
current = MasterMind.new

puts "Enter your code guess:"

begin

    current.game.capture_guess(gets.chomp.downcase)
    
    raise current.game.invalid_selection unless current.game.verify_guess
    
    
rescue => e
    puts e
    
end

current.game.guess.each{|el| puts el }