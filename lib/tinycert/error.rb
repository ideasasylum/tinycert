module Tinycert
  class Error < StandardError
    attr_reader :response
    def initialize response
      error = JSON.parse response.body
      name = error['code']
      description = error['text']

      super "#{name} - #{description}"

      @response = response
    end

    def message
      "#{@response.code}: #{super}"
    end
  end
end
