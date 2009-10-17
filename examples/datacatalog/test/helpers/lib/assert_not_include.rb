module Test
  module Unit
    module Assertions

      def assert_not_include(expected, actual, message = nil)
        _wrap_assertion do
          full_message = build_message(message,
            "<?> expected to not include\n<?>.\n", actual, expected)
          assert_block(full_message) do
            not actual.include?(expected)
          end
        end
      end
      
    end
  end
end