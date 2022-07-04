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

    def remove_from_unused num
        unused_nums_arr.delete num
        update(unused_nums: unused_nums_arr.join(' '))
    end

    def update_filled_spaces index
        filled_spaces_arr.push(index)
        update(filled_spaces: filled_spaces_arr.join(' '))
    end

    def has_line?
        turns_to_line || Board::LINE_WIN_COMBINATIONS.find { |combo| (combo - filled_spaces_arr).empty? }
    end

    def has_x?
        turns_to_x || (Board::X_WIN - filled_spaces_arr).empty?
    end

    def is_full?
        filled_spaces_arr.count == 25
    end

    def get_match num
        layout_arr.find_index num
    end

    def handle_match index
        update_filled_spaces(index)
        if is_full?
            update(turns_to_full: turn_count)
        elsif !turns_to_x && has_x?
            update(turns_to_x: turn_count)
        elsif !turns_to_line && has_line?
            update(turns_to_line: turn_count)
        end
    end

    def play_round num
        remove_from_unused(num)
        count_turn
        match = get_match(num)
        handle_match(match) if match
    end

    def sim_play
        play_round(unused_nums_arr.sample)
        sim_play unless is_full?
    end
end