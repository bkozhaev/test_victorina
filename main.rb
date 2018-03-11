require "rexml/document"
require "timeout"

require_relative 'lib/question'
require_relative 'lib/victorina'

file = File.new(__dir__ + '/data/questions.xml', "r:UTF-8")

abort "Файл #{file_name} не найден" unless File.exists?(file)

question_nodes = REXML::Document.new(file).root.elements.to_a
file.close

victorina = Victorina.new
victorina.set_questions(question_nodes)

until victorina.finished?
  victorina.ask_questions
end

victorina.show_results