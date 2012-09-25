require 'dalli'

module MasterForest
  class MemcacheTerm < Term
    def initialize raw, left = nil, right = nil
      @cache = Dalli::Client.new 'localhost:11211'
      super raw, left, right
    end

    def fully_reduce depth = Float::INFINITY
      cur = self
      redices = [self]
      1.upto(depth) do
        reduced = @cache.get cur.to_s
        if reduced
          cache! redices, reduced
          return reduced
        end

        reduced = cur.reduce
        if reduced.normal?
          cache! redices, reduced
          return reduced
        else
          redices << reduced
        end
        cur = reduced
      end
      cur
    end

    private

    def cache! redices, redux
      redices.each { |redex|
        @cache.set redex.to_s, redux.to_s
      }
    end

  end
end
