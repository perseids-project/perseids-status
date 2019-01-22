RSpec.describe 'status script' do
  let(:tmpdir) { Dir.mktmpdir }
  let(:config) { Factory.config }
  let(:time) { '2000-01-02T0000000Z' }
  let(:mocks) do
    [
      ['https://apple.example.com', 'apple'],
      ['https://pear.example.com', 'pear'],
      ['https://carrot.example.com', 'carrot'],
      ['https://onion.example.com', 'onion'],
    ]
  end

  before do
    copy!('Gemfile')
    copy!('Gemfile.lock')
    copy!('lib')
    copy!('status')
    write!(JSON.pretty_generate(config), 'config.json')
    mock!(time, mocks)
  end

  after do
    rm!
  end

  describe 'recording canonical' do
    it 'records the results' do
      run!('-r')

      compare_file('apple', 'canonical', 'fruit', 'apple.html')
      compare_file('pear', 'canonical', 'fruit', 'pear.html')
      compare_file('carrot', 'canonical', 'vegetable', 'carrot.html')
      compare_file('onion', 'canonical', 'vegetable', 'onion.html')
    end
  end

  describe 'comparing against canonical' do
    let(:json_fixture) { Fixture.json_fixture }
    let(:html_fixture) { Fixture.html_fixture }

    before { run!('-r') }

    it 'compares the results' do
      mock_args = [
        {
          time: '2000-01-02T0000000Z',
          mocks: [
            ['https://apple.example.com', 'apple'],
            ['https://pear.example.com', 'pear'],
            ['https://carrot.example.com', 'tarroc'],
            ['https://onion.example.com', 'noino'],
          ],
        },
        {
          time: '2000-02-02T0000000Z',
          mocks: [
            ['https://apple.example.com', 'apple'],
            ['https://pear.example.com', 'aaaa'],
            ['https://carrot.example.com', 'tarroc'],
            ['https://onion.example.com', 'onion-diff'],
          ],
        },
        {
          time: 'time',
          mocks: [
            ['https://apple.example.com', 'apple'],
            ['https://pear.example.com', 'aaaa'],
            ['https://carrot.example.com', 'tarroc'],
            ['https://onion.example.com', 'onion-diff'],
          ],
        },
      ]

      results = mock_args.map do |args|
        mock!(args[:time], args[:mocks])

        run!
      end

      expect(results).to eq(
        [
          '',
          "fruit/pear doesn't match (diff)\nvegetable/onion doesn't match (wc)",
          "fruit/pear doesn't match (diff)\nvegetable/onion doesn't match (wc)",
        ],
      )

      compare_file(json_fixture, 'index.json')
      compare_file(html_fixture, 'index.html')
    end
  end

  def run!(*args)
    script_path = file('status')
    mock_path = file('mock')

    ruby = `which ruby`.chomp

    command = [
      "cd #{tmpdir}",
      '&&',
      "#{ruby} -r#{mock_path}",
      script_path,
      *args,
    ].join(' ')

    `#{command}`.chomp
  end

  def mock!(time, mocks)
    write!(Helpers.mock_file(time, mocks), 'mock.rb')
  end

  def compare_file(contents, *paths)
    file_contents = File.read(file(*paths))

    expect(contents).to eq(file_contents)
  end

  def copy!(*paths)
    FileUtils.copy_entry(
      File.join(__dir__, '..', *paths),
      file(*paths),
    )
  end

  def write!(content, *paths)
    File.open(file(*paths), 'w') { |f| f.write(content) }
  end

  def rm!(*paths)
    FileUtils.rm_r(file(*paths))
  end

  def file(*paths)
    File.join(tmpdir, *paths)
  end
end
