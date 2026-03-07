module Registration
  module OptionsBuilder
    def build_option_struct(value:, label: nil, hint: nil, link_errors: false, divider: false, revealed_question: nil)
      QuestionTypes::RadioOption.new(
        value:,
        label:,
        hint:,
        link_errors:,
        divider:,
        revealed_question:,
      )
    end
  end
end
