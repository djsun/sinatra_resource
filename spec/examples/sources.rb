module DataCatalog

  class Sources
    include Resource

    model Source

    # == Permissions

    permission :read   => :basic
    permission :modify => :curator
    
    # == Properties

    property :title
    property :url
    property :released
    property :period_start
    property :period_end
    property :frequency
    property :organization_id
    property :custom,           :w => :admin
    property :raw,              :w => :admin

    property :id,               :w => :nobody
    property :created_at,       :w => :nobody
    property :updated_at,       :w => :nobody
    property :rating_stats,     :w => :nobody
    property :updates_per_year, :w => :nobody
    
    property :categories do
      categorizations.map do |categorization|
        {
          "id"   => categorization.category.id,
          "href" => "/categories/#{categorization.category.id}",
          "name" => categorization.category.name,
        }
      end
    end

    property :comments do
      comments.map do |comment|
        {
          "id"   => comment.id,
          "href" => "/comments/#{comment.id}",
          "text" => comment.text,
          "user" => {
            "name" => comment.user.name,
            "href" => "/users/#{comment.user.id}",
          },
          "rating_stats" => comment.rating_stats,
        }
      end
    end

    property :documents do
      documents.map do |document|
        {
          "id"   => document.id,
          "href" => "/documents/#{document.id}",
          "text" => document.text,
          "user" => {
            "name" => document.user.name,
            "href" => "/users/#{document.user.id}",
          }
        }
      end
    end
    
    property :notes do
      notes.map do |note|
        {
          "id"   => note.id,
          "href" => "/notes/#{note.id}",
          "text" => note.text,
          "user" => {
            "name" => note.user.name,
            "href" => "/users/#{note.user.id}",
          }
        }
      end
    end

    property :ratings do
      ratings.map do |rating|
        {
          "id"    => rating.id,
          "href"  => "/ratings/#{rating.id}",
          "text"  => rating.text,
          "value" => rating.value,
          "user"  => {
            "name" => rating.user.name,
            "href" => "/users/#{rating.user.id}",
          }
        }
      end
    end

    # == Callbacks
    
    callback :before_create do
      validate_custom_before_create(params["custom"])
    end

    callback :before_update do
      custom = params["custom"]
      validate_custom_before_update(custom)
      params["custom"] = self.class.merge_custom_fields(@document.custom, custom)
    end

    CUSTOM_ATTRIBUTES = %w(label description type value)
    
    def validate_custom_before_create(custom)
      return if custom.nil?
      custom.length.times do |i|
        unless custom.include?(i.to_s)
          error 400, { "errors" => "malformed custom field" }.to_json
        end
      end
      errors = []
      custom.each do |field, attrs|
        self.class.missing_custom_attrs(attrs).each do |attr|
          errors << "custom[#{field}] is missing attribute: #{attr}"
        end
        self.class.invalid_custom_attrs(attrs).each do |attr|
          errors << "custom[#{field}] has invalid attribute: #{attr}"
        end
      end
      unless errors == []
        error 400, { "errors" => errors }.to_json 
      end
    end

    def validate_custom_before_update(custom)
      return if custom.nil?
      errors = []
      custom.each do |field, attrs|
        return if attrs.nil?
        self.class.invalid_custom_attrs(attrs).each do |attr|
          errors << "custom[#{field}] has invalid attribute: #{attr}"
        end
      end
      unless errors == []
        error 400, { "errors" => errors }.to_json
      end
    end

    def self.merge_custom_fields(old_custom, new_custom)
      return if new_custom.nil?
      return new_custom if old_custom.nil?
      old_custom.to_hash.merge(new_custom) do |key, left, right|
        right.nil? ? nil : left.merge(right)
      end
    end
    
    def self.missing_custom_attrs(hash)
      CUSTOM_ATTRIBUTES - hash.keys
    end
    
    def self.invalid_custom_attrs(hash)
      hash.keys - CUSTOM_ATTRIBUTES
    end
  end

end
