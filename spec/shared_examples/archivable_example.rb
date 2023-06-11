# frozen_string_literal: true

shared_examples_for 'archivable' do |model_name|
  context "archivable #{model_name}" do
    let(:model) { create(model_name, archived: false) }

    it 'has method soft_delete' do
      expect(model).to respond_to(:soft_delete)
    end

    context 'archives described_class' do
      before { model.soft_delete }

      it 'is archived' do
        expect(model.archived).to be_truthy
      end
    end

    context 'archived' do
      before { model.soft_delete }

      it 'all_active does not returns archived' do
        expect do
          described_class.all_active.find model.id
        end.to raise_exception ActiveRecord::RecordNotFound
      end

      it 'all_archived returns archived items' do
        expect(described_class.all_archived.find(model.id)).to be_instance_of(described_class)
      end
    end

    context 'not archived' do
      it 'all_archived does not return active items' do
        expect do
          described_class.all_archived.find model.id
        end.to raise_exception ActiveRecord::RecordNotFound
      end

      it 'all_active returns active items' do
        expect(described_class.all_active.find(model.id)).to be_instance_of(described_class)
      end
    end
  end
end
