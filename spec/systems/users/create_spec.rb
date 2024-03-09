require 'rails_helper'

RSpec.describe User, '#create', type: :system do
  it 'create account with valid credentials' do
    before_count = described_class.count

    visit new_user_path
    expect(page).to have_content('User sign up')

    fill_in('Name', with: 'admin')
    fill_in('Password', with: 'password')
    fill_in('Password confirmation', with: 'password')

    click_on 'Create account'

    expect(page).to have_content('User account successfully created.')
    expect(described_class.count).to eq(before_count + 1)
  end

  it 'create account fails with invalid password confirmation' do
    before_count = described_class.count

    visit new_user_path
    expect(page).to have_content('User sign up')

    fill_in('Name', with: 'admin')
    fill_in('Password', with: 'password')
    fill_in('Password confirmation', with: 'password-typo')

    click_on 'Create account'

    expect(page).to have_current_path(new_user_path)
    expect(page).to have_content("Password confirmation doesn't match Password")
    expect(described_class.count).to eq(before_count)
  end
end
