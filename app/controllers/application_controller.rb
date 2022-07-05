require 'pry'

class ApplicationController < Sinatra::Base
  set :default_content_type, 'application/json'
  
  # Add your routes here
  get "/users" do
    users = Player.all
    users.to_json(include: {played_boards: {include: :board}})
  end

  get "/boards" do
    boards = Board.all
    boards.to_json(include: {played_boards: {include: :player}})
  end

  get "/users/:id" do
    user = Player.find(params[:id])
    user.password_id = nil
    user.to_json(include: {played_boards: {include: :board}})
  end

  get "/boards/:id" do
    board = Board.find(params[:id])
    board.to_json(include: {played_boards: {include: :player}})
  end

  post "/users" do
    return_user = Player.find_by(username: params[:username])
    new_user = params[:name]
    if new_user
      if !Player.find_by(username: params[:username])
        new_password = Password.create(password: params[:password])
        new_user = Player.create(
          name: params[:name],
          username: params[:username],
          password_id: new_password[:id]
        )
        new_user.password_id = nil
        new_user.to_json(include: {played_boards: {include: :board}})
      end
    elsif return_user && return_user.password.password == params[:password]
      return_user.password_id = nil
      return_user.to_json(include: {played_boards: {include: :board}})
    end
  end

  delete "/users/:id" do
    user = Player.find(params[:id])
    user.destroy
    user.to_json
  end

  post "/played-boards" do
    unused_nums = (0..99).to_a.join(' ')
    new_board = PlayedBoard.create(player_id: params[:player_id], board_id: params[:board_id], unused_nums: unused_nums)
    new_board.to_json(include: :board)
  end

  patch "/played-boards/:id" do
    current_board = PlayedBoard.find(params[:id])
    new_num = (current_board.unused_nums.split(' ') - params[:unused_nums].split(' ')).first
    current_board.play_round new_num
    current_board.to_json
  end

  delete "/played-boards/:id" do
    current_board = PlayedBoard.find(params[:id])
    player_id = current_board.player_id
    board_id = current_board.board_id
    unused_nums = (0..99).to_a.join(' ')
    current_board.destroy
    Board.find(board_id).reset_high_scores
    new_board = PlayedBoard.create(player_id: player_id, board_id: board_id, unused_nums: unused_nums)
    new_board.to_json
  end

end
