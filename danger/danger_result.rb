module Danger

  class Result

    attr_reader :result_type, :message

    def initialize(result_type, message)
      @result_type = result_type
      @message = message
    end

    def self.failure(message)
      Result.new(:failure, message)
    end

    def self.warning(message)
      Result.new(:warning, message)
    end

    def self.ok(message)
      Result.new(:ok, message)
    end

  end

end