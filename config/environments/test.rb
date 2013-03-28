CruiseControl::Application.configure do
  # The test environment is used exclusively to run your application's
  # test suite.  You never need to work with it otherwise.  Remember that
  # your test database is "scratch space" for the test suite and is wiped
  # and recreated between test runs.  Don't rely on the data there!
  config.cache_classes = true

  # Log error messages when you accidentally call methods on nil.
  config.whiny_nils = true

  # Show full error reports and disable caching
  config.consider_all_requests_local = true
  config.action_controller.perform_caching             = false

  # Tell ActionMailer not to deliver emails to the real world.
  # The :test delivery method accumulates sent emails in the
  # ActionMailer::Base.deliveries array.
  config.action_mailer.delivery_method = :test

  #test_lib_path = "#{config.root}/test/lib"
  #puts "Test Lib: #{test_lib_path}"
  #config.autoload_paths += [test_lib_path]

  #puts config.autoload_paths.inspect
  
  config.active_support.deprecation = :stderr
end
