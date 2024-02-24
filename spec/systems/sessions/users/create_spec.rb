require 'rails_helper'

RSpec.describe 'Sessions::Users#create', type: :system do
  let!(:user) { User.create(name: 'user', password: 'password') }

  context 'when given valid credentials' do
    before do
      visit new_sessions_user_path

      fill_in('Name', with: 'user')
      fill_in('Password', with: 'password')

      freeze_time do
        click_on 'Log in'
      end
    end

    it 'logins successfully' do
      expect(page).to have_content('Successfully logged in.')
    end

    it 'redirects to static_pages#index' do
      sleep(0.5)
      expect(page).to have_current_path(static_pages_path)
    end

    it "sets 'user_id' session" do
      expect(page.get_rack_session_key('user_id')).to eq(user.id)
    end

    it "sets 'user_expires_at' session" do
      freeze_time do
        time = 1.hour.from_now
        time_in_iso = time.utc.iso8601(fraction_digits = 3)
        expect(page.get_rack_session_key('user_expires_at')).to eq(time_in_iso)
      end
    end
  end

  context 'when given invalid credentials' do
    it 'fails to login' do
      visit new_sessions_user_path

      fill_in('Name', with: 'user')
      fill_in('Password', with: 'wrong_password')

      click_on 'Log in'

      expect(page).to have_content('Login failed. Please verify your username and password.')
    end
  end
end
