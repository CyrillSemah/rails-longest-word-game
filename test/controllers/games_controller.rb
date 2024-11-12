# app/controllers/games_controller.rb

class GamesController < ApplicationController
  def new
    # En mode test, on utilise une grille fixe pour assurer la répétabilité des tests
    @letters = if Rails.env.test?
                 ["C", "A", "T", "X", "L", "K", "P", "N", "B", "R"]
               else
                 Array.new(10) { ('A'..'Z').to_a.sample }
               end
  end

  def score
    @word = params[:word].upcase
    @letters = params[:letters].split
    @time_taken = Time.now - params[:start_time].to_time

    if word_in_grid?(@word, @letters)
      if english_word?(@word)
        @score = compute_score(@word, @time_taken)
        @message = "Bien joué !"
      else
        @score = 0
        @message = "Ce n'est pas un mot anglais valide."
      end
    else
      @score = 0
      @message = "Le mot ne peut pas être construit à partir de la grille."
    end

    session[:total_score] ||= 0
    session[:total_score] += @score
  end

  private

  def word_in_grid?(word, grid)
    word.chars.all? { |letter| word.count(letter) <= grid.count(letter) }
  end

  def english_word?(word)
    url = "https://dictionary.lewagon.com/#{word}"
    response = URI.open(url).read
    json = JSON.parse(response)
    json['found']
  end

  def compute_score(word, time_taken)
    (word.length * 10) - time_taken
  end
end
