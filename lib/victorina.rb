class Victorina
  attr_reader :questions, :right_answers, :bad_answers

  def initialize
    @questions = []
    @right_answers = 0
    @bad_answers = 0
    @count = 0
    @user_input = nil
  end

  def set_questions(node)
    node.each do |q|
      @questions << Question.from_node(q)
    end
  end

  def finished?
    @questions.length == @count
  end

  def ask_questions
    puts "#{@questions[@count].question} время на вопрос #{questions[@count].time} секунд"
    @questions[@count].variants.each_with_index do |val, index|
      puts "#{index + 1}. #{val}"
    end

    begin
      Timeout::timeout(questions[@count].time.to_i) do
        @user_input = gets.chomp
        unless @user_input.to_i.between?(1, 4)
          puts "Вводите цифру из диапозона предложенных вариантов"
          @user_input = gets.chomp
        end
      end
    rescue Timeout::Error
      @user_input = nil
    end
    check_answers
    @count += 1
  end

  def check_answers
    answer = @user_input.to_i - 1
    if @user_input.nil?
      puts "Время вышло, ответ #{@questions[@count].right_variant}\n\r"
    elsif @questions[@count].right_variant == @questions[@count].variants[answer]
      puts "Правильно\n\r"
      @right_answers += 1
    else
      puts "Неправильно, правильный ответ #{@questions[@count].right_variant}\n\r"
      @bad_answers += 1
    end
  end

  def show_results
    puts "Итого правильных ответов: #{@right_answers}"
    puts "      неправильных ответов: #{@bad_answers}"
    puts "      неотвеченных ответов: #{@questions.length - (@right_answers + @bad_answers)}"
  end
end