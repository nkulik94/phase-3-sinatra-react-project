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
        new_user.to_json(include: {played_boards: {include: :board}})
      end
    elsif return_user && return_user.password.password == params[:password]
      return_user.to_json(include: {played_boards: {include: :board}})
    end
  end

  delete "/users/:id" do
    user = Player.find(params[:id])
    user.destroy
    user.to_json
  end

end
