require 'net/smtp'

class PerseidsStatus
  class Emailer
    FROM = 'status@perseids.org'

    def initialize(json, email)
      @json = json
      @email = email
    end

    def send!
      return if diff_strings.empty?

      Net::SMTP.start('localhost') do |smtp|
        smtp.send_message(message, FROM, email)
      end
    end

    private

    attr_reader :json, :email

    def diff_strings
      return @diff_strings if @diff_strings
      return [] if json.length < 2

      @diff_strings = []

      older = json[1]
      newer = json[0]

      each_result(older, newer) do |test, name, older_result, newer_result|
        @diff_strings << diff_string(test, name, older_result, newer_result) unless older_result == newer_result
      end

      @diff_strings
    end

    def message
      headers =
        "From: Perseids Status <status@perseids.org>\n" \
        "To: <test@example.com>\n" \
        "Subject: Perseids Status\n"

      [headers, diff_strings.join("\n"), ''].join("\n")
    end

    def each_result(older, newer)
      newer.each do |test, pages|
        next if test == :location

        pages.each do |name, result|
          yield test, name, older[test][name], result if older[test] && older[test][name]
        end
      end
    end

    def diff_string(test, name, older_result, newer_result)
      "#{test}/#{name} doesn't match: #{older_result} -> #{newer_result}"
    end
  end
end
