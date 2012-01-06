module Allowy
  class Registry
    def initialize(ctx)
      @context = ctx
    end

    def access_control_for!(subject)
      ac = access_control_for subject
      raise UndefinedAccessControlError unless ac
      ac
    end

    def access_control_for(subject)
      raise 'TODO'
    end

  end
end
