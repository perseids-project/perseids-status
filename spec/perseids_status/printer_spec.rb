RSpec.describe PerseidsStatus::Printer do
  let(:request_map) { Factory.request_map }

  subject(:printer) { PerseidsStatus::Printer.new(request_map) }

  describe '#print' do
    it 'prints the diffs' do
      expect { printer.print }.to output(
        "fruit/pear doesn't match (diff)\n" \
        "vegetable/onion doesn't match (wc)\n",
      ).to_stdout
    end

    context 'there are no diffs' do
      let(:request_map) { Factory.request_map_with_no_diffs }

      it 'does not print anything' do
        expect { printer.print }.to_not output.to_stdout
      end
    end
  end
end
