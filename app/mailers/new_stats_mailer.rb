class NewStatsMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.new_stats_mailer.send_email.subject
  #
  def send_email (to_user:, file_name:)
    attachments[file_name] = File.read(file_name)
    mail(
      to: to_user,
      subject: "Stats generated",
     )
  end
end
