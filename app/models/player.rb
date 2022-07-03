class Player < ActiveRecord::Base
    has_many :played_boards
    has_many :boards, through: :played_boards
end