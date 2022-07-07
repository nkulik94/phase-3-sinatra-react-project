# Bingo Backend

## What it is

This is the backend for a bingo-playing app, and it is the main part of a project for Flatiron School. The original repo that this is forked from is a template provided by Flatiron with most of the configuration set up so that I wouldn't have to do it myself, to my immense relief. It uses the [Active Record](https://guides.rubyonrails.org/active_record_basics.html) ORM with a [SQLite](https://www.sqlite.org/index.html) database to handle all the information that it needs to store and interact with. The routes are set up using [Sinatra](http://sinatrarb.com/). The frontend repo is located [here](https://github.com/nkulik94/sinatra-react-bingo-frontend).

## How to run it

To run the server, clone the repo and run `bundle install`, then `rake db:migrate` and `rake server`. The database can be populated with dummy data by running `rake db:seed`, but because the seed file simulates 100 full games of bingo, be aware that it'll take some time. The routes can be tested with [Postman](https://www.postman.com/) or by cloning and running the frontend app.

## Database Tables

This app uses a relational database with many-to-many and one-to-many relationships. There are four tables.

#### `users` table:

| id (int)      | name (str)     | username (str) | password_id (int) |
| ----------------- | ----------------- | ----------------- | ----------------- |
| `<some number>`   | `<some name>`     | `<some string>`   | `<key for password table>`   |

#### `passwords` table:

| id (int) | password (str) |
| -------- | -------------- |
| `<some number>` | `<some string>` |

> Originally the passwords were part of the user table, I split it off into its own table so that only the backend has access to them. The backend takes care of validating logins, so I figured it would be more secure this way. I have no idea what the convention is with this type of thing, so I just did it my way.

#### `boards` table:

| id (integer)    | layout (string) | line_high_score (int) | x_high_score | full_high_score (int) |
| --------------- | --------------- | --------------------- | ------------ | --------------------- |
| `<some number>` | `<layout>`      | `nil` (default)       | `nil` (default) | `nil` (default) |


This table contains the high scores (fewest turns) for that particular board. The layout is an array of 25 random integers between 0 and 99, joined into a string (separated by spaces) so that it can be stored in the table. The frontend is responsible for separating it back into an array and populating the visual representation of the bingo board with the numbers, as well as joining it back to a string before sending it back.

#### `played_boards` table (join table), split in two because it's got a bunch of columns:

##### Part one:

| id (int)            | player_id (int)     | board_id (int)      | unused_nums (str) |
| ------------------  | ------------------- | ------------------- | --------------------- |
| `<some number>`         | `<some number>`         | `<some number>`         | `"0..99"` (default)     |

##### Part two:

| turn_count (int)   | turns_to_line (int) | turns_to_x (int)    | turns_to_full (int)  | filled_spaces (str)     |
| -------------------- | -------------------- | -------------------- | -------------------- | -------------------- |
| `nil` (default)      | `nil` (default)      | `nil` (default)      | `nil` (default)      | `nil` (default) |


Lot to unpack here. This is a join table to allow a many-to-many relationship between boards and users. Each row represents a specific instance of a specific game board played by a specific user. It contains all of the information relevant to that game. It starts with the `player_id` and `board_id` (of course). The `unused_nums` column holds a string of integers from 0 to 99, used to track the numbers that haven't been picked yet. `Turn_count` tracks the number of turns taken, allowing the scores to be calculated. `Turns_to_line/x/full` tracks how many turns it took to get to each specific milestone. `Filled_spaces` is a string containing the position on the board (by index) of numbers that match numbers that have been picked. For example `"3 24 17 7"` would mean that the numbers at positions 3, 24, 17, and 7 of the board have been picked already. This allows the frontend to color the spaces on the board that have been filled so that the user can track their progress.

## Routes

#### All responses in json format

`GET "/boards"` - Sends all of the boards table rows as instances of the `Board` class, including all instances of `PlayedBoard` associated with each board, and each `Player` associated with each `PlayedBoard`.  

`POST "/users"` - This is an interesting one. As I mentioned, the login validation is handled by the backend. `POST` was the obvious choice for creating a new account, but an existing user logging in wasn't as clear. I ultimately settled on using `POST` because the login information was being sent by the frontend to be handled by the backend. The information sent by the frontend is validated, processed, and depending on the `params` of the request the server either creates and sends back new account information or sends the information for the existing user in the response.  

`POST "/played-boards"` - Instantiates a new `PlayedBoard` and sends it back  

`PATCH "/played-boards/:id"` - Receives an updated `unused_nums` string in the `params` hash (after a number is picked by the frontend). Finds the picked number by subtracting it from the old `unused_nums` and passes it to a `PlayedBoard` instance method that updates the `PlayedBoard` instance found using the `id` and sends the updated information in the response to be handled by the frontend.  

`DELETE "played-boards/:id"` - Finds the row with the matching `id` and deletes it from the table, then sends it back in the response.

## A few more points:

Because the point of this project was to practice using Ruby and to hone my backend development skills, I built it so that as much as possible was handled by the backend (hence a somewhat unconventional `PATCH` route). A good deal more of handling the gameplay could have been done by the frontend, but I specifically wanted to write the code for that in Ruby. Additionally, I wanted to have an instance method for the seed file to use to simulate a full game, and having all that code already available made that much easier.  

The dummy user data in the seed file was generated using the [Faker](https://github.com/faker-ruby/faker) gem, using randomly generated beer brands as usernames as a tribute to a certain developer's favorite type of adult beverage.

Thanks for checking it out!  
Naftali Kulik