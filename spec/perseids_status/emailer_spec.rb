RSpec.describe PerseidsStatus::Emailer do
  let(:json) { Factory.json }
  let(:email) { 'test@example.com' }
  let(:mailer) { double }
  let(:message) do
    "From: Perseids Status <status@perseids.org>\n" \
    "To: <test@example.com>\n" \
    "Subject: Perseids Status\n\n" \
    "fruit/pear doesn't match: ok -> diff\n" \
    "vegetable/onion doesn't match: ok -> wc\n"
  end

  subject(:emailer) { PerseidsStatus::Emailer.new(json, email) }

  before do
    allow(Net::SMTP).to receive(:start).with('localhost').and_yield(mailer)
  end

  describe '#send!' do
    it 'sends an email' do
      expect(mailer).to receive(:send_message).with(message, 'status@perseids.org', email)

      emailer.send!
    end

    context 'there are no diffs from the previous' do
      let(:json) { Factory.json_fixture_json }

      it 'does not send email' do
        expect(mailer).to_not receive(:send_message)

        emailer.send!
      end
    end

    context 'there are fewer than two elements in the json' do
      let(:json) { Factory.json.first(1) }

      it 'does not send email' do
        expect(mailer).to_not receive(:send_message)

        emailer.send!
      end
    end
  end
end
