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
      assert_equal @category_copy, DataCatalog::Category.find_by_id(@category.id)
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
      assert_equal @note_copy, DataCatalog::Note.find_by_id(@note.id)
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
      assert_equal @source_copy, DataCatalog::Source.find_by_id(@source.id)
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
      assert_equal @user_copy, DataCatalog::User.find_by_id(@user.id)
    end
  end

end
