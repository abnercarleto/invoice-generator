require "rails_helper"

RSpec.describe Identity::UserMailer, type: :mailer do
  describe '#new_token' do
    let(:email) { 'email@email.com' }
    let(:token) { SecureRandom.hex }

    subject(:mail) { described_class.with(email: email, token: token).new_token }

    it { expect(mail.subject).to eq 'Your access token' }
    it { expect(mail.from).to eq ['noreplay@invoicegenerator.com'] }
    it { expect(mail.to).to eq [email] }

    describe 'renders the body' do
      subject { mail.body.encoded }

      it { is_expected.to match("Seu token é <code>#{token}<code>.") }
    end
  end
end
