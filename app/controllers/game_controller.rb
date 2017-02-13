require 'game'

class GameController < ApplicationController
  def game
    @grid = generate_grid(10)
    @time_start = Time.now
  end

  def score
    attempt = params[:attempt]
    start_time = params[:time_start].to_datetime
    grid = eval(params[:grid])
    end_time = Time.now
    @result = run_game(attempt, grid, start_time, end_time)
    p @result
  end
end
