require 'rails_helper'

RSpec.describe User do
  describe '#normalizes' do
    it 'does not change the name if not required' do
      user = User.create(name: 'validName', password: 'password')
      expect(user.name).to eq('validName')
    end

    it 'changes the name when required' do
      user = User.create(name: '  nameWithSpacesAround ', password: 'password')
      expect(user.name).to eq('nameWithSpacesAround')
    end
  end

  describe '#valid?' do
    subject(:user) { User.new(name: 'username', password: 'password') }

    it 'returns false when name contains invalid characters' do
      user.name = 'invalid!name%'
      expect(user).not_to be_valid
    end

    it 'returns false when password is too short' do
      user.password = '123'
      expect(user).not_to be_valid
    end

    it 'returns true when name and password have valid formats' do
      expect(user).to be_valid
    end
  end
end
