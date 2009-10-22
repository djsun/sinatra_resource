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

end
