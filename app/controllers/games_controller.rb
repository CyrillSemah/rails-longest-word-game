require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = generate_grid
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

  def generate_grid
    Array.new(10) { ('A'..'Z').to_a.sample }
  end

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
