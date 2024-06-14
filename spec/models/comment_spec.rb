# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Comment do
  describe 'Validations' do
    context 'when checking byte size of the text' do
      let(:user) { create(:user) }
      let(:tweet) { create(:tweet, user:) }
      let(:comment) { create(:comment, user:, tweet:) }

      it 'is valid with 280 bytes or less' do
        comment.body = 'a' * 280
        expect(comment).to be_valid
      end

      it 'is invalid with more than 280 bytes' do
        comment.body = 'a' * 281
        expect(comment).to be_invalid
        expect(comment.errors[:body]).to include(I18n.t('activerecord.errors.models.comment.attributes.body.too_large'))
      end
    end
  end
end
