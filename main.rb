require "rexml/document"
require "timeout"

require_relative 'lib/question'
require_relative 'lib/victorina'

file = File.new(__dir__ + '/data/questions.xml', "r:UTF-8")

abort "Файл #{file_name} не найден" unless File.exists?(file)

question_nodes = REXML::Document.new(file).root.elements.to_a
file.close

right_answers = 0
bad_answers = 0
user_input = nil

victorina = Victorina.from_node(question_nodes)
puts victorina.to_a

puts "Мини-викторина. Ответье на вопросы.\n"
victorina.to_a.each do |q|
  puts "#{q.question} Время на ответ #{q.time} секунд"
  var_for_present = q.variants.shuffle
  var_for_present.each_with_index do |variant, index|
    puts "#{index + 1}. #{variant}"
  end

  begin
    Timeout::timeout(q.time.to_i) do
      user_input = gets.chomp
      unless user_input.to_i.between?(1, 4)
        puts "Вводите цифру из диапозона предложенных вариантов"
        user_input = gets.chomp
      end
    end
  rescue Timeout::Error
    user_input = nil
  end

  chosen_index = user_input.to_i - 1

  if user_input.nil?
    puts "Время вышло, ответ #{q.right_variant}\n\r"
  elsif victorina.check_answer?(var_for_present, chosen_index, q)
    puts "Правильно\n\r"
    right_answers += 1
  elsif !victorina.check_answer?(var_for_present, chosen_index, q)
    puts "Неправильно, правильный ответ #{q.right_variant}\n\r"
    bad_answers += 1
  end
end

puts "Итого: правильных ответов: #{right_answers}"
puts "       неправильных ответов: #{bad_answers}"
