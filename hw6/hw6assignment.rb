# UC Riverside, Programming Languages, Homework 6, hw6runner.rb
# Based on code from University of Washington

# This is the only file you turn in, so do not modify the other files as
# part of your solution.

class MyPiece < Piece
  # The constant All_My_Pieces should be declared here
    def self.next_piece(board)
        MyPiece.new(All_My_Pieces.sample, board)
    end

    def self.cheat_piece(board)
        MyPiece.new(Cheat_Piece, board)
    end

    All_My_Pieces = Piece::All_Pieces.concat([rotations([[0, 0], [1, 0], [0, 1], [1, 1], [-1, 0]]),
                                                        [[[-1, 0], [-2, 0], [0, 0], [1, 0], [2, 0]],
                                                        [[0, -1], [0, -2], [0, 0], [0, 1], [0, 2]]],
                                              rotations([[0, 0], [0, 1], [1, 0]])])

    Cheat_Piece = [[[0, 0]]]
end

class MyBoard < Board
  # your enhancements here
    def initialize(game)
        super
        @current_block = MyPiece.next_piece(self)
        @cheat = false
    end

    def rotate
        if !game_over? and @game.is_running?
            @current_block.move(0, 0, 2)
        end
        draw
    end

    def cheat_mode
        if !@cheat and @score >= 100
            @score -= 100
            @cheat = true
        end
    end

    def next_piece
        if @cheat
            @current_block = MyPiece.cheat_piece(self)
        else
            @current_block = MyPiece.next_piece(self)
        end
    end

    def store_current
        locations = @current_block.current_rotation
        displacement = @current_block.position
        (0..locations.size-1).each{|index| 
          current = locations[index];
          @grid[current[1]+displacement[1]][current[0]+displacement[0]] = 
          @current_pos[index]
        }
        remove_filled
        @delay = [@delay - 2, 80].max
    end
end

class MyTetris < Tetris
  # your enhancements here
    def set_board
        @canvas = TetrisCanvas.new
        @board = MyBoard.new(self)
        @canvas.place(@board.block_size * @board.num_rows + 3, @board.block_size * @board.num_columns + 6, 24, 80)
        @board.draw
    end

    def key_bindings
        super
        @root.bind('u', proc{@board.rotate})
        @root.bind('c', proc{@board.cheat_mode})
    end
end


