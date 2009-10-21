require File.expand_path(File.dirname(__FILE__) + '/../../../lib/sinatra_resource')

module DataCatalog
  
  module Roles
    include SinatraResource::Roles
  
    role :anonymous
    role :basic   => :anonymous
    role :owner   => :basic
    role :curator => :basic
    role :admin   => [:owner, :curator]
  end

end
