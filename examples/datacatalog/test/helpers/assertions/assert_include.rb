module Test
  module Unit
    module Assertions

      def assert_include(expected, actual, message = nil)
        _wrap_assertion do
          full_message = build_message(message,
            "<?> expected to include\n<?>.\n", actual, expected)
          assert_block(full_message) do
            actual.include?(expected)
          end
        end
      end
      
    end
  end
end