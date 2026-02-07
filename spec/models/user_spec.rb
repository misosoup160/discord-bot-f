# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  describe '.find_or_create_from_auth_hash!' do
    let(:uid) { '123456' }
    let(:auth_hash) do
      {
        provider: 'discord',
        uid: uid,
        info: {
          name: 'carol'
        },
        extra: {
          raw_info: {
            discriminator: '1234'
          }
        }
      }
    end

    before do
      stub_request(:get, "#{Discordrb::API.api_base}/guilds/#{ENV['DISCORD_SERVER_ID']}")
        .to_return(body: { "owner_id": '123456' }.to_json, status: 200)
      stub_request(:get, "#{Discordrb::API.api_base}/guilds/#{ENV['DISCORD_SERVER_ID']}/members/#{uid}")
    end

    it '認証ハッシュから新しいユーザーを作成する' do
      user = User.find_or_create_from_auth_hash!(auth_hash)

      expect(user.uid).to eq('123456')
      expect(user.name).to eq('carol')
      expect(user.discriminator).to eq('1234')
      expect(user.owner).to be true
      expect(user.admin).to be true
    end

    it '2回目の呼び出しで既存のユーザーを返す' do
      first_user = User.find_or_create_from_auth_hash!(auth_hash)
      second_user = User.find_or_create_from_auth_hash!(auth_hash)

      expect(second_user).to eq(first_user)
    end
  end

  describe '.search' do
    let!(:alice) { create(:alice) }
    let!(:bob) { create(:bob) }

    it '名前とdiscriminatorで検索できる' do
      expect(User.search('alice#1234').first).to eq(alice)
    end

    it '空文字で全てのユーザーを返す' do
      expect(User.search('').count).to eq(2)
    end

    it '無効な検索パターンでnilを返す' do
      expect(User.search('%').first).to be_nil
    end
  end
end
