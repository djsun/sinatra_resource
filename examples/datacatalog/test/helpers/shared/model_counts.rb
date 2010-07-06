class ResourceTestCase
  
  # == categories

  shared "no change in category count" do
    test "should not change number of category documents in database" do
      assert_equal @category_count, DataCatalog::Category.all.length
    end
  end

  shared "one less category" do
    test "should remove one category document from database" do
      assert_equal @category_count - 1, DataCatalog::Category.all.length
    end
  end
  
  shared "one new category" do
    test "should add one category document to database" do
      assert_equal @category_count + 1, DataCatalog::Category.all.length
    end
  end

  shared "category unchanged" do
    test "should not change category in database" do
      original = DataCatalog::Category.find_by_id(@category.id)
      assert_equal @category_copy.name, original.name
    end
  end

  # == notes

  shared "no change in note count" do
    test "should not change number of note documents in database" do
      assert_equal @note_count, DataCatalog::Note.all.length
    end
  end

  shared "one less note" do
    test "should remove one note document from database" do
      assert_equal @note_count - 1, DataCatalog::Note.all.length
    end
  end

  shared "one new note" do
    test "should add one note document to database" do
      assert_equal @note_count + 1, DataCatalog::Note.all.length
    end
  end

  shared "note unchanged" do
    test "should not change note in database" do
      original = DataCatalog::Note.find_by_id(@note.id)
      assert_equal @note_copy.text, original.text
      assert_equal @note_copy.user_id, original.user_id
    end
  end

  # == sources

  shared "no change in source count" do
    test "should not change number of source documents in database" do
      assert_equal @source_count, DataCatalog::Source.all.length
    end
  end

  shared "one less source" do
    test "should remove one source document from database" do
      assert_equal @source_count - 1, DataCatalog::Source.all.length
    end
  end

  shared "one new source" do
    test "should add one source document to database" do
      assert_equal @source_count + 1, DataCatalog::Source.all.length
    end
  end

  shared "source unchanged" do
    test "should not change source in database" do
      original = DataCatalog::Source.find_by_id(@source.id)
      assert_equal @source_copy.title, original.title
      assert_equal @source_copy.description, original.description
      assert_equal @source_copy.url, original.url
    end
  end

  # == usages

  shared "no change in usage count" do
    test "should not change number of user documents in database" do
      source = DataCatalog::Source.find_by_id(@source.id)
      assert_equal @usage_count, source.usages.length
    end
  end

  shared "one less usage" do
    test "should remove one user document from database" do
      source = DataCatalog::Source.find_by_id(@source.id)
      assert_equal @usage_count - 1, source.usages.length
    end
  end

  shared "one new usage" do
    test "should add one user document to database" do
      source = DataCatalog::Source.find_by_id(@source.id)
      assert_equal @usage_count + 1, source.usages.length
    end
  end

  shared "usage unchanged" do
    test "should not change usage in database" do
      source = DataCatalog::Source.find_by_id(@source.id)
      usage = source.usages.detect { |x| x.id == @usage_id }
      assert @usage_copy
      assert_equal @usage_copy, usage
    end
  end

  # == users

  shared "no change in user count" do
    test "should not change number of user documents in database" do
      assert_equal @user_count, DataCatalog::User.all.length
    end
  end

  shared "one less user" do
    test "should remove one user document from database" do
      assert_equal @user_count - 1, DataCatalog::User.all.length
    end
  end

  shared "one new user" do
    test "should add one user document to database" do
      assert_equal @user_count + 1, DataCatalog::User.all.length
    end
  end

  shared "user unchanged" do
    test "should not change user in database" do
      original = DataCatalog::User.find_by_id(@user.id)
      assert_equal @user_copy.name, original.name
      assert_equal @user_copy.email, original.email
      assert_equal @user_copy.role, original.role
    end
  end

end
