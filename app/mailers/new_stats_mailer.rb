class NewStatsMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.new_stats_mailer.send_email.subject
  #
  def send_email (to_user:, message:)
    mail(
      to: to_user,
      subject: "Stats generated",
      body: message
     )
  end
end
