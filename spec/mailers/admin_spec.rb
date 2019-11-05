require 'rails_helper'

RSpec.describe AdminMailer do
  let(:user) { Fabricate(:user) }

  describe '#contact_page_email' do
    let(:email) { Fabricate(:email, full_name: user.full_name, email: user.email) }
    let(:mail) { AdminMailer.contact_page_email(email.id) }

    it 'renders the recievers email' do
      expect(mail.to).to eq(['kasey@frankenkopter.com'])
    end

    it 'renders the subject' do
      expect(mail.subject).to eq("New email from #{user.full_name} || FrankenKopter Contact Form")
    end

    it 'generates a multipart message (plain text and html)' do
      expect(mail.body.parts.length).to eq(2)
      expect(mail.body.parts.collect(&:content_type)).to match_array(["text/html; charset=UTF-8", "text/plain; charset=UTF-8"])
    end

    context 'without a phone nubmer provided' do
      it 'renders the email body the user sent in html' do
        expect(mail.body.parts.find {|p| p.content_type.match /html/}.body).to include(email.message.body)
        expect(mail.body.parts.find {|p| p.content_type.match /html/}.body).not_to include('Phone Number:')
      end

      it 'renders the email body the user sent in plain text' do
        expect(mail.body.parts.find {|p| p.content_type.match /plain/}.body.raw_source).to include(email.message.to_plain_text)
        expect(mail.body.parts.find {|p| p.content_type.match /plain/}.body.raw_source).not_to include('Phone Number:')
      end
    end

    context 'with a phone number provided' do
      let(:email2) { Fabricate(:email, full_name: user.full_name, email: user.email, phone_number: '333-333-3333') }
      let(:mail2) { AdminMailer.contact_page_email(email2.id) }

      it 'renders the email body with phone number in html' do
        expect(mail2.body.parts.find {|p| p.content_type.match /html/}.body).to include(email2.phone_number)
      end

      it 'renders the email body with phone number in plain text' do
        expect(mail2.body.parts.find {|p| p.content_type.match /plain/}.body.raw_source).to include(email2.phone_number)
      end
    end
  end

  describe '#new_testimonial_email' do
    let(:testimonial) { Fabricate(:testimonial, user_id: user.id) }
    let(:mail) { AdminMailer.new_testimonial_email(user.id) }

    it 'renders the recievers email' do
      expect(mail.to).to eq(['kasey@frankenkopter.com'])
    end

    it 'renders the subject' do
      expect(mail.subject).to eq("New testimonial from #{user.full_name} || FrankenKopter Testimonial")
    end

    it 'generates a multipart message (plain text and html)' do
      expect(mail.body.parts.length).to eq(2)
      expect(mail.body.parts.collect(&:content_type)).to match_array(["text/html; charset=UTF-8", "text/plain; charset=UTF-8"])
    end

    it 'renders the email body in html' do
      expect(mail.body.parts.find {|p| p.content_type.match /html/}.body).to include('You have a new testimonial waiting for your review and approval!')
      expect(mail.body.parts.find {|p| p.content_type.match /html/}.body).to include("<a href='https://www.frankenkopter.com/sign_in'>")
    end

    it 'renders the email body in plain text' do
      expect(mail.body.parts.find {|p| p.content_type.match /plain/}.body.raw_source).to include('Go to https://www.frankenkopter.com/sign_in')
    end
  end
end
