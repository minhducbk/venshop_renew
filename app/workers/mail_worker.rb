class MailWorker < ApplicationController
  include Sidekiq::Worker

  def perform(email)
    UserMailer.finish_checkout(email).deliver_now
  end
end
