class User < ApplicationRecord
  attr_accessor :status_message_code, :status_message, :sent_code, :zen_send

  validates :mobile, presence: true
  validates :mobile, telephone_number: {country: :gb, types: [:mobile]}
  
  EXPIRATION_TIME = 3.minutes

  before_create do
    self.code            = rand_code
    self.code_expires_at = create_expiration
  end

  # to avoid duplicates (i.e. +44xxx, 44xxx, 0xxx) of the same number
  # this formats the number before lookups in find_or_create_by
  def self.find_or_create_with_valid_mobile(params)
    params[:mobile] = format_mobile(params[:mobile])
    find_or_create_by(params)
  end
  

  def check(code = nil)
    self.sent_code = code
    if code_expired?
      action_expired!
    elsif sent_code.present?
      action_code_present!
    else
      action_new_user!
    end
    self
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
    puts "sending code"
  #  self.zen_send =  begin
  #     ZenSend::Client.new(ENV['ZENSEND_KEY'])
  #       .send_sms(
  #         originator: ENV['ZENSEND_ORIGINATOR'],
  #         originator_type: :msisdn,
  #         numbers: [mobile],
  #         body: "heres your code for the fonix test :) #{code}"
  #       )
  #   rescue ZenSend::ZenSendException => e
  #     e
  #   end
  end


  def code_expired?
    Time.now > code_expires_at
  end

  def self.format_mobile(mobile)
    # formatting via attribute writer could result in empty mobile, returning
    # an error "mobile cannot be blank" which could be confusing. 
    # this triggers invalid number instead through the telephone_number gems built
    # in validation when the records attempts to save/is validated
    tn = TelephoneNumber.parse(mobile, :gb)
                       .international_number(formatted: false)
    if tn.blank? && !mobile.blank
      'invalid'
    else
      tn
    end
  end

  private

  def rand_code
    4.times.map{rand(10)}.join
  end

  def create_expiration
    Time.now + EXPIRATION_TIME
  end

end