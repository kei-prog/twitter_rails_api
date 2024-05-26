# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Tweet do
  describe 'Validations' do
    let(:user) { create(:user) }
    let(:tweet) { create(:tweet, user:) }

    context 'when checking image format' do
      it 'is valid with jpeg format' do
        tweet.images.attach(io: File.open('spec/fixtures/files/test.jpeg'), filename: 'test.jpeg',
                            content_type: 'image/jpeg')
        expect(tweet).to be_valid
      end

      it 'is valid with png format' do
        tweet.images.attach(io: File.open('spec/fixtures/files/test.png'), filename: 'test.png',
                            content_type: 'image/png')
        expect(tweet).to be_valid
      end

      it 'is invalid with formats other than jpeg or png' do
        tweet.images.attach(io: File.open('spec/fixtures/files/test.gif'), filename: 'test.gif',
                            content_type: 'image/gif')
        expect(tweet).to be_invalid
        expect(tweet.errors[:images]).to include(
          I18n.t('activerecord.errors.models.tweet.attributes.images.invalid_type')
        )
      end
    end

    context 'when checking image size' do
      it 'is valid if the size is less than or equal to 5MB' do
        large_image = Tempfile.new(['large', '.jpeg'])
        large_image.write('1' * 5.megabytes)
        tweet.images.attach(io: File.open(large_image.path), filename: 'large.jpeg', content_type: 'image/jpeg')
        large_image.close!
        large_image.unlink
        expect(tweet).to be_valid
      end

      it 'is invalid if the size is greater than 5MB' do
        large_image = Tempfile.new(['large', '.jpeg'])
        large_image.write("#{'1' * 5.megabytes}1")
        tweet.images.attach(io: File.open(large_image.path), filename: 'large.jpeg', content_type: 'image/jpeg')
        large_image.close!
        large_image.unlink
        expect(tweet).to be_invalid
        expect(tweet.errors[:images]).to include(I18n.t('activerecord.errors.models.tweet.attributes.images.too_large'))
      end
    end

    context 'when checking the number of images' do
      it 'is valid with up to 4 images' do
        4.times do
          tweet.images.attach(io: File.open('spec/fixtures/files/test.jpeg'), filename: 'test.jpeg',
                              content_type: 'image/jpeg')
        end
        expect(tweet).to be_valid
      end

      it 'is invalid with more than 4 images' do
        5.times do
          tweet.images.attach(io: File.open('spec/fixtures/files/test.jpeg'), filename: 'test.jpeg',
                              content_type: 'image/jpeg')
        end
        expect(tweet).to be_invalid
        expect(tweet.errors[:images]).to include(I18n.t('activerecord.errors.models.tweet.attributes.images.too_many'))
      end
    end

    context 'when checking byte size of the text' do
      it 'is valid with 280 bytes or less' do
        tweet.body = 'a' * 280
        expect(tweet).to be_valid
      end

      it 'is invalid with more than 280 bytes' do
        tweet.body = 'a' * 281
        expect(tweet).to be_invalid
        expect(tweet.errors[:body]).to include(I18n.t('activerecord.errors.models.tweet.attributes.body.too_large'))
      end
    end
  end
end
