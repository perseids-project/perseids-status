RSpec.describe PerseidsStatus::Utils do
  describe '.curl' do
    before do
      stub_request(:get, 'https://www.example.com/').to_return(body: 'hello world')
    end

    it 'returns the response body of the request' do
      expect(PerseidsStatus::Utils.curl('https://www.example.com')).to eq('hello world')
    end
  end

  describe '.write_file!' do
    let(:file) { double }

    before do
      allow(FileUtils).to receive(:mkdir_p)
      allow(File).to receive(:open).with('/tmp/hello/world.txt', 'w').and_yield(file)
    end

    it 'writes the content to the given file' do
      expect(FileUtils).to receive(:mkdir_p).with('/tmp/hello')
      expect(file).to receive(:write).with('example content')

      PerseidsStatus::Utils.write_file!('/tmp/hello/world.txt', 'example content')
    end
  end

  describe '.remove_dir!' do
    let(:exists) { true }

    before do
      allow(File).to receive(:exist?).and_return(exists)
      allow(FileUtils).to receive(:rm_r)
    end

    it 'removes the directory' do
      expect(FileUtils).to receive(:rm_r).with('/tmp/hello/world.txt')

      PerseidsStatus::Utils.remove_dir!('/tmp/hello/world.txt')
    end

    context 'the directory does not exist' do
      let(:exists) { false }

      it 'does not remove the directory' do
        expect(FileUtils).to_not receive(:rm_r)

        PerseidsStatus::Utils.remove_dir!('/tmp/hello/world.txt')
      end
    end
  end
end
