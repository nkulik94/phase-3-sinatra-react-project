class PlayedBoard < ActiveRecord::Base
    belongs_to :board
    belongs_to :player

    def unused_nums_arr
        self.unused_nums.split(' ')
    end

    def update_unused_nums num
        nums_arr.delete num
        update(unused_nums: nums_arr.join(' '))
    end

    def pick_num nums_arr
        new_num = nums_arr.sample
        update_unused_nums(new_num)
        new_num
    end

    def check_for_match num
        layout = board.layout.split(' ')
        matched_num = layout.find { |board_num| board_num == num}
    end
end