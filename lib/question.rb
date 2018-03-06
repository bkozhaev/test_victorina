class Question
  attr_reader :question, :right_variant_index, :variants, :right_variant, :time

  def self.from_node(node)
    text = node.elements['text'].text

    variants = []
    right_variant_index = nil
    right_variant = nil

    time = node.attributes['minutes']

    node.elements['variants'].elements.each_with_index do |variant, index|
      right_variant_index = index if variant.attributes['right']
      right_variant = variant.text if variant.attributes['right']
      variants << variant.text
    end

    new(text, variants, right_variant_index, right_variant, time)
  end

  def initialize(question, variants, right_variant_index, right_variant, time)
    @question = question
    @variants = variants
    @right_variant_index = right_variant_index
    @right_variant = right_variant
    @time = time
  end
end
