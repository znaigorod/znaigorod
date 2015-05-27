class AnketaMailer < MandrillMailer
  default :from => "\"znaigorod.ru\" <#{Settings['mail']['from']}>"
  layout "notice_layout"

  def send_anketa(work)
    @work = work
    @type = 'anketa'

    mail(:to => work.context.email, :subject => 'На сайте ЗнайГород добавлена новая анкета для конкурса "Мисс Офис 2015"')
  end
end