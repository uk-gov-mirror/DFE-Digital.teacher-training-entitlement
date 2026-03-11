module Reception
  module Steps
    class CannotRegisterYetStep < ::Step
      def previous_step
        :start
      end

      def next_step
        previous_step
      end
    end
  end
end
