require "rexml/document"
require "timeout"

require_relative 'lib/question'

file = File.new(__dir__ + '/data/questions.xml', "r:UTF-8")

abort "Файл #{file_name} не найден" unless File.exists?(file)

question_nodes = REXML::Document.new(file).root.elements.to_a
file.close

questions = []

question_nodes.each do |q|
  questions << Question.from_node(q)
end

puts "Мини-викторина. Ответье на вопросы.\n"
questions.each do |q|
  puts "#{q.question} Время на ответ #{q.time} минут"

  q.variants.shuffle.each_with_index do |variant, index|
    puts "#{index + 1}. #{variant}"
  end

  user_input = nil
  begin
    Timeout::timeout(q.time.to_i*60) do
      user_input = gets.chomp
    end
  rescue Timeout::Error
    user_input = nil
  end

  choosen_index = user_input.to_i - 1
  if q.variants[choosen_index] == q.right_variant
    puts "Правильно\n\r"
  elsif user_input == nil
    puts "Время вышло, ответ #{q.right_variant}\n\r"
  else
    puts "Неправильно, правильный ответ #{q.right_variant}\n\r"
  end
end
