RSpec.configure do |config|
  config.before(:each, type: :system) do
    driven_by :selenium, using: :headless_chrome, screen_size: [ 1400, 900 ] do |driver_option|
      driver_option.add_argument("--incognito")
      driver_option.add_argument("--disable-search-engine-choice-screen")
    end
  end
end
