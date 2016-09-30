module EventException
  class ParamsMissing < StandardError
    attr_accessor :info, :status

    def initialize(info: nil, status: nil)
      self.info = info
      self.status = status
    end

  end
end
