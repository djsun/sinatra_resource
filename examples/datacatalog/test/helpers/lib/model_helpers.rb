module ModelHelpers

  def self.included(includee)
    includee.extend(ClassMethods)
  end

  module ClassMethods

    # Is a document (looked up from +symbol+) missing +key+?
    #
    # @param [Symbol] document
    #
    # @param [Symbol] missing
    def missing_key(symbol, key)
      test "should be invalid" do
        document = instance_variable_get("@#{symbol}")
        assert_equal false, document.valid?
      end

      test "should have errors" do
        document = instance_variable_get("@#{symbol}")
        document.valid?
        expected = "can't be empty"
        assert_include expected, document.errors.errors[key]
      end
    end

  end

end
