class MailWorker < ApplicationController
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform(email)
    UserMailer.finish_checkout(email).deliver_now
  end
end
