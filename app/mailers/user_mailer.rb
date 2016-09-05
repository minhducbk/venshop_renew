class UserMailer < ApplicationMailer
  default from: 'ducbm@zigexn.vn'

  def finish_checkout(email)
    mail(to: email, subject: 'Finish checkout in Venshop')
  end
end
