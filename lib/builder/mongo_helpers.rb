module SinatraResource
  
  class Builder

    module MongoHelpers
      
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
