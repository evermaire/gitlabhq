require 'spec_helper'

describe Gitlab::Ci::Config::Node::Validator do
  let(:validator) { Class.new(described_class) }
  let(:validator_instance) { validator.new(node) }
  let(:node) { spy('node') }

  describe 'delegated validator' do
    before do
      validator.class_eval do
        validates :test_attribute, presence: true
      end
    end

    context 'when node is valid' do
      before do
        allow(node).to receive(:test_attribute).and_return('valid value')
      end

      it 'validates attribute in node' do
        expect(node).to receive(:test_attribute)
        expect(validator_instance).to be_valid
      end

      it 'returns no errors' do
        validator_instance.validate

        expect(validator_instance.messages).to be_empty
      end
    end

    context 'when node is invalid' do
      before do
        allow(node).to receive(:test_attribute).and_return(nil)
      end

      it 'validates attribute in node' do
        expect(node).to receive(:test_attribute)
        expect(validator_instance).to be_invalid
      end

      it 'returns errors' do
        validator_instance.validate

        expect(validator_instance.messages).not_to be_empty
      end
    end
  end
end
