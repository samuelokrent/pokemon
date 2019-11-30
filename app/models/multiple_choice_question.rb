class MultipleChoiceQuestion < ApplicationRecord
  def to_hash
    {
      id: self.id,
      question: self.question,
      answers: (1..4).to_a.map { |num| self.send(:"answer_#{num}") },
      correct_answer: self.correct_answer,
    }
  end
end
