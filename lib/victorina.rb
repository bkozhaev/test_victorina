class Victorina
  attr_reader :questions, :right_answers, :bad_answers

  def initialize(questions = [])
    @questions = questions
  end

  def self.from_node(node)
    questions = []
    node.each {|q| questions << Question.from_node(q)}

    new(questions)
  end

  def to_a
    @questions
  end

  def check_answer?(variants, answer, questions)
    variants[answer] == questions.right_variant
  end

  def coun_answers
    if check_answer?
      @right_answers += 1
    else
      @bad_answers += 1
    end
  end
end