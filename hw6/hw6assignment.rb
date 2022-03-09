# University of Washington, Programming Languages, Homework 6, hw6runner.rb

# This is the only file you turn in, so do not modify the other files as
# part of your solution.

class MyPiece < Piece
    # The constant All_My_Pieces should be declared here
    # class array holding all the pieces and their rotations
    # array，其中包含了所有的pieces和他们的旋转方式
    All_My_Pieces = Piece::All_Pieces.concat(
    [
      rotations([[0, 0], [1, 0], [0, 1], [1, 1], [-1, 0]]),
     [[[-1, 0], [-2, 0], [0, 0], [1, 0], [2, 0]],
       [[0, -1], [0, -2], [0, 0], [0, 1], [0, 2]]],
       rotations([[0, 0], [0, 1], [1, 0]])
    ])
    Cheat_Piece = [[[0, 0]]]
  
    # your enhancements here
    def self.next_piece (board) # 这个貌似是静态方法
      # puts "大家好，天气真晴朗啊！"
      Piece.new(All_My_Pieces.sample, board) # 随机挑选一个图形来做
    end
  
    def self.cheat_piece(board)
      MyPiece.new(Cheat_piece, board)
      # 开启欺骗模式
    end
  end
  
  class MyBoard < Board
    # your enhancements here
    def initialize (game) # 初始化游戏，是吧！
     super # 所谓的super，就是将父类的代码放在前面，这个东西和C++里面有所不同啊！
     @current_block = MyPiece.next_piece(self) # piece 就是所谓的块结构
      @cheat_cost = 100
      @cheat_queued = false
    end
  
    # gets the next piece
    def next_piece # 我现在才发现，原来board也有next_piece方法，非常棒的东西啊！
      @current_block = MyPiece.next_piece(self) # 下一个块，是吧！
      @current_pos = nil
      if @cheat_queued
        @current_block = MyPiece.cheat_piece(self)
        @cheat_queued = false
      end
    end
  
    def store_current
      locations = @current_block.current_rotation
      displacement = @current_block.position
      (0..(locations.size-1)).each{
          |index| 
          current = locations[index];
          @grid[current[1]+displacement[1]][current[0]+displacement[0]] = 
          @current_pos[index]
      }
      remove_filled
      @delay = [@delay - 2, 80].max
    end
  
    def rotate_180_degree
      if !game_over? and @game.is_running?
        @current_block.move(0, 0, 2) # 旋转180°
      end
      draw # draw 这玩意，你理解为重绘吧！
    end
  
    def new_game
      super
      @cheat_queued = false
    end
  
    def cheat
      return if @cheat_queued || @score < @cheat_cost
      @cheat_queued = true
      @score -= @cheat_cost
    end
  end
  
  class MyTetris < Tetris
  
    def set_board
      @canvas = TetrisCanvas.new
      @board = MyBoard.new(self)
      @canvas.place(@board.block_size * @board.num_rows + 3,
            @board.block_size * @board.num_columns + 6, 24, 80)
      @board.draw
    end
  
    def key_bindings  # 这里终于看到键盘的绑定了！
     super
     @root.bind('u', proc{@board.rotate_180_degree})
      @root.bind('c', proc{@board.cheat})
    end
  end