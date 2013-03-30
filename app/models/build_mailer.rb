# BuildMailer is an ActionMailer class that understands how to send build status reports.
class BuildMailer < ActionMailer::Base

  def build_report(build, recipients, from, subject, message, sent_at = Time.now)
    @build               = build
    @message             = message
    @failures_and_errors = BuildLogParser.new(build.output).failures_and_errors.map { |e| formatted_error(e) }     
    @headers             = {}

    mail( :subject => "[CruiseControl] #{subject}",
          :to => recipients,
          :from => from,
          :date => sent_at )
  end

  def test(recipients,  sent_at = Time.now)
    @build               = nil
    @message             = 'Hi, mom'
    @failures_and_errors = []
    @headers             = {}

    mail( :subject => "Test CI E-mail",
          :to => recipients,
          :from => 'test@test.com',
          :date => sent_at )
  end

  def formatted_error(error)
    return "Name: #{error.test_name}\n" +
           "Type: #{error.type}\n" +
           "Message: #{error.message}\n\n" +
           error.stacktrace + "\n\n\n"
  end

end
