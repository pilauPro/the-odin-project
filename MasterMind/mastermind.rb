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
    end
    
    # This class contains the attributes and functions for the game
    class Game
        attr_accessor :code, :word_code, :guess, :num_guess, :remaining_guesses
        
        include GameHelper
        
        # creates a new code to solve and converts the code to colors, stored in a different attribute
        def initialize
            @code = generate_code
            @word_code = convert_code
            @guess = []
            @num_guess = []
            @remaining_guesses = 12
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

        def decrement_guesses
            @remaining_guesses -= 1
        end
        
        def convert_guess
            @num_guess = @guess.map{ |letter| translate_color_to_num(letter) }
        end
        
        def code_guessed?
            @num_guess == @code
        end
        
        def turn_result
            result = []
            4.times {|x|
                result << [(exact_matches[x] + color_matches[x]), 2].min
            }
            result
        end
        
        def exact_matches
            exactarr = [0,0,0,0]
            4.times{ |x| exactarr[x] = 2 if @num_guess[x] == @code[x] }
            exactarr
        end
        
        def color_matches
            colorarr = [0,0,0,0]
            
            # use dup to make a shallow copy of the @code variable, otherwise changes to clone will change @code itself
            clone = @code.dup
            4.times{|x|
                if clone.include?(@num_guess[x])
                    colorarr[x] = 1
                    puts "code before delete: #{@code}"
                    clone.delete_at(clone.find_index(@num_guess[x]))
                    puts "code after delete: #{@code}"
                end
            }
            colorarr
        end
    end
end

# Create MasterMind Instance
current = MasterMind.new

# loop until code is guessed or remaining guesses run out
until current.game.code_guessed? || current.game.remaining_guesses == 0

    puts "The code is: #{current.game.code}"
    puts "Enter your code guess:"

    # Loop until valid user entry is captured
    begin

        # capture user code guess
        current.game.capture_guess(gets.chomp.downcase)
        
        # raise exception if invalid user entry
        raise current.game.invalid_selection unless current.game.verify_guess
        
    rescue => e
        puts e
        retry
    end
    
    # convert user guess to numerical
    current.game.convert_guess
    
    # decrement remaining guesses
    current.game.decrement_guesses


    if current.game.code_guessed?
        puts "You broke the code, MasterMind!"
    else
        puts "Incorrect guess.  Your result:"
        puts "#{current.game.turn_result}"
    end
end
