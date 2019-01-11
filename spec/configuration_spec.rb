RSpec.describe PerseidsStatus::Configuration do
  let(:config) do
    {
      fruit: {
        apple: 'https://apple.example.com',
        pear: { url: 'https://pear.example.com' },
        banana: { url: 'https://banana.example.com', compare: :wc },
      },
      vegetable: {
        carrot: 'https://carrot.example.com',
      }
    }
  end

  subject(:configuration) { PerseidsStatus::Configuration.new(config) }

  describe '#each' do
    it 'yields the given configuration' do
      results = []

      configuration.each do |test, page, request|
        results << [test, page, request.url, request.compare]
      end

      expect(results).to eq([
        [:fruit, :apple, 'https://apple.example.com', :diff],
        [:fruit, :pear, 'https://pear.example.com', :diff],
        [:fruit, :banana, 'https://banana.example.com', :wc],
        [:vegetable, :carrot, 'https://carrot.example.com', :diff],
      ])
    end

    it 'includes Enumerable methods' do
      expect(configuration.to_a.length).to eq(4)
    end
  end

  describe PerseidsStatus::Configuration::Request do
    let(:bundle) { 'https://apple.example.com' }

    subject(:request) { PerseidsStatus::Configuration::Request.new(bundle) }

    describe '#diff?' do
      its(:diff?) { should be_truthy }

      context 'configured with wc' do
        let(:bundle) { { url: 'https://apple.example.com', compare: :wc } }

        its(:diff?) { should be_falsey }
      end
    end

    describe '#wc?' do
      its(:wc?) { should be_falsey }

      context 'configured with wc' do
        let(:bundle) { { url: 'https://apple.example.com', compare: :wc } }

        its(:wc?) { should be_truthy }
      end
    end
  end
end
