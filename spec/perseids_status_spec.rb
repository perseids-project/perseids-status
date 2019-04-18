RSpec.describe PerseidsStatus do
  let(:config) { Factory.config }
  let(:request_map) { Factory.request_map }

  subject(:status) { PerseidsStatus.new(config) }

  before do
    allow(PerseidsStatus::RequestMap).to receive(:from_hash).with(config).and_return(request_map)
  end

  describe '#make_requests!' do
    let(:requester) { instance_double(PerseidsStatus::Requester) }

    before do
      allow(PerseidsStatus::Requester).to receive(:new).with(request_map).and_return(requester)
    end

    it 'makes the requests' do
      expect(requester).to receive(:make_requests!).with(no_args)

      expect(status.make_requests!).to eq(status)
    end
  end

  describe '#record_canonical!' do
    let(:recorder) { instance_double(PerseidsStatus::Recorder) }

    before do
      allow(PerseidsStatus::Recorder).to receive(:new).with(request_map, 'canonical').and_return(recorder)
    end

    it 'records the results' do
      expect(recorder).to receive(:record!).with(no_args)

      expect(status.record_canonical!).to eq(status)
    end
  end

  describe '#record_comparison!' do
    let(:recorder) { instance_double(PerseidsStatus::Recorder) }

    before do
      allow(Time).to receive_message_chain(:now, :strftime).with('%FT%H%M%LZ').and_return('time')
      allow(PerseidsStatus::Recorder).to receive(:new).with(request_map, 'comparison-time').and_return(recorder)
    end

    it 'records the results' do
      expect(recorder).to receive(:record!).with(no_args)

      expect(status.record_comparison!).to eq(status)
    end
  end

  describe '#read_canonical!' do
    let(:reader) { instance_double(PerseidsStatus::Reader) }

    before do
      allow(PerseidsStatus::Reader).to receive(:new).with(request_map, 'canonical').and_return(reader)
    end

    it 'reads the requests' do
      expect(reader).to receive(:read_canonical!).with(no_args)

      expect(status.read_canonical!).to eq(status)
    end
  end

  describe '#read_comparison!' do
    let(:reader) { instance_double(PerseidsStatus::Reader) }

    context 'current version' do
      before do
        allow(Time).to receive_message_chain(:now, :strftime).with('%FT%H%M%LZ').and_return('time')
        allow(PerseidsStatus::Reader).to receive(:new).with(request_map, 'comparison-time').and_return(reader)
      end

      it 'reads the requests' do
        expect(reader).to receive(:read_comparison!).with(no_args)

        expect(status.read_comparison!('current')).to eq(status)
      end
    end

    context 'previous version' do
      let(:json_reader) { instance_double(PerseidsStatus::JSONReader) }

      before do
        allow(PerseidsStatus::JSONReader).to receive(:new).with(no_args).and_return(json_reader)
        allow(json_reader).to receive(:location).with('version-input').and_return('version-output')
        allow(PerseidsStatus::Reader).to receive(:new).with(request_map, 'version-output').and_return(reader)
      end

      it 'reads the requests' do
        expect(json_reader).to receive(:read!).with(no_args)
        expect(reader).to receive(:read_comparison!).with(no_args)

        expect(status.read_comparison!('version-input')).to eq(status)
      end
    end
  end

  describe '#print_results' do
    let(:printer) { instance_double(PerseidsStatus::Printer) }

    before do
      allow(PerseidsStatus::Printer).to receive(:new).with(request_map).and_return(printer)
    end

    it 'prints the results' do
      expect(printer).to receive(:print).with(no_args)

      expect(status.print_results).to eq(status)
    end
  end

  describe '#write_json_and_html!' do
    let(:json_reader_before) { instance_double(PerseidsStatus::JSONReader, json: :json_before) }
    let(:json_reader_after) { instance_double(PerseidsStatus::JSONReader, json: :json_after) }
    let(:json_writer) { instance_double(PerseidsStatus::JSONWriter) }
    let(:html_writer) { instance_double(PerseidsStatus::HTMLWriter) }
    let(:count) { 10 }

    before do
      allow(Time).to receive_message_chain(:now, :strftime).with('%FT%H%M%LZ').and_return('time')
      allow(PerseidsStatus::JSONReader).to receive(:new).with(no_args).and_return(json_reader_before, json_reader_after)
      allow(PerseidsStatus::HTMLWriter).to receive(:new).with(:json_after, request_map).and_return(html_writer)
      allow(PerseidsStatus::JSONWriter)
        .to receive(:new).with(request_map, count, 'comparison-time', :json_before).and_return(json_writer)
    end

    it 'writes the files' do
      expect(json_reader_before).to receive(:read!).with(no_args)
      expect(json_writer).to receive(:write!).with(no_args)
      expect(json_writer).to receive(:clear!).with(no_args)
      expect(json_reader_after).to receive(:read!).with(no_args)
      expect(html_writer).to receive(:write!).with(no_args)

      expect(status.write_json_and_html!(count)).to eq(status)
    end
  end

  describe '#send_email!' do
    let(:emailer) { instance_double(PerseidsStatus::Emailer) }
    let(:email) { 'test@example.com' }
    let(:server) { 'your.smtp.server' }
    let(:port) { 25 }
    let(:domain) { 'mail.from.domain' }

    before do
      allow(PerseidsStatus::Emailer).to receive(:new).with(request_map, email, server, port, domain).and_return(emailer)
    end

    it 'sends the email' do
      expect(emailer).to receive(:send!).with(no_args)

      expect(status.send_email!(email, server, port, domain)).to eq(status)
    end
  end
end
