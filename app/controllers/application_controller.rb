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
    user.to_json(include: {played_boards: {include: :board}})
  end

  get "/boards/:id" do
    board = Board.find(params[:id])
    board.to_json(include: {played_boards: {include: :player}})
  end

  post "/users" do
    new_user = Player.create(
      name: params[:name],
      username: params[:username],
      password: params[:password]
    )
    new_user.to_json
  end

  delete "/users/:id" do
    user = Player.find(params[:id])
    user.destroy
    user.to_json
  end

end
