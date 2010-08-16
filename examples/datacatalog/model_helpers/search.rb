module DataCatalog

  class Search

    # Returns an array of strings, tokenized with stopwords removed.
    #
    # @param [<String>] array
    #   An array of strings
    #
    # @return [<String>]
    def self.process(array)
      unstop(tokenize(array))
    end

    # Tokenize an array of strings.
    #
    # @param [<String>] array
    #   An array of strings
    #
    # @return [<String>]
    def self.tokenize(array)
      array.reduce([]) do |m, x|
        m << tokens(x)
      end.flatten.uniq
    end

    REMOVE = %r([!,;])

    # Tokenize a string, removing extra characters too.
    #
    # @param [String] string
    #
    # @return [<String>]
    def self.tokens(s)
      if s
        "#{s} ".downcase.
          gsub(REMOVE, ' ').
          gsub(%r(\. ), ' ').
          split(' ')
      else
        []
      end
    end

    STOP_WORDS = %w(
      a
      about
      and
      are
      as
      at
      be
      by
      data
      for
      from
      how
      in
      is
      it
      of
      on
      or
      set
      that
      the 
      this
      to
      was
      what
      when
      where
      an
      who
      will
      with
      the
    )

    # Remove stopwords from an array of strings.
    #
    # @param [<String>] array
    #   An array of strings
    #
    # @return [<String>]
    def self.unstop(array)
      array - STOP_WORDS
    end

  end

end
