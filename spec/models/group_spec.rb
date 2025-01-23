# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Group do
  describe 'Validations' do
    context 'when checking the uniqueness of the sender_id and recipient_id' do
      let(:sender) { create(:user) }
      let(:recipient) { create(:user) }

      it 'is invalid with the same sender_id and recipient_id' do
        group = build(:group, sender:, recipient: sender)
        expect(group).to be_invalid
        expect(group.errors[:base]).to include(I18n.t('activerecord.errors.models.group.same_user'))
      end
    end
  end
end
