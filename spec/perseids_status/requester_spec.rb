RSpec.describe PerseidsStatus::Requester do
  let(:request_map) { Factory.request_map }
  let(:contents) { ['onion-test', 'carrot-test', 'pear-test', 'apple-test'] }

  subject(:requester) { PerseidsStatus::Requester.new(request_map) }

  before do
    allow(PerseidsStatus::Utils).to receive(:curl).with('https://apple.example.com').and_return('apple-test')
    allow(PerseidsStatus::Utils).to receive(:curl).with('https://pear.example.com').and_return('pear-test')
    allow(PerseidsStatus::Utils).to receive(:curl).with('https://carrot.example.com').and_return('carrot-test')
    allow(PerseidsStatus::Utils).to receive(:curl).with('https://onion.example.com').and_return('onion-test')
  end

  describe '#make_requests!' do
    it 'makes the requests and saves them' do
      requester.make_requests!

      request_map.each do |request|
        expect(request.result).to eq(contents.pop)
      end
    end
  end
end
