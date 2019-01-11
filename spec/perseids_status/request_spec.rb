RSpec.describe PerseidsStatus::Request do
  let(:compare) { 'wc' }
  let(:canonical) { 'apple-test' }
  let(:result) { 'apple-test' }
  let(:args) { { compare: compare, canonical: canonical, result: result } }

  subject(:request) do
    PerseidsStatus::Request.new(url: 'https://www.apple.example.com', test: 'fruit', name: 'apple', **args)
  end

  its(:url) { should eq('https://www.apple.example.com') }
  its(:test) { should eq('fruit') }
  its(:name) { should eq('apple') }
  its(:compare) { should eq('wc') }
  its(:canonical) { should eq('apple-test') }
  its(:result) { should eq('apple-test') }

  context 'with no optional args' do
    let(:args) { {} }

    its(:compare) { should eq('diff') }
    its(:canonical) { should be_nil }
    its(:result) { should be_nil }
  end

  describe 'canonical=' do
    it 'changes canonical' do
      request.canonical = 'apple-change'

      expect(request.canonical).to eq('apple-change')
    end
  end

  describe 'result=' do
    it 'changes result' do
      request.result = 'apple-change'

      expect(request.result).to eq('apple-change')
    end
  end

  describe '#differs?' do
    its(:differs?) { should be_falsey }

    context 'there is a difference with the same number of characters' do
      let(:result) { 'apple-abcd' }

      its(:differs?) { should be_falsey }
    end

    context 'there is a difference with a different number of characters' do
      let(:result) { 'apple-abcd-abcd' }

      its(:differs?) { should be_truthy }
    end

    context 'there is no result' do
      let(:result) { nil }

      it 'raises an exception' do
        expect { request.differs? }
          .to raise_error(PerseidsStatus::Request::RequestNotMadeError)
      end
    end

    context 'there is no canonical' do
      let(:canonical) { nil }

      it 'raises an exception' do
        expect { request.differs? }
          .to raise_error(PerseidsStatus::Request::CanonicalNotReadError)
      end
    end

    context 'the comparison is not recognized' do
      let(:compare) { 'something-else' }

      it 'raises an exception' do
        expect { request.differs? }
          .to raise_error(PerseidsStatus::Request::InvalidDiffTypeError)
      end
    end

    context 'the compare type is diff' do
      let(:compare) { 'diff' }

      its(:differs?) { should be_falsey }

      context 'there is a difference with the same number of characters' do
        let(:result) { 'apple-abcd' }

        its(:differs?) { should be_truthy }
      end
    end
  end
end
