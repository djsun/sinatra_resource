# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run the gemspec command
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{sinatra_resource}
  s.version = "0.4.9"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["David James"]
  s.date = %q{2010-02-03}
  s.description = %q{A DSL for creating RESTful actions with Sinatra and MongoMapper. It embraces the Resource Oriented Architecture as explained by Leonard Richardson and Sam Ruby.}
  s.email = %q{djames@sunlightfoundation.com}
  s.extra_rdoc_files = [
    "LICENSE",
     "README.mdown"
  ]
  s.files = [
    ".document",
     ".gitignore",
     "LICENSE",
     "README.mdown",
     "Rakefile",
     "VERSION",
     "examples/datacatalog/Rakefile",
     "examples/datacatalog/app.rb",
     "examples/datacatalog/config.ru",
     "examples/datacatalog/config/config.rb",
     "examples/datacatalog/config/config.yml",
     "examples/datacatalog/lib/base.rb",
     "examples/datacatalog/lib/resource.rb",
     "examples/datacatalog/lib/roles.rb",
     "examples/datacatalog/model_helpers/search.rb",
     "examples/datacatalog/models/categorization.rb",
     "examples/datacatalog/models/category.rb",
     "examples/datacatalog/models/note.rb",
     "examples/datacatalog/models/source.rb",
     "examples/datacatalog/models/usage.rb",
     "examples/datacatalog/models/user.rb",
     "examples/datacatalog/resources/categories.rb",
     "examples/datacatalog/resources/categories_sources.rb",
     "examples/datacatalog/resources/notes.rb",
     "examples/datacatalog/resources/sources.rb",
     "examples/datacatalog/resources/sources_usages.rb",
     "examples/datacatalog/resources/users.rb",
     "examples/datacatalog/tasks/db.rake",
     "examples/datacatalog/tasks/test.rake",
     "examples/datacatalog/test/helpers/assertions/assert_include.rb",
     "examples/datacatalog/test/helpers/assertions/assert_not_include.rb",
     "examples/datacatalog/test/helpers/lib/model_factories.rb",
     "examples/datacatalog/test/helpers/lib/model_helpers.rb",
     "examples/datacatalog/test/helpers/lib/request_helpers.rb",
     "examples/datacatalog/test/helpers/model_test_helper.rb",
     "examples/datacatalog/test/helpers/resource_test_helper.rb",
     "examples/datacatalog/test/helpers/shared/api_keys.rb",
     "examples/datacatalog/test/helpers/shared/common_body_responses.rb",
     "examples/datacatalog/test/helpers/shared/model_counts.rb",
     "examples/datacatalog/test/helpers/shared/status_codes.rb",
     "examples/datacatalog/test/helpers/test_cases/model_test_case.rb",
     "examples/datacatalog/test/helpers/test_cases/resource_test_case.rb",
     "examples/datacatalog/test/helpers/test_helper.rb",
     "examples/datacatalog/test/models/categorization_test.rb",
     "examples/datacatalog/test/models/category_test.rb",
     "examples/datacatalog/test/models/note_test.rb",
     "examples/datacatalog/test/models/search_test.rb",
     "examples/datacatalog/test/models/source_test.rb",
     "examples/datacatalog/test/models/user_test.rb",
     "examples/datacatalog/test/resources/categories/categories_delete_test.rb",
     "examples/datacatalog/test/resources/categories/categories_get_many_test.rb",
     "examples/datacatalog/test/resources/categories/categories_get_one_test.rb",
     "examples/datacatalog/test/resources/categories/categories_post_test.rb",
     "examples/datacatalog/test/resources/categories/categories_put_test.rb",
     "examples/datacatalog/test/resources/categories_sources/categories_sources_delete_test.rb",
     "examples/datacatalog/test/resources/categories_sources/categories_sources_get_many_test.rb",
     "examples/datacatalog/test/resources/categories_sources/categories_sources_get_one_test.rb",
     "examples/datacatalog/test/resources/categories_sources/categories_sources_post_test.rb",
     "examples/datacatalog/test/resources/categories_sources/categories_sources_put_test.rb",
     "examples/datacatalog/test/resources/notes/notes_get_many_test.rb",
     "examples/datacatalog/test/resources/notes/notes_get_one_test.rb",
     "examples/datacatalog/test/resources/notes/notes_post_test.rb",
     "examples/datacatalog/test/resources/sources/sources_delete_test.rb",
     "examples/datacatalog/test/resources/sources/sources_get_many_filter_test.rb",
     "examples/datacatalog/test/resources/sources/sources_get_many_search_test.rb",
     "examples/datacatalog/test/resources/sources/sources_get_many_test.rb",
     "examples/datacatalog/test/resources/sources/sources_get_one_test.rb",
     "examples/datacatalog/test/resources/sources/sources_post_test.rb",
     "examples/datacatalog/test/resources/sources/sources_put_test.rb",
     "examples/datacatalog/test/resources/sources_usages/sources_usages_delete_test.rb",
     "examples/datacatalog/test/resources/sources_usages/sources_usages_get_many_filter_test.rb",
     "examples/datacatalog/test/resources/sources_usages/sources_usages_get_many_test.rb",
     "examples/datacatalog/test/resources/sources_usages/sources_usages_get_one_test.rb",
     "examples/datacatalog/test/resources/sources_usages/sources_usages_post_test.rb",
     "examples/datacatalog/test/resources/sources_usages/sources_usages_put_test.rb",
     "examples/datacatalog/test/resources/users/users_delete_test.rb",
     "examples/datacatalog/test/resources/users/users_get_many_test.rb",
     "examples/datacatalog/test/resources/users/users_get_one_test.rb",
     "examples/datacatalog/test/resources/users/users_post_test.rb",
     "examples/datacatalog/test/resources/users/users_put_test.rb",
     "lib/builder.rb",
     "lib/builder/action_definitions.rb",
     "lib/builder/helpers.rb",
     "lib/builder/mongo_helpers.rb",
     "lib/exceptions.rb",
     "lib/resource.rb",
     "lib/roles.rb",
     "lib/sinatra_resource.rb",
     "notes/keywords.mdown",
     "notes/permissions.mdown",
     "notes/questions.mdown",
     "notes/see_also.mdown",
     "notes/synonyms.mdown",
     "notes/to_do.mdown",
     "notes/uniform_interface.mdown",
     "sinatra_resource.gemspec",
     "spec/sinatra_resource_spec.rb",
     "spec/spec_helper.rb",
     "tasks/spec.rake",
     "tasks/yard.rake"
  ]
  s.homepage = %q{http://github.com/djsun/sinatra_resource}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.5}
  s.summary = %q{RESTful actions with Sinatra and MongoMapper}
  s.test_files = [
    "spec/sinatra_resource_spec.rb",
     "spec/spec_helper.rb",
     "examples/datacatalog/app.rb",
     "examples/datacatalog/config/config.rb",
     "examples/datacatalog/lib/base.rb",
     "examples/datacatalog/lib/resource.rb",
     "examples/datacatalog/lib/roles.rb",
     "examples/datacatalog/model_helpers/search.rb",
     "examples/datacatalog/models/categorization.rb",
     "examples/datacatalog/models/category.rb",
     "examples/datacatalog/models/note.rb",
     "examples/datacatalog/models/source.rb",
     "examples/datacatalog/models/usage.rb",
     "examples/datacatalog/models/user.rb",
     "examples/datacatalog/resources/categories.rb",
     "examples/datacatalog/resources/categories_sources.rb",
     "examples/datacatalog/resources/notes.rb",
     "examples/datacatalog/resources/sources.rb",
     "examples/datacatalog/resources/sources_usages.rb",
     "examples/datacatalog/resources/users.rb",
     "examples/datacatalog/test/helpers/assertions/assert_include.rb",
     "examples/datacatalog/test/helpers/assertions/assert_not_include.rb",
     "examples/datacatalog/test/helpers/lib/model_factories.rb",
     "examples/datacatalog/test/helpers/lib/model_helpers.rb",
     "examples/datacatalog/test/helpers/lib/request_helpers.rb",
     "examples/datacatalog/test/helpers/model_test_helper.rb",
     "examples/datacatalog/test/helpers/resource_test_helper.rb",
     "examples/datacatalog/test/helpers/shared/api_keys.rb",
     "examples/datacatalog/test/helpers/shared/common_body_responses.rb",
     "examples/datacatalog/test/helpers/shared/model_counts.rb",
     "examples/datacatalog/test/helpers/shared/status_codes.rb",
     "examples/datacatalog/test/helpers/test_cases/model_test_case.rb",
     "examples/datacatalog/test/helpers/test_cases/resource_test_case.rb",
     "examples/datacatalog/test/helpers/test_helper.rb",
     "examples/datacatalog/test/models/categorization_test.rb",
     "examples/datacatalog/test/models/category_test.rb",
     "examples/datacatalog/test/models/note_test.rb",
     "examples/datacatalog/test/models/search_test.rb",
     "examples/datacatalog/test/models/source_test.rb",
     "examples/datacatalog/test/models/user_test.rb",
     "examples/datacatalog/test/resources/categories/categories_delete_test.rb",
     "examples/datacatalog/test/resources/categories/categories_get_many_test.rb",
     "examples/datacatalog/test/resources/categories/categories_get_one_test.rb",
     "examples/datacatalog/test/resources/categories/categories_post_test.rb",
     "examples/datacatalog/test/resources/categories/categories_put_test.rb",
     "examples/datacatalog/test/resources/categories_sources/categories_sources_delete_test.rb",
     "examples/datacatalog/test/resources/categories_sources/categories_sources_get_many_test.rb",
     "examples/datacatalog/test/resources/categories_sources/categories_sources_get_one_test.rb",
     "examples/datacatalog/test/resources/categories_sources/categories_sources_post_test.rb",
     "examples/datacatalog/test/resources/categories_sources/categories_sources_put_test.rb",
     "examples/datacatalog/test/resources/notes/notes_get_many_test.rb",
     "examples/datacatalog/test/resources/notes/notes_get_one_test.rb",
     "examples/datacatalog/test/resources/notes/notes_post_test.rb",
     "examples/datacatalog/test/resources/sources/sources_delete_test.rb",
     "examples/datacatalog/test/resources/sources/sources_get_many_filter_test.rb",
     "examples/datacatalog/test/resources/sources/sources_get_many_search_test.rb",
     "examples/datacatalog/test/resources/sources/sources_get_many_test.rb",
     "examples/datacatalog/test/resources/sources/sources_get_one_test.rb",
     "examples/datacatalog/test/resources/sources/sources_post_test.rb",
     "examples/datacatalog/test/resources/sources/sources_put_test.rb",
     "examples/datacatalog/test/resources/sources_usages/sources_usages_delete_test.rb",
     "examples/datacatalog/test/resources/sources_usages/sources_usages_get_many_filter_test.rb",
     "examples/datacatalog/test/resources/sources_usages/sources_usages_get_many_test.rb",
     "examples/datacatalog/test/resources/sources_usages/sources_usages_get_one_test.rb",
     "examples/datacatalog/test/resources/sources_usages/sources_usages_post_test.rb",
     "examples/datacatalog/test/resources/sources_usages/sources_usages_put_test.rb",
     "examples/datacatalog/test/resources/users/users_delete_test.rb",
     "examples/datacatalog/test/resources/users/users_get_many_test.rb",
     "examples/datacatalog/test/resources/users/users_get_one_test.rb",
     "examples/datacatalog/test/resources/users/users_post_test.rb",
     "examples/datacatalog/test/resources/users/users_put_test.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<djsun-mongo_mapper>, [">= 0.5.8.2", "< 0.6"])
      s.add_runtime_dependency(%q<mongo>, [">= 0.16", "< 1.0"])
      s.add_runtime_dependency(%q<sinatra>, [">= 0.9.4", "< 1.0"])
      s.add_runtime_dependency(%q<query_string_filter>, [">= 0.1.2"])
      s.add_development_dependency(%q<crack>, [">= 0.1.4"])
      s.add_development_dependency(%q<djsun-context>, [">= 0.5.6"])
      s.add_development_dependency(%q<jeremymcanally-pending>, [">= 0.1"])
      s.add_development_dependency(%q<rspec>, [">= 1.2.9"])
      s.add_development_dependency(%q<yard>, [">= 0.2.3.5"])
    else
      s.add_dependency(%q<djsun-mongo_mapper>, [">= 0.5.8.2", "< 0.6"])
      s.add_dependency(%q<mongo>, [">= 0.16", "< 1.0"])
      s.add_dependency(%q<sinatra>, [">= 0.9.4", "< 1.0"])
      s.add_dependency(%q<query_string_filter>, [">= 0.1.2"])
      s.add_dependency(%q<crack>, [">= 0.1.4"])
      s.add_dependency(%q<djsun-context>, [">= 0.5.6"])
      s.add_dependency(%q<jeremymcanally-pending>, [">= 0.1"])
      s.add_dependency(%q<rspec>, [">= 1.2.9"])
      s.add_dependency(%q<yard>, [">= 0.2.3.5"])
    end
  else
    s.add_dependency(%q<djsun-mongo_mapper>, [">= 0.5.8.2", "< 0.6"])
    s.add_dependency(%q<mongo>, [">= 0.16", "< 1.0"])
    s.add_dependency(%q<sinatra>, [">= 0.9.4", "< 1.0"])
    s.add_dependency(%q<query_string_filter>, [">= 0.1.2"])
    s.add_dependency(%q<crack>, [">= 0.1.4"])
    s.add_dependency(%q<djsun-context>, [">= 0.5.6"])
    s.add_dependency(%q<jeremymcanally-pending>, [">= 0.1"])
    s.add_dependency(%q<rspec>, [">= 1.2.9"])
    s.add_dependency(%q<yard>, [">= 0.2.3.5"])
  end
end

