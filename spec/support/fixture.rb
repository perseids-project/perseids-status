module Fixture
  def self.html_fixture
    File.read(File.join(__dir__, 'fixtures', 'index.html'))
  end

  def self.json_fixture
    File.read(File.join(__dir__, 'fixtures', 'index.json'))
  end
end
