RSpec.describe PerseidsStatus::JSONWriter do
  let(:json) { Factory.json }
  let(:json_fixture) { Fixture.json_fixture }
  let(:request_map) { Factory.request_map }
  let(:count) { 10 }
  let(:comparison_path) { 'comparison-time' }

  subject(:writer) { PerseidsStatus::JSONWriter.new(request_map, count, comparison_path, json) }

  before do
    allow(PerseidsStatus::Utils).to receive(:write_file!)
    allow(PerseidsStatus::Utils).to receive(:remove_dir!)
  end

  describe '#write!' do
    it 'writes a JSON file' do
      path = File.join(__dir__, '..', '..', 'index.json')

      expect(PerseidsStatus::Utils).to receive(:write_file!).with(
        the_same_path_as(path),
        json_fixture,
      )

      writer.write!
    end
  end

  describe '#clear!' do
    before { writer.write! }

    it 'does not remove any data' do
      expect(PerseidsStatus::Utils).to_not receive(:remove_dir!)

      writer.clear!
    end

    context 'more results than count' do
      let(:count) { 1 }

      it 'removes the older directories' do
        path1 = File.join(__dir__, '..', '..', 'comparison-2000-02-02T0000000Z')
        path2 = File.join(__dir__, '..', '..', 'comparison-2000-01-02T0000000Z')

        expect(PerseidsStatus::Utils).to receive(:remove_dir!).with(the_same_path_as(path1))
        expect(PerseidsStatus::Utils).to receive(:remove_dir!).with(the_same_path_as(path2))
        expect(PerseidsStatus::Utils).to_not receive(:remove_dir!)

        writer.clear!
      end
    end
  end
end
