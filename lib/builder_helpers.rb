module SinatraResource
  
  class Builder

    module Helpers

      # Is +role+ authorized for +action+, and, if specified, +property+?
      #
      # @param [Symbol] role
      #   a role (such as :anonymous, :basic, or :admin)
      #
      # @param [Symbol] action
      #   :read, :create, :update, or :delete
      #
      # @param [Symbol] property
      #   a property of a resource
      #
      # @return [Boolean]
      #
      # @api private
      def authorized?(role, action, property=nil)
        klass = config[:roles]
        klass.validate_role(role)
        klass.satisfies?(role, minimum_role(action, property))
      end
      
      # Default body message for a +situation+
      #
      # @param [Symbol] situation
      #
      # @param [MongoMapper::Document, nil] document
      #
      # @return [String]
      #
      # @api public
      def body_for(situation, document=nil)
        case situation
        when :internal_server_error
          nil
        when :invalid_document
          { "errors" => document.errors.errors }
        when :not_found
          nil
        when :unauthorized
          nil
        end
      end
      
      # Build a resource for +action+ with +properties+, based on a
      # +document+.
      #
      # @param [Symbol] action
      #   :read, :create, :update, or :delete
      #
      # @param [Symbol] role
      #   a role (such as :anonymous, :basic, or :admin)
      #
      # @param [MongoMapper::Document] document
      #
      # @return [Hash<String => Object>]
      #
      # @api public
      def build_resource(action, role, document)
        resource = {}
        config[:properties].each_pair do |property, hash|
          if authorized?(role, action, property)
            resource[property.to_s] = value(property, document, hash)
          end
        end
        resource
      end

      # Halt unless the current params are ok for +action+
      #
      # @param [Symbol] action
      #   :read, :create, :update, or :delete
      #
      # @return [undefined]
      #
      # @api public
      def check_params(action)
        # TODO
      end

      # Halt unless the current role has permission to carry out +action+
      #
      # @param [Symbol] action
      #   :read, :create, :update, or :delete
      #
      # @return [Symbol]
      #   a role (such as :anonymous, :basic, or :admin)
      #
      # @api public
      def check_permission(action)
        role = lookup_role
        before_authorization(role, action)
        unless authorized?(role, action)
          error 401, display(body_for(:unauthorized))
        end
        role
      end
      
      # Create a document from params. If not valid, returns 400.
      #
      # @return [MongoMapper::Document]
      #
      # @api private
      def create_document!
        document = config[:model].new(params)
        unless document.valid?
          error 400, display(body_for(:invalid_document, document))
        end
        document
      end
      
      # Convert +object+ to desired format. (Perhaps JSON or XML)
      # 
      # @param [Object] object
      #
      # @return [String]
      #
      # @api public
      def display(object)
        # raise NotImplemented
        object.nil? ? nil : object.to_json
      end

      # Find a document using +id+. If not found, returns 404.
      #
      # @param [String] id
      #
      # @return [MongoMapper::Document]
      #
      # @api private
      def find_document!(id)
        document = config[:model].find_by_id(id)
        unless document
          error 404, display(body_for(:not_found))
        end
        document
      end

      # Find all +model+ documents.
      #
      # @param [Class] model
      #   a class that includes MongoMapper::Document
      #
      # @return [Array<MongoMapper::Document>]
      #
      # @api private
      def find_documents!
        config[:model].find(:all)
      end

      # Return the minimum role required for +action+, and, if specified,
      # +property+.
      #
      # @param [Symbol] action
      #   :read, :create, :update, or :delete
      #
      # @return [Symbol]
      #   a role (such as :anonymous, :basic, or :admin)
      #
      # @api public
      def minimum_role(action, property=nil)
        if property.nil?
          config[:permission][to_read_or_modify(action)]
        else
          config[:properties][property][to_r_or_w(action)]
        end || :anonymous
      end

      # Converts +action+ to :r or :w (i.e. read or write).
      #
      # @param [Symbol] action
      #   :read, :create, or :update
      #
      # @return [Symbol]
      #   :r or :w
      #
      # @api private
      def to_r_or_w(action)
        case action
        when :read   then :r
        when :create then :w
        when :update then :w
        else raise "Unexpected action : #{action.inspect}"
        end
      end

      # Converts +action+ to (:read or :modify).
      #
      # @param [Symbol] action
      #   :read, :create, :update, or :delete
      #
      # @return [Symbol]
      #   :read or :modify
      #
      # @api private
      def to_read_or_modify(action)
        case action
        when :read   then :read
        when :create then :modify
        when :update then :modify
        when :delete then :modify
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
      #
      # @api private
      def value(attribute, document, property_hash)
        if property_hash[:read_proc]
          proc = property_hash[:read_proc]
          # proc.call
        else
          document[:id == attribute ? :_id : attribute]
        end
      end
      
    end

  end

end
