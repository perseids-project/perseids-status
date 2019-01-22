RSpec.describe PerseidsStatus::JSONReader do
  let(:exists) { true }
  let(:json) { Factory.json }
  let(:unparsed_json) { Factory.json.to_json }
  let(:path) { File.join(__dir__, '..', '..') }

  subject(:reader) { PerseidsStatus::JSONReader.new }

  before do
    allow(File).to receive(:exist?).and_return(exists)
    allow(File).to receive(:read).and_return(unparsed_json)
  end

  describe '#read!' do
    let(:filepath) { File.join(path, 'index.json') }

    it 'reads the file' do
      expect(File).to receive(:exist?).with(the_same_path_as(filepath))
      expect(File).to receive(:read).with(the_same_path_as(filepath))

      reader.read!
    end

    context 'the file does not exist' do
      let(:exists) { false }

      it 'reads the file' do
        expect(File).to receive(:exist?).with(the_same_path_as(filepath))
        expect(File).to_not receive(:read)

        reader.read!
      end
    end
  end

  describe '#json' do
    before { reader.read! }

    its(:json) { should eq(json) }

    context 'the file does not exist' do
      let(:exists) { false }

      its(:json) { should eq([]) }
    end
  end

  describe 'location' do
    before { reader.read! }

    it 'gets a previous version' do
      expect(reader.location('comparison-2000-01-02T0000000Z')).to eq('comparison-2000-01-02T0000000Z')
    end

    it 'raises an exception when it cannot find the version' do
      expect { reader.location('comparison-3000-01-01T0000000Z') }
        .to raise_error(PerseidsStatus::JSONReader::JSONVersionNotFound)
    end

    context 'the file does not exist' do
      let(:exists) { false }

      it 'raises an exception' do
        expect { reader.location('comparison-2000-01-01T0000000Z') }
          .to raise_error(PerseidsStatus::JSONReader::JSONVersionNotFound)
      end
    end
  end
end
