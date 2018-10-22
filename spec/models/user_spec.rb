require 'rails_helper'

TEST_MOBILE = '447948981061'

describe User do
  describe ".check_mobile" do
    it "registers a new user" do
      u = User.check_mobile(mobile: TEST_MOBILE)
      expect(u.status_message_code).to match('IS_NEW_USER')
    end
    
    it "knows if a code is correct" do
      u = User.create(mobile: TEST_MOBILE)
      u.update_attribute(:code, '1234')
      u = User.check_mobile(mobile: TEST_MOBILE, code: '1234')
      expect(u.status_message_code).to match('CODE_VALID')
    end
    
    it "knows if a code is incorrect" do
      u = User.create(mobile: TEST_MOBILE)
      u.update_attribute(:code, '1234')
      u = User.check_mobile(mobile: TEST_MOBILE, code: '4321')
      expect(u.status_message_code).to match('CODE_INVALID')
    end
    
    it "knows if a users code is expired" do
      u = User.create(mobile: TEST_MOBILE)
      u.update_attribute(:code_expires_at, Time.now - 1.minute)
      u.update_attribute(:code,'1234')
      u = User.check_mobile(mobile: TEST_MOBILE, code: '1234')
      expect(u.status_message_code).to match('CODE_EXPIRED')
    end
  end

  describe "#send_code" do
    it "sends a text message and receives no error class" do
      u = User.create(mobile: TEST_MOBILE)
      u.send_code
      expect(u.zen_send.class.to_s).to match("ZenSend::SmsResponse")
    end
  end
end