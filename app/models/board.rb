class Board < ActiveRecord::Base
    has_many :played_boards
    has_many :players, through: :played_boards

    def self.generate_board
        layout = (0..99).to_a.shuffle.take(25)
        find_or_create_by(layout: layout.join(' '))
    end
end