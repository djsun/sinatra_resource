module DataCatalog
  
  module Roles
    include SinatraResource::Roles
  
    role :anonymous
    role :basic
    role :owner
    role :curator
    role :admin
  end

end
