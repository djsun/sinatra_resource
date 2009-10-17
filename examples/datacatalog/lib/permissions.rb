require File.dirname(__FILE__) + '/../../../lib/sinatra_resource'

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
