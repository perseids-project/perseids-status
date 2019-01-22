class PerseidsStatus
  class Request
    attr_reader :url, :test, :name, :compare
    attr_accessor :canonical, :result

    def initialize(url:, test:, name:, compare: 'diff', canonical: nil, result: nil)
      @url = url
      @test = test
      @name = name
      @compare = compare
      @canonical = canonical
      @result = result
    end

    def differs?
      raise RequestNotMadeError unless result
      raise CanonicalNotReadError unless canonical

      case compare
      when 'diff'
        canonical != result
      when 'wc'
        canonical.size != result.size
      else
        raise InvalidDiffTypeError
      end
    end

    class CanonicalNotReadError < StandardError
    end

    class InvalidDiffTypeError < StandardError
    end

    class RequestNotMadeError < StandardError
    end
  end
end
