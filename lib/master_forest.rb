require "master_forest/version"

module MasterForest
  class Term
    def initialize raw, left = nil, right = nil
      @raw = raw
      if raw.nil?
        @l, @r  = left, right
        @parsed = @l and @r
        raise "Empty node" unless @parsed
      end
    end

    def to_s
      @raw ||= ['`', l.to_s, r.to_s].join
    end

    def ==(other)
      to_s == other.to_s
    end

    def valid?
      /[^`ski]/.match(to_s).nil? and (subterm_length(0) == to_s.length)
    end

    def leaf?
      to_s[0] != '`'
    end

    def l
      shallow_parse unless @parsed
      @l
    end

    def r
      shallow_parse unless @parsed
      @r
    end

    def reduce
      return r   if to_s.start_with? '`i'
      return l.r if to_s.start_with? '``k'
      if to_s.start_with? '```s'
        return Term.new nil,
          (Term.new nil, l.l.r, l.r),
          (Term.new nil, l.l.r, r)
      end
      return self
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
