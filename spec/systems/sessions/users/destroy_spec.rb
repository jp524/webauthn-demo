require 'rails_helper'

RSpec.describe 'Sessions::Users#create', type: :system do
  let!(:user) { User.create(name: 'user', password: 'password') }

  it 'logouts' do
    page.set_rack_session(user_id: user.id)
    page.set_rack_session(user_expires_at: 1.hour.from_now)

    visit static_pages_path
    click_on 'Logout'

    expect(page).to have_current_path(root_path)
  end

  it 'removes the user-related sessions' do
    page.set_rack_session(user_id: user.id)
    page.set_rack_session(user_expires_at: 1.hour.from_now)

    visit static_pages_path
    click_on 'Logout'

    rack_session = page.get_rack_session
    expect(rack_session['user_id']).to be_nil
    expect(rack_session['user_expires_at']).to be_nil
  end
end
