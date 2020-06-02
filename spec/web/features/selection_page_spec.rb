require 'features_helper'

RSpec.describe 'Visit selection' do
  it 'is successful' do
    visit '/'

    expect(page).to have_content('Search for shows')
  end
end
