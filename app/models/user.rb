class User < ApplicationRecord
  attr_accessor :status_message_code, :status_message, :sent_code
  
  EXPIRATION_TIME = 3.minutes

  before_create do
    self.code            = rand_code
    self.code_expires_at = create_expiration
  end

  def self.check_mobile(args)
    mobile         = args[:mobile]
    user           = find_or_create_by(mobile: mobile)
    user.sent_code = args[:code]

    if user.code_expired?
      user.action_expired!
    elsif user.sent_code.present?
      user.action_code_present!
    else
      user.action_new_user!
    end
    user
  end

  def action_expired!
    self.reset!
    self.send_code
    self.status('CODE_EXPIRED_RESENT', 'The code expired, a new one has been sent 👍')
  end

  def action_code_present!
    if code == sent_code
      self.status('CODE_VALID', 'The code was valid!')
    else
      self.status('CODE_INVALID', 'That code didnt match up :( please try again!')
    end
  end

  def action_new_user!
    send_code
    self.status('IS_NEW_USER', 'Welcome new user! a code has been sent :)')
  end

  def reset!
    self.code = rand_code
    self.code_expires_at = create_expiration
    save
  end

  def status(message_code, message='')
    self.status_message_code = message_code
    self.status_message = message
  end

  def send_code
    puts "\n*** SENDING CODE #{code}, to #{mobile} ****\n"
  end

  def code_expired?
    Time.now > code_expires_at
  end

  private

  def rand_code
    4.times.map{rand(10)}.join
  end

  def create_expiration
    Time.now + EXPIRATION_TIME
  end

end
