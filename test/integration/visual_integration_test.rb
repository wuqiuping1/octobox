require 'test_helper'

class VisualIntegrationTest < ActionDispatch::IntegrationTest

  # Make the Capybara DSL available in all integration tests
  include Capybara::DSL
  # Make `assert_*` methods behave like Minitest assertions
  include Capybara::Minitest::Assertions

  setup do
    stub_fetch_subject_enabled(value: false)
    stub_notifications_request
    stub_repository_request
    @user = create(:user)
  end

  # Reset sessions and driver between tests
  # Use super wherever this method is redefined in your individual test classes
  teardown do
    Capybara.reset_sessions!
    Capybara.use_default_driver
  end

  test 'render a blank index page' do
    visit root_path
    # Percy::Capybara.snapshot(page, name: '/')
    page.has_content?('Sign in')
  end

  test 'render the kitchen sink for a logged in user' do
    sign_in_as(@user)
    stub_fetch_subject_enabled
    visit login_path
    Percy::Capybara.snapshot(page, name: '/:auth kitchen-sink')
    page.has_selector?('table tr')
  end

end
