module SinatraResource

  class Error < RuntimeError; end
    
  class ValidationError < Error; end
  
  class DefinitionError < Error; end

end
