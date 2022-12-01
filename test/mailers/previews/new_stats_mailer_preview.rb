# Preview all emails at http://localhost:3000/rails/mailers/new_stats_mailer
class NewStatsMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/new_stats_mailer/send_email
  def send_email
    NewStatsMailer.send_email
  end

end
