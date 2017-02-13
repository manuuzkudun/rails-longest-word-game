require 'open-uri'
require 'json'

def generate_grid(grid_size)
  # TODO: generate random grid of letters
  grid = []
  grid_size.times { grid << ("A".."Z").to_a.sample }
  grid
end

def run_game(attempt, grid, start_time, end_time)
  # TODO: runs the game and return detailed hash of result
  if !contained?(attempt, grid)
    { score: 0, translation: fr_translation(attempt), message: "not in the grid" }
  elsif !english_word?(attempt)
    { score: 0, translation: nil, message: "not an english word" }
  else
    time = (end_time - start_time).to_i
    time <= 60 ? score = attempt.length * (1 - (end_time - start_time) / 60) : score = 0
    { score: score, translation: fr_translation(attempt), message: "well done" }
  end
end

# WORKS << checks if attempt is contained in grid
def contained?(attempt, grid)
  result = true
  a_grid = grid.clone.map { |elem| elem.upcase }
  attempt.upcase.split("").each do |letter|
    unless result == false
      result = a_grid.include?(letter.upcase)
      a_grid.delete_at(a_grid.index(letter.upcase)) if result == true
    end
  end
  result
end

# WORKS << checks if word is english
def english_word?(attempt)
  translated = fr_translation(attempt)
  translated.nil? ? false : true
end

# WORKS << translates based on inputs of source language and target language
def translation(attempt, source, target)
  translation_options = { source: source, target: target, key: '92d87927-4ce1-4d58-86a1-8f5516bba1bc' }
  url = "https://api-platform.systran.net/translation/text/translate?"
  url += "source=#{translation_options[:source]}&target=#{translation_options[:target]}&"
  url += "key=#{translation_options[:key]}&input=#{attempt.downcase}"
  translation_serialized = open(url).read
  JSON.parse(translation_serialized)["outputs"][0]["output"].downcase
end

# WORKS << provides the french translation from english source
def fr_translation(attempt)
  fr_translated = translation(attempt, 'en', 'fr')
  de_translated = translation(attempt, 'en', 'de')
  fr_translated == de_translated ? nil : fr_translated
end
