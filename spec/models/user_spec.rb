require 'rails_helper'

describe User do
  describe ".check_mobile" do
    it "registers a new user" do
      u = User.check_mobile(mobile: '07948981061')
      expect(u.status_message_code).to match('IS_NEW_USER')
    end
    
    it "knows if a code is correct" do
      u = User.create(mobile: '07948981061')
      u.update_attribute(:code, '1234')
      u = User.check_mobile(mobile: '07948981061', code: '1234')
      expect(u.status_message_code).to match('CODE_VALID')
    end
    
    it "knows if a code is incorrect" do
      u = User.create(mobile: '07948981061')
      u.update_attribute(:code, '1234')
      u = User.check_mobile(mobile: '07948981061', code: '4321')
      expect(u.status_message_code).to match('CODE_INVALID')
    end
    
    it "knows if a users code is expired" do
      u = User.create(mobile: '07948981061')
      u.update_attribute(:code_expires_at, Time.now - 1.minute)
      u.update_attribute(:code,'1234')
      u = User.check_mobile(mobile: '07948981061', code: '1234')
      expect(u.status_message_code).to match('CODE_EXPIRED')
    end
  end
end