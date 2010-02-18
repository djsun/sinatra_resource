module SinatraResource

  module Utility

    # The reverse of +camelize+. Makes an underscored, lowercase form from
    # the expression in the string.
    #
    # @param [String] camel_cased_word
    #
    # @return [String]
    #
    # Example:
    #   "SourceGroup".underscore # => "source_group"
    #
    # (This method was adapted from ActiveSupport 2.3.5)
    def self.underscore(camel_cased_word)
      camel_cased_word.to_s.
        gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
        gsub(/([a-z\d])([A-Z])/,'\1_\2').
        tr("-", "_").
        downcase
    end

  end
end
