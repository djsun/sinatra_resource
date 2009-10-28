module SinatraResource
  
  class Builder

    module Helpers
      
      FILTER_KEY = "filter"
      
      # Build a resource, based on +document+, appropriate for +role+.
      #
      # @param [Symbol] role
      #   a role (such as :anonymous, :basic, or :admin)
      #
      # @param [MongoMapper::Document] document
      #
      # @param [Hash] resource_config
      #
      # @return [Hash<String => Object>]
      def build_resource(role, document, resource_config)
        resource = {}
        resource_config[:properties].each_pair do |property, hash|
          if authorized?(:read, role, resource_config, property)
            resource[property.to_s] = value(property, document, hash)
          end
        end
        resource
      end

      # Builds a list of resources, based on +documents+, using the
      # appropriate role for each document. (Delegates to +lookup_role+.)
      #
      # @param [Array<MongoMapper::Document>] documents
      #
      # @param [String] api_key
      #
      # @param [Hash] resource_config
      #
      # @return [Array<Hash<String => Object>>]
      def build_resources(documents, resource_config)
        documents.map do |document|
          build_resource(lookup_role(document), document, resource_config)
        end
      end

      # Halt unless the current params are ok for +action+ and +role+.
      #
      # @param [Symbol] action
      #   :list, :read, :create, :update, or :delete
      #
      # @param [Symbol] role
      #   a role (such as :anonymous, :basic, or :admin)
      #
      # @param [Hash] resource_config
      #
      # @param [Boolean] leaf
      #   If a simple resource, should be true.
      #   If a nested resource, are we at the 'end' (the leaf)?
      #
      # @return [undefined]
      def check_params(action, role, resource_config, leaf)
        return unless leaf
        params_check_action(action)
        params_check_action_and_role(action, role, resource_config)
      end

      # Halt unless the current role has permission to carry out +action+
      #
      # @param [Symbol] action
      #   :list, :read, :create, :update, or :delete
      #
      # @param [Symbol] role
      #   a role (such as :anonymous, :basic, or :admin)
      #
      # @param [Hash] resource_config
      #
      # @return [undefined]
      def check_permission(action, role, resource_config)
        before_authorization(action, role, resource_config)
        unless authorized?(action, role, resource_config)
          error 401, convert(body_for(:unauthorized))
        end
      end
      
      # Convert +object+ to desired format.
      #
      # For example, an application might want to convert +object+ to JSON or
      # XML.
      #
      # Applications must override this method.
      # 
      # @param [Object] object
      #
      # @return [String]
      def convert
        raise NotImplementedError
      end

      # Display +object+ as appropriate for +action+.
      #
      # @param [Symbol] action
      #   :list, :read, :create, :update, or :delete
      #
      # @param [Object] object
      #
      # @param [Hash] resource_config
      #
      # @return [String]
      def display(action, object, resource_config)
        case action
        when :list
        when :read
        when :create
          response.status = 201
          path = resource_config[:path] + %(/#{object["id"]})
          response.headers['Location'] = full_uri(path)
        when :update
        when :delete
          response.status = 204
        else
          raise Error, "Unexpected: #{action.inspect}"
        end
        convert(object)
      end
      
      def do_callback(name, resource_config, document)
        proc = resource_config[:callbacks][name]
        return unless proc
        if document
          proc.call(self, document)
        else
          proc.call(self)
        end
      end

      # Convert a path to a full URI.
      #
      # Applications must override this method.
      # 
      # @param [String] path
      #
      # @return [String]
      def full_uri(path)
        raise NotImplementedError
      end

      # Get role, using +id+ if specified. Delegates to +lookup_role+.
      #
      # When +id+ is present, it can help determine 'relative' roles such
      # as 'ownership' of the current user of a particular document.
      #
      # @param [String, nil] id
      #
      # @return [Symbol]
      def get_role(model, id=nil)
        lookup_role(id ? model.find_by_id(id) : nil)
      end

      # Return the minimum role required for +action+, and, if specified,
      # +property+.
      #
      # @param [Symbol] action
      #   :list, :read, :create, :update, or :delete
      #
      # @param [Hash] resource_config
      #
      # @param [Symbol, nil] property
      #
      # @return [Symbol]
      #   a role (such as :anonymous, :basic, or :admin)
      def minimum_role(action, resource_config, property=nil)
        if property.nil?
          p = resource_config[:permission]
          raise Error, "undefined #{action.inspect} permission" unless p
          p[action]
        else
          hash = resource_config[:properties][property]
          hash ? hash[to_r_or_w(action)] : :nobody
        end || :anonymous
      end
      
      protected

      # Is +role+ authorized for +action+, and, if specified, +property+?
      #
      # @param [Symbol] role
      #   a role (such as :anonymous, :basic, or :admin)
      #
      # @param [Symbol] action
      #   :list, :read, :create, :update, or :delete
      #
      # @param [Hash] resource_config
      #
      # @param [Symbol, nil] property
      #   a property of a resource
      #
      # @return [Boolean]
      def authorized?(action, role, resource_config, property=nil)
        klass = resource_config[:roles]
        klass.validate_role(role)
        klass.satisfies?(role, minimum_role(action, resource_config, property))
      end

      # Application-level hook that runs as part of +check_permission+,
      # before +authorized?(action, role, resource_config)+ is called.
      #
      # For example, an application might want to throw custom errors
      # in certain situations before +authorized?+ runs.
      #
      # Applications must override this method.
      # 
      # @param [Symbol] action
      #   :list, :read, :create, :update, or :delete
      #
      # @param [Symbol] role
      #   a role (such as :anonymous, :basic, or :admin)
      #
      # @param [Hash] resource_config
      #
      # @return [String]
      def before_authorization(action, role, resource_config)
        raise NotImplementedError
      end

      # Default body message for a +situation+
      #
      # @param [Symbol] situation
      #
      # @param [Object] object
      #
      # @return [String]
      def body_for(situation, object=nil)
        case situation
        when :errors
          { "errors" => object }
        when :internal_server_error
          ""
        when :invalid_document
          { "errors" => object.errors.errors }
        when :invalid_params
          { "errors" => { "invalid_params" => object } }
        when :no_params
          { "errors" => "no_params" }
        when :non_empty_params
          { "errors" => "non_empty_params" }
        when :not_found
          ""
        when :unauthorized
          { "errors" => "unauthorized_api_key" }
        end
      end

      # Lookup the rol, using +document+ if specified.
      #
      # Applications must override this method.
      #
      # @param [MongoMapper::Document, nil] document
      #
      # @return [Symbol]
      def lookup_role(document=nil)
        raise NotImplementedError
      end
      
      # Are the params suitable for +action+? Raise 400 Bad Request if not.
      #
      # @param [Symbol] action
      #   :list, :read, :create, :update, or :delete
      #
      # @param [Boolean] leaf
      #   If a simple resource, should be true.
      #   If a nested resource, are we at the 'end' (the leaf)?
      #
      # @return [undefined]
      def params_check_action(action)
        case action
        when :list
          unless params.reject { |k, v| k == FILTER_KEY }.empty?
            error 400, convert(body_for(:non_empty_params))
          end
        when :read
          unless params.empty?
            error 400, convert(body_for(:non_empty_params))
          end
        when :create
          # No need to complain. If there are problems,
          # params_check_action_and_role will catch them.
        when :update
          if params.empty?
            error 400, convert(body_for(:no_params))
          end
        when :delete
          unless params.empty?
            error 400, convert(body_for(:non_empty_params))
          end
        else
          raise Error, "Unexpected: #{action.inspect}"
        end
      end

      # Checks each parameter to make sure it is authorized for +action+ and
      # +role+. Raises a 400 Bad Request if not authorized.
      #
      # @param [Symbol] action
      #   :list, :read, :create, :update, or :delete
      #
      # @param [Symbol] role
      #   a role (such as :anonymous, :basic, or :admin)
      #
      # @param [Hash] resource_config
      #
      # @return [undefined]
      def params_check_action_and_role(action, role, resource_config)
        invalid = []
        params.each_pair do |property, value|
          next if property == FILTER_KEY
          if !authorized?(action, role, resource_config, property.intern)
            invalid << property
          end 
        end
        unless invalid.empty?
          error 400, convert(body_for(:invalid_params, invalid))
        end
      end

      # Converts +action+ to :r or :w (i.e. read or write).
      #
      # @param [Symbol] action
      #   :read, :create, or :update
      #
      # @return [Symbol]
      #   :r or :w
      def to_r_or_w(action)
        case action
        when :read   then :r
        when :create then :w
        when :update then :w
        else raise "Unexpected action : #{action.inspect}"
        end
      end

      # Lookup +attribute+ in +document+
      #
      # @param [Symbol] attribute
      #   an attribute of +document+
      #
      # @param [MongoMapper::Document] document
      #
      # @return [undefined]
      def value(attribute, document, property_hash)
        proc = property_hash[:read_proc]
        if proc
          proc.call(document)
        else
          document[attribute == :id ? :_id : attribute]
        end
      end

    end

  end

end
