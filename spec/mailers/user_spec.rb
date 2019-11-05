require 'rails_helper'

RSpec.describe UserMailer do
  let(:user) { Fabricate(:user) }

  describe '#contact_page_email' do
    let(:email) { Fabricate(:email, full_name: user.full_name, email: user.email) }
    let(:mail) { UserMailer.contact_page_email(email.id) }

    it 'renders the recievers email' do
      expect(mail.to).to eq([user.email])
    end

    it 'renders the owners email' do
      expect(mail.from).to eq(['kasey@frankenkopter.com'])
    end

    it 'renders the subject' do
      expect(mail.subject).to eq("Thank you for contacting us!")
    end

    it 'generates a multipart message (plain text and html)' do
      expect(mail.body.parts.length).to eq(2)
      expect(mail.body.parts.collect(&:content_type))
        .to match_array(["text/html; charset=UTF-8", "text/plain; charset=UTF-8"])
    end

    it 'renders the email body in html' do
      expect(mail.body.parts.find {|p| p.content_type.match /html/}.body.raw_source)
        .to include("<a href='https://www.frankenkopter.com' title='FrankenKopter'>FrankenKopter</a>")
    end

    it 'renders the email body in plain text' do
      expect(mail.body.parts.find {|p| p.content_type.match /plain/}.body.raw_source)
        .to include('Thank you for contacting FrankenKopter')
    end
  end

  describe '#testimonial_link_email' do
    let(:mail) { UserMailer.testimonial_link_email(user.id) }

    it 'renders the recievers email' do
      expect(mail.to).to eq([user.email])
    end

    it 'renders the owners email' do
      expect(mail.from).to eq(['kasey@frankenkopter.com'])
    end

    it 'renders the subject' do
      expect(mail.subject).to eq("Your feedback is very important to us!")
    end

    it 'generates a multipart message (plain text and html)' do
      expect(mail.body.parts.length).to eq(2)
      expect(mail.body.parts.collect(&:content_type))
        .to match_array(["text/html; charset=UTF-8", "text/plain; charset=UTF-8"])
    end

    it 'renders the testimonial link in the body in html' do
      expect(mail.body.parts.find {|p| p.content_type.match /html/}.body.raw_source)
        .to include("<a href='www.frankenkopter.com/testimonial/#{user.testimonial_token}'>click here</a>")
    end

    it 'renders the testimonial link in the body in plain text' do
      expect(mail.body.parts.find {|p| p.content_type.match /plain/}.body.raw_source)
        .to include("www.frankenkopter.com/testimonial/#{user.testimonial_token}")
    end
  end

  describe '#thank_you_email' do
    let(:mail) { UserMailer.thank_you_email(user.id) }

    it 'renders the recievers email' do
      expect(mail.to).to eq([user.email])
    end

    it 'renders the owners email' do
      expect(mail.from).to eq(['kasey@frankenkopter.com'])
    end

    it 'renders the subject' do
      expect(mail.subject).to eq("Thank you for your feedback!")
    end

    it 'generates a multipart message (plain text and html)' do
      expect(mail.body.parts.length).to eq(2)
      expect(mail.body.parts.collect(&:content_type))
        .to match_array(["text/html; charset=UTF-8", "text/plain; charset=UTF-8"])
    end

    it 'renders the body in hmtl' do
      expect(mail.body.parts.find {|p| p.content_type.match /html/}.body.raw_source)
        .to be_present
    end

    it 'renders teh body in plain text' do
      expect(mail.body.parts.find {|p| p.content_type.match /plain/}.body.raw_source)
        .to be_present
    end
  end
end
