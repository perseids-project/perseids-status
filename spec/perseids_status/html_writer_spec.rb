RSpec.describe PerseidsStatus::HTMLWriter do
  let(:json) { Factory.json_fixture_json }
  let(:html_fixture) { Fixture.html_fixture }

  subject(:writer) { PerseidsStatus::HTMLWriter.new(json) }

  before do
    allow(PerseidsStatus::Utils).to receive(:write_file!)
  end

  describe '#write!' do
    it 'writes an HTML file' do
      path = File.join(__dir__, '..', '..', 'index.html')

      expect(PerseidsStatus::Utils).to receive(:write_file!).with(
        the_same_path_as(path),
        html_fixture,
      )

      writer.write!
    end
  end
end
