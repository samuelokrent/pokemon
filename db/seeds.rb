# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
require 'json'

pokedex = JSON.load(File.read(Rails.root.join('config', 'pokedex.json')))
pokedex.each do |p|
  begin
    pokemon = PokemonBase.find_or_create_by(name: p['name']['english'])
    pokemon.update_attributes({
      type_one: p['type'][0],
      type_two: ['type'][1],
      hp: p['base']['HP'],
      image: "#{p['id'].to_s.rjust(3, '0')}.png",
    })
  rescue Exception => e
    puts "Could not create pokemon: #{p['name']}"
  end
end

MultipleChoiceQuestion.destroy_all
raw_questions = File.read(Rails.root.join("config", "data", "multiple_choice.txt")).split("\n\n")
raw_questions.each do |raw|
  lines = raw.split("\n")
  answers = lines[1..4]
  shuffled = answers.shuffle
  MultipleChoiceQuestion.create({
    question: lines[0],
    correct_answer: answers[0],
    answer_1: shuffled[0],
    answer_2: shuffled[1],
    answer_3: shuffled[2],
    answer_4: shuffled[3],
  })
end
