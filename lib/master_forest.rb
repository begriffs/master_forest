require "master_forest/version"

module MasterForest
  class Term
    def initialize raw
      @raw = raw
    end

    def to_s
      @raw
    end

    def leaf?
      @raw[0] != '`'
    end

    def l
      shallow_parse if not @parsed
      @l
    end

    def r
      shallow_parse if not @parsed
      @r
    end

    private

    def subterm_length subterm_start
      balance = 1
      @raw[subterm_start..-1].chars.each_with_index do |symbol, offset|
        balance += (symbol == '`') ? 1 : -1
        return offset if balance == 0
      end
      raise "Unclosed application #{@raw}:#{subterm_start}"
    end

    def shallow_parse
      @parsed = true
      return if leaf?
      len = subterm_length 1
      @l  = Term.new @raw[1     .. 1+len]
      @r  = Term.new @raw[2+len .. -1   ]
    end
  end
end
