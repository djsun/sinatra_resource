module SinatraResource
  
  class Builder

    module MongoHelpers


      # Make sure that +parent+ document is related to the +child+ document
      # by way of +association+. If not, return 404 Not Found.
      #
      # @return [MongoMapper::Document]
      def check_related?(parent, association, child_id)
        unless parent.send(association).find { |x| x.id == child_id }
          error 404, convert(body_for(:not_found))
        end
      end
      
      # Create a document from params. If not valid, returns 400.
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
      
      # Delete a document with +id+.
      #
      # @param [String] id
      #
      # @return [MongoMapper::Document]
      def delete_document!(model, id)
        document = find_document!(model, id)
        document.destroy
        document
      end

      # Find a document with +id+. If not found, returns 404.
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

      # Find all +model+ documents.
      #
      # @param [Class] model
      #   a class that includes MongoMapper::Document
      #
      # @return [Array<MongoMapper::Document>]
      def find_documents!(model)
        model.find(:all)
      end

      # Select only the +children+ that are related to the +parent+ by
      # way of the +association+.
      #
      # @return [MongoMapper::Document]
      def select_related(parent, association, children)
        children.select do |child|
          parent.send(association).find { |x| x.id == child.id }
        end
        # TODO: this has O^2 complexity because of the nesting.
        # I think it is reducible to O.
      end

      # Update a document with +id+ from params. If not valid, returns 400.
      #
      # @return [MongoMapper::Document]
      def update_document!(model, id)
        document = model.update(id, params)
        unless document.valid?
          error 400, convert(body_for(:invalid_document, document))
        end
        document
      end

    end

  end

end
