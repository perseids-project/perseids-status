RSpec.describe PerseidsStatus::Recorder do
  let(:request_map) { Factory.request_map }
  let(:path) { 'example' }

  subject(:recorder) { PerseidsStatus::Recorder.new(request_map, path) }

  before do
    allow(PerseidsStatus::Utils).to receive(:write_file!)
  end

  describe '#record!' do
    it 'records the results' do
      expect(PerseidsStatus::Utils).to receive(:write_file!).with(path_helper('fruit', 'apple.html'), 'apple')
      expect(PerseidsStatus::Utils).to receive(:write_file!).with(path_helper('fruit', 'pear.html'), 'figs')
      expect(PerseidsStatus::Utils).to receive(:write_file!).with(path_helper('vegetable', 'carrot.html'), 'torrac')
      expect(PerseidsStatus::Utils).to receive(:write_file!).with(path_helper('vegetable', 'onion.html'), 'onions')

      recorder.record!
    end
  end

  def path_helper(test, name)
    the_same_path_as(File.join(__dir__, '..', '..', 'example', test, name))
  end
end
