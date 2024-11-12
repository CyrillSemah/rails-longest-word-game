# test/system/games_test.rb
require "application_system_test_case"

class GamesTest < ApplicationSystemTestCase
  test "Going to /new gives us a new random grid to play with" do
    visit new_url
    assert_text "Voici votre grille de lettres :"
    assert_text "C A T X L K P N B R"  # Vérifie que la grille fixe est affichée
  end

  test "Filling out a word not in the grid gives an error message" do
    visit new_url
    fill_in "word", with: "xyz"  # Un mot impossible avec la grille fixe
    click_on "Envoyer"

    assert_text "Le mot ne peut pas être construit à partir de la grille"
  end

  test "Submitting a word that is not an English word returns an error message" do
    visit new_url
    fill_in "word", with: "zzz"  # Un mot non valide en anglais
    click_on "Envoyer"

    assert_text "Ce n'est pas un mot anglais valide."
  end

  test "Submitting a valid English word gives a success message" do
    visit new_url
    fill_in "word", with: "cat"  # Un mot valide avec la grille fixe
    click_on "Envoyer"

    assert_text "Bien joué !"
  end
end
