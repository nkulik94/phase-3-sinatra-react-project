class Board < ActiveRecord::Base
    has_many :played_boards
    has_many :players, through: :played_boards
end