class Player < ActiveRecord::Base
    belongs_to :password
    has_many :played_boards
    has_many :boards, through: :played_boards
end