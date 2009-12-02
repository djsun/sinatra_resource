gem 'query_string_filter', '>= 0.1.2'
require 'query_string_filter'

module SinatraResource
  
  class Builder

    module MongoHelpers

      # Make sure that +parent+ document is related to the +child+ document
      # by way of +association+. If not, return 404 Not Found.
      #
      # @param [MongoMapper::Document] parent
      #
      # @param [Symbol] association
      #
      # @param [String] child_id
      #
      # @return [MongoMapper::Document]
      def check_related?(parent, child_assoc, child_id)
        children = parent.send(child_assoc)
        find_child!(children, child_id)
        true
      end
      
      # Create a document from params. If not valid, returns 400.
      #
      # @param [Class] model
      #   a class that includes MongoMapper::Document
      #
      # @return [MongoMapper::Document]
      def create_document!(model)
        document = model.new(params)
        unless document.valid?
          error 400, convert(body_for(:invalid_document, document))
        end
        unless document.save
          error 400, convert(body_for(:internal_server_error))
        end
        document
      end

      # Create a nested document from params. If not valid, returns 400.
      #
      # @param [Class] child_model
      #   a class that includes either:
      #     * MongoMapper::Document
      #     * MongoMapper::EmbeddedDocument
      #
      # @param [String] child_id
      #
      # @return [MongoMapper::Document]
      def create_nested_document!(parent, child_assoc, child_model)
        child = child_model.new(params)
        if child_model.embeddable?
          parent.send(child_assoc) << child
          unless parent.valid?
            error 400, convert(body_for(:invalid_document, child))
          end
          unless parent.save
            error 400, convert(body_for(:internal_server_error))
          end
        else
          unless child.valid?
            error 400, convert(body_for(:invalid_document, child))
          end
          unless child.save
            error 400, convert(body_for(:internal_server_error))
          end
        end
        child
      end
      
      # Delete a document with +id+.
      #
      # @param [Class] model
      #   a class that includes MongoMapper::Document
      #
      # @param [String] id
      #
      # @return [MongoMapper::Document]
      def delete_document!(model, id)
        document = find_document!(model, id)
        document.destroy
        document
      end

      # Delete a nested document.
      #
      # @param [MongoMapper::Document] parent
      #
      # @param [Symbol] child_assoc
      #   association (a method) from parent to child
      #
      # @param [Class] child_model
      #   a class that includes either:
      #     * MongoMapper::Document
      #     * MongoMapper::EmbeddedDocument
      #
      # @param [String] id
      #
      # @return [MongoMapper::Document]
      def delete_nested_document!(parent, child_assoc, child_model, child_id)
        if child_model.embeddable?
          children = parent.send(child_assoc)
          child = find_child!(children, child_id)
          children.delete(child)
          unless parent.save
            error 400, convert(body_for(:internal_server_error))
          end
          child
        else
          delete_document!(child_model, child_id)
        end
      end

      # Find document with +child_id+ in +children+.
      #
      # @params [<MongoMapper::EmbeddedDocument>] children
      #
      # @params [String] child_id
      #
      # @return [MongoMapper::EmbeddedDocument]
      def find_child(children, child_id)
        raise Error, "children not true" unless children
        children.detect { |x| x.id == child_id }
      end

      # Find document with +child_id+ in +children+ or raise 404.
      #
      # @params [<MongoMapper::EmbeddedDocument>] children
      #
      # @params [String] child_id
      #
      # @return [MongoMapper::EmbeddedDocument]
      def find_child!(children, child_id)
        child = find_child(children, child_id)
        error 404, convert(body_for(:not_found)) unless child
        child
      end

      # Find a document with +id+. If not found, returns 404.
      #
      # @param [Class] model
      #   a class that includes MongoMapper::Document
      #
      # @param [String] id
      #
      # @return [MongoMapper::Document]
      def find_document!(model, id)
        document = model.find_by_id(id)
        unless document
          error 404, convert(body_for(:not_found))
        end
        document
      end

      # Find a nested document. If not found, returns nil.
      #
      # @param [MongoMapper::Document] parent_document
      #
      # @param [Symbol] association
      #
      # @param [Class] child_model
      #   a class that includes either:
      #     * MongoMapper::Document
      #     * MongoMapper::EmbeddedDocument
      #
      # @param [String] child_id
      #
      # @return [MongoMapper::Document]
      def find_nested_document(parent, child_assoc, child_model, child_id)
        if child_model.embeddable?
          children = parent.send(child_assoc)
          find_child(children, child_id)
        else
          child_model.find_by_id(child_id)
        end
      end
      
      # Find a nested document. If not found, returns 404.
      #
      # @param [MongoMapper::Document] parent_document
      #
      # @param [Symbol] association
      #
      # @param [Class] child_model
      #   a class that includes either:
      #     * MongoMapper::Document
      #     * MongoMapper::EmbeddedDocument
      #
      # @param [String] child_id
      #
      # @return [MongoMapper::Document]
      def find_nested_document!(parent, child_assoc, child_model, child_id)
        document = find_nested_document(parent, child_assoc, child_model, child_id)
        unless document
          error 404, convert(body_for(:not_found))
        end
        document
      end

      # Find +model+ documents: find all documents if no params, otherwise
      # find selected documents.
      #
      # @param [Class] model
      #   a class that includes MongoMapper::Document
      #
      # @return [Array<MongoMapper::Document>]
      def find_documents!(model)
        return(model.all) if params.empty?
        model.all(make_conditions(params, model))
      end

      # Find nested +child_model+ documents: find all documents if no
      # params, otherwise find selected documents.
      #
      # @param [MongoMapper::Document] parent
      #
      # @param [Symbol] child_assoc
      #   association (a method) from parent to child
      #
      # @param [Class] child_model
      #   a class that includes either:
      #     * MongoMapper::Document
      #     * MongoMapper::EmbeddedDocument
      #
      # @return [Array<MongoMapper::Document>]
      def find_nested_documents!(parent, child_assoc, child_model)
        documents = if child_model.embeddable?
          children = parent.send(child_assoc)
          if params.empty?
            children
          else
            select_by(children, make_conditions(params, child_model))
          end
        else
          children = if params.empty?
            child_model.all
          else
            child_model.all(make_conditions(params, child_model))
          end
          select_related(parent, child_assoc, children)
        end
      end
      
      # Delegates to application, who should use custom logic to relate
      # +parent+ and +child+.
      #
      # @param [MongoMapper::Document] parent
      #   a class that includes MongoMapper::Document
      #
      # @param [MongoMapper::Document] child
      #
      # @param [Hash] resource_config
      #
      # @return [MongoMapper::Document] child document
      def make_related(parent, child, resource_config)
        proc = resource_config[:relation][:create]
        proc.call(parent, child) if proc
        child
      end
      
      # Update a document with +id+ from params. If not valid, returns 400.
      #
      # @param [Class] model
      #   a class that includes MongoMapper::Document
      #
      # @param [String] id
      #
      # @return [MongoMapper::Document]
      def update_document!(model, id)
        document = model.update(id, params)
        unless document.valid?
          error 400, convert(body_for(:invalid_document, document))
        end
        document
      end
      
      # Update a nested document with params. If not valid, returns 400.
      #
      # @param [MongoMapper::Document] parent
      #
      # @param [Symbol] child_assoc
      #   association (a method) from parent to child
      #
      # @param [Class] child_model
      #   a class that includes either:
      #     * MongoMapper::Document
      #     * MongoMapper::EmbeddedDocument
      #
      # @param [String] child_id
      #
      # @return [MongoMapper::Document]
      def update_nested_document!(parent, child_assoc, child_model, child_id)
        if child_model.embeddable?
          children = parent.send(child_assoc)
          child = find_child!(children, child_id)
          child_index = children.index(child)
          child.attributes = params
          children[child_index] = child
          unless parent.save
            error 400, convert(body_for(:internal_server_error))
          end
          child
        else
          update_document!(child_model, child_id)
        end
      end
      
      protected
      
      QS_FILTER = QueryStringFilter.new
      
      # Build conditions hash based on +params+.
      #
      # @param [Hash] params
      #
      # @param [Class] model
      #   a class that includes MongoMapper::Document
      #
      # @return [Hash]
      def make_conditions(params, model)
        search_string = params[SEARCH_KEY]
        filter_string = params[FILTER_KEY]
        if search_string && filter_string
          error 400, convert(body_for(:invalid_params, [FILTER_KEY]))
        elsif search_string
          { :_keywords => search_string.downcase }
        elsif filter_string
          unsafe = QS_FILTER.parse(filter_string)
          sanitize(unsafe, model)
        else
          {}
        end
      end
      
      # Filter out +conditions+ that do not have corresponding keys in
      # +model+. This is part of the process that prevents a user from
      # searching for parameters that they do not have access to.
      #
      # TODO: in order for this model to do the job stated above, it will
      # need to get access to the current role as well.
      #
      # @param [Hash] conditions
      #   A hash of unsanitized conditions
      #
      # @param [Class] model
      #   a class that includes MongoMapper::Document
      #
      # @return [Hash]
      def sanitize(conditions, model)
        conditions # TODO: incomplete
      end

      # Select +children+ that match +conditions+.
      #
      # This method is needed because MongoMapper does not have +all+
      # defined on the proxy for an embedded document many association.
      #
      # It does not currently support conditions such as the following:
      #   :value => { '$gte' => 3 }
      #   :value => { '$in' => [24, 36, 48] }
      #
      # @params [<MongoMapper::EmbeddedDocument>] children
      #
      # @params [Hash] conditions
      #
      # @return [<MongoMapper::EmbeddedDocument>]
      def select_by(children, conditions)
        children.select do |child|
          match = true
          conditions.each_pair do |key, value|
            match &&= case value
            when String, Integer
              child[key] == value
            when Regexp
              child[key] =~ value
            else raise Error, "embedded document search does not " +
              "support: #{value.inspect}"
            end
          end
          match
        end
      end

      # Select only the +children+ that are related to the +parent+ by
      # way of the +association+.
      #
      # @param [MongoMapper::Document] parent
      #   a class that includes MongoMapper::Document
      #
      # @param [Symbol] association
      #
      # @param [Array<MongoMapper::Document>] children
      #
      # @return [MongoMapper::Document]
      def select_related(parent, child_assoc, children)
        children.select do |child|
          parent.send(child_assoc).detect { |x| x.id == child.id }
        end
        # Note: This has O^2 complexity because of the nesting.
        # Can it be done more quickly?
      end

    end

  end

end
