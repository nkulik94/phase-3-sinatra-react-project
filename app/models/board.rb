class Board < ActiveRecord::Base
    has_many :played_boards
    has_many :players, through: :played_boards

    LINE_WIN_COMBINATIONS = [
        ['0', '1', '2', '3', '4'],
        ['5', '6', '7', '8', '9'],
        ['10', '11', '12', '13', '14'],
        ['15', '16', '17', '18', '19'],
        ['20', '21', '22', '23', '24'],
        ['0', '5', '10', '15', '20'],
        ['1', '6', '11', '16', '21'],
        ['2', '7', '12', '17', '22'],
        ['3', '8', '13', '18', '23'],
        ['4', '9', '14', '19', '24'],
        ['0', '6', '12', '18', '24'],
        ['4', '8', '12', '16', '20']
    ]

    X_WIN = (LINE_WIN_COMBINATIONS[LINE_WIN_COMBINATIONS.count - 2] + LINE_WIN_COMBINATIONS.last).uniq

    def self.generate_board
        layout = (0..99).to_a.shuffle.take(25)
        find_or_create_by(layout: layout.join(' '))
    end

    def new_high_score score_type
        scores_arr = self.played_boards.order(score_type).filter { |board| board[score_type] }
        scores_arr.first[score_type]
    end

    def reset_high_scores
        line_high = new_high_score :turns_to_line
        x_high = new_high_score :turns_to_x
        full_high = new_high_score :turns_to_full
        update(line_high_score: line_high, x_high_score: x_high, full_high_score: full_high)
    end
end