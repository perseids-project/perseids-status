RSpec.describe PerseidsStatus::RequestMap do
  describe '.from_hash' do
    let(:config) { Factory.config }

    subject(:request_map) { PerseidsStatus::RequestMap.from_hash(config) }

    it 'converts the config hash to a flat list' do
      results = []

      request_map.each do |request|
        results << [request.url, request.test, request.name, request.compare]
      end

      expect(results).to eq(
        [
          ['https://apple.example.com', :fruit, :apple, 'diff'],
          ['https://pear.example.com', :fruit, :pear, 'diff'],
          ['https://carrot.example.com', :vegetable, :carrot, 'wc'],
          ['https://onion.example.com', :vegetable, :onion, 'wc'],
        ],
      )
    end
  end

  describe '#each' do
    subject(:request_map) { PerseidsStatus::RequestMap.new([1, 2, 3]) }

    it 'yields each member of the array' do
      results = []

      request_map.each { |n| results << n }

      expect(results).to eq([1, 2, 3])
    end
  end

  describe '#get' do
    subject(:request_map) { Factory.request_map }

    it 'gets the request based on the test and name' do
      request = request_map.get(:vegetable, :carrot)

      expect([request.url, request.test, request.name, request.compare])
        .to eq(['https://carrot.example.com', :vegetable, :carrot, 'wc'])
    end
  end
end
