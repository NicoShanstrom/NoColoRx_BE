require 'rails_helper'

RSpec.describe SavedPrescription, type: :model do
  let(:user) { create(:user) }

  describe 'associations' do
    it { should belong_to(:user) }
  end

  describe 'validations' do
    subject { build(:saved_prescription, user: user) }

    it { should validate_presence_of(:drug_name) }
    it { should validate_presence_of(:manufacturer) }
    it { should validate_presence_of(:description) }
    it { should validate_presence_of(:package_label_principal_display_panel) }
    it { should validate_presence_of(:metadata) }

    context 'when metadata is invalid' do
      it 'adds an error if metadata is not a hash' do
        subject.metadata = 'invalid metadata'
        expect(subject).not_to be_valid
        expect(subject.errors[:metadata]).to include('must include an openfda hash')
      end

      it 'adds an error if metadata does not include openfda' do
        subject.metadata = { key: 'value' }
        expect(subject).not_to be_valid
        expect(subject.errors[:metadata]).to include('must include an openfda hash')
      end
    end
  end

  describe 'custom validations' do
    it 'validates the presence of openfda within metadata' do
      prescription = build(:saved_prescription, user: user, metadata: { openfda: { brand_name: 'Test' } })
      expect(prescription).to be_valid
    end

    it 'is invalid if openfda is missing from metadata' do
      prescription = build(:saved_prescription, user: user, metadata: {})
      expect(prescription).not_to be_valid
      expect(prescription.errors[:metadata]).to include('must include an openfda hash')
    end
  end
end
