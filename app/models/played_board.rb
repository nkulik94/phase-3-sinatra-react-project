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
        filled_spaces ? filled_spaces.split(' ') : []
    end

    def count_turn
        count = turn_count ? turn_count : 0
        update(turn_count: count + 1)
    end

    def update_unused_nums num
        unused_nums_arr.delete num
        update(unused_nums: unused_nums_arr.join(' '))
    end

    def update_filled_spaces index
        filled_spaces_arr.push(index)
        update(filled_spaces: filled_spaces_arr.join(' '))
    end

    def has_line?
        Board::LINE_WIN_COMBINATIONS.find { |combo| (combo - filled_spaces_arr).empty? }
    end

    def has_x?
        (Board::X_WIN - filled_spaces_arr).empty?
    end

    def pick_num
        new_num = unused_nums_arr.sample
        update_unused_nums(new_num)
        check_for_match(new_num)
    end

    def check_for_match num
        layout_arr.find_index num
    end

    def handle_match index

    end
end