RSpec.describe PerseidsStatus::Reader do
  let(:request_map) { Factory.request_map }
  let(:path) { 'example' }
  let(:contents) { ['onion-test', 'carrot-test', 'pear-test', 'apple-test'] }

  subject(:reader) { PerseidsStatus::Reader.new(request_map, path) }

  before do
    allow(File).to receive(:read).with(path_helper('fruit', 'apple.html')).and_return('apple-test')
    allow(File).to receive(:read).with(path_helper('fruit', 'pear.html')).and_return('pear-test')
    allow(File).to receive(:read).with(path_helper('vegetable', 'carrot.html')).and_return('carrot-test')
    allow(File).to receive(:read).with(path_helper('vegetable', 'onion.html')).and_return('onion-test')
  end

  describe '#read_canonical!' do
    it 'copies the results to canonical' do
      reader.read_canonical!

      request_map.each do |request|
        expect(request.canonical).to eq(contents.pop)
      end
    end
  end

  describe '#read_comparison!' do
    it 'copies the results to result' do
      reader.read_comparison!

      request_map.each do |request|
        expect(request.result).to eq(contents.pop)
      end
    end
  end

  def path_helper(test, name)
    the_same_path_as(File.join(__dir__, '..', '..', 'example', test, name))
  end
end
