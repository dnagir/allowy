module Allowy
  module Matchers

    class AbleToMatcher
      def initialize(action, subject=nil)
        @action, @subject = action, subject
      end

      def say msg
        "#{msg} #{@action} #{@subject.inspect}" + if @context
          ' with ' + @context.inspect
        else
          ''
        end
      end

      def matches?(access_control)
        @context = access_control.context
        access_control.can?(@action, @subject)
      end

      def description
        say "be able to"
      end

      def failure_message
        say "expected to be able to"
      end

      def negative_failure_message
        say "expected NOT to be able to"
      end
    end

    ::RSpec::Matchers.define :be_able_to do |*args|
      m = AbleToMatcher.new(*args)
      match                           {|a| m.matches?(a) }
      failure_message_for_should      { m.failure_message }
      failure_message_for_should_not  { m.negative_failure_message }
      description                     { m.description }
    end

  end
end
