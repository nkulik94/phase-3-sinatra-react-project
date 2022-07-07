class PlayedBoard < ActiveRecord::Base
    belongs_to :board
    belongs_to :player

    def remove_from_unused num
        unused_nums_arr = self.unused_nums.split(' ')
        unused_nums_arr.delete num
        update(unused_nums: unused_nums_arr.join(' '))
    end
    
    def count_turn
        count = self.turn_count ? self.turn_count : 0
        update(turn_count: count + 1)
    end
    
    def get_match num
        layout_arr = self.board.layout.split(' ')
        layout_arr.find_index num
    end

    def update_filled_spaces index
        filled_spaces_arr = self.filled_spaces ? self.filled_spaces.split(' ') : []
        filled_spaces_arr.push(index)
        update(filled_spaces: filled_spaces_arr.join(' '))
    end
    
    def is_full?
        filled_spaces_arr = self.filled_spaces ? self.filled_spaces.split(' ') : []
        filled_spaces_arr.count == 25
    end
    
    def has_new_x?
        filled_spaces_arr = self.filled_spaces ? self.filled_spaces.split(' ') : []
        !self.turns_to_x && (Board::X_WIN - filled_spaces_arr).empty?
    end
    
    def has_new_line?
        filled_spaces_arr = self.filled_spaces ? self.filled_spaces.split(' ') : []
        !self.turns_to_line && Board::LINE_WIN_COMBINATIONS.find { |combo| (combo - filled_spaces_arr).empty? }
    end
    
    def update_high_score high_score
        if !self.board[high_score] || turn_count < self.board[high_score]
            self.board[high_score] = turn_count
            self.board.save
        end
    end
    
    def update_scores(turns_to_score, high_score)
        self[turns_to_score] = turn_count
        self.save
        update_high_score(high_score)
    end
    
    def handle_match index
        update_filled_spaces(index)
        update_scores(:turns_to_full, :full_high_score) if is_full?
        update_scores(:turns_to_x, :x_high_score) if has_new_x?
        update_scores(:turns_to_line, :line_high_score) if has_new_line?
    end
    
    def play_turn num
         remove_from_unused(num)
         count_turn
         match = get_match(num)
         handle_match(match) if match
     end
    
    def sim_play
        play_turn(unused_nums.split(' ').sample) until is_full?
    end
end