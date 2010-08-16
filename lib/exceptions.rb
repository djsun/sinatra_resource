module SinatraResource

  class Error < RuntimeError; end

  class DefinitionError < Error; end
  class NotImplemented  < Error; end
  class UndefinedRole   < Error; end
  class ValidationError < Error; end

end
