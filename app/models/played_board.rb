class PlayedBoard < ActiveRecord::Base
    belongs_to :board
    belongs_to :player

    def unused_nums_arr
        unused_nums.split(' ')
    end

    def layout_arr
        board.layout.split(' ')
    end

    def filled_spaces_arr
        filled_spaces.split(' ')
    end

    def update_unused_nums num
        unused_nums_arr.delete num
        update(unused_nums: nums_arr.join(' '))
    end

    def update_filled_spaces index
        filled_spaces_arr.push(index)
    end

    def has_line?
        Board::LINE_WIN_COMBINATIONS.find { |combo| (combo - filled_spaces).empty? }
    end

    def pick_num nums_arr
        new_num = nums_arr.sample
        update_unused_nums(new_num)
        check_for_match(new_num)
    end

    def check_for_match num
        matched_num_index = layout_arr.find_index num
        handle_match(matched_num_index) if matched_num_index
    end

    def handle_match index

    end
end