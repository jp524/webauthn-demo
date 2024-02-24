require 'rails_helper'

RSpec.describe 'StaticPages#index', type: :system do
  context 'when user is logged in' do
    let!(:user) { User.create(name: 'user', password: 'password') }

    it 'can access the page' do
      page.set_rack_session(user_id: user.id)
      page.set_rack_session(user_expires_at: 1.hour.from_now)

      visit static_pages_path
      expect(page).to have_current_path(static_pages_path)
    end
  end

  context 'when user is not logged in' do
    it 'cannot access the page' do
      visit static_pages_path
      expect(page).to have_current_path(new_sessions_user_path)
      expect(page).to have_content('Please log in to continue.')
    end
  end
end
