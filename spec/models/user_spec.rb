require 'rails_helper'

RSpec.describe User do
  # it { should have_one(:person) }
  # let(:user) { create(:user) }
  let(:user) { User.create(email: 'asd@las.com', password: 'secret', name: 'Gorilla') }

  describe 'email typos' do
    subject do
      described_class.new(email: "teste@#{email}", password: 'password', name: 'Gorilla Sausage-fingers')
                     .tap(&:validate).email
    end

    { 'test.con.br' => 'test.com.br',
      'test.om.br' => 'test.com.br',
      'test.con' => 'test.com',
      'test.om' => 'test.com',
      'gmail.com.br' => 'gmail.com',
      'gmil.com' => 'gmail.com',
      'gamil.com' => 'gmail.com',
      'gmsil.com' => 'gmail.com',
      'gamail.com' => 'gmail.com',
      'gmial.com' => 'gmail.com',
      'gmal.com' => 'gmail.com',
      'gmai.com' => 'gmail.com',
      'gnail.com' => 'gmail.com',
      'hotmal.com' => 'hotmail.com',
      'hotmai.com' => 'hotmail.com',
      'hotnail.com' => 'hotmail.com',
      'hormail.com' => 'hotmail.com',
      'homail.com' => 'hotmail.com' }.each do |bad, good|
      context "if the user types #{bad}" do
        let(:email) { bad }
        it { is_expected.to eq("teste@#{good}") }
      end
    end
  end

  # describe 'password change' do
  #   it 'revokes all current tokens' do
  #     expect { user.update(password: 'barfoo') }.to change(user, :expired_at)
  #   end
  #   it 'does not revoke tokens when another attribute changes' do
  #     expect { user.update(name: 'T. Ester') }.not_to change(user, :expired_at)
  #   end
  # end

  # describe 'tokenable' do
  #   it 'creates valid tokens' do
  #     token = user.token
  #     claims = ::JsonWebToken.decode(token).first.symbolize_keys
  #     expect(claims).to include(type: 'access_token',
  #                               user: { 'id' => user.id,
  #                                       'name' => user.name,
  #                                       'email' => user.email })
  #     expect(Time.zone.at(claims[:exp])).to be > Time.zone.now

  #     Timecop.freeze(2.days.from_now) do
  #       expect { ::JsonWebToken.decode(token) } .to raise_error(JWT::ExpiredSignature)
  #     end
  #   end
  #   it 'creates valid refresh tokens' do
  #     refresh_token = user.refresh_token
  #     claims = ::JsonWebToken.decode(refresh_token).first.symbolize_keys
  #     expect(claims).to include type: 'refresh_token',
  #                               user: { 'id' => user.id,
  #                                       'name' => user.name,
  #                                       'email' => user.email }
  #     expect(Time.zone.at(claims[:exp])).to be > Time.zone.now

  #     Timecop.freeze(2.years.from_now) do
  #       expect { ::JsonWebToken.decode(refresh_token) } .to raise_error(JWT::ExpiredSignature)
  #     end
  #   end
  # end

  describe '#first_name' do
    it 'retrieves the first name of the user, capitalized' do
      user.name = 'Test testson'
      expect(user.first_name).to eq 'Test'
      expect(user.surname).to eq 'testson'
      user.first_name = 'bob'
      expect(user.name).to eq 'bob testson'
    end
  end
end
